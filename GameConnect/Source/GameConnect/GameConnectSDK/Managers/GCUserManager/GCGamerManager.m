//
//  NSLEEventManager.m
//  PepsiLiveGaming
//
//  Created by Derivery Guillaume on 9/12/13.
//  Copyright (c) 2013 Seb Jallot. All rights reserved.
//

#import "Extends+Libs.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GCGamerManager.h"
#import "GCConfManager.h"
#import "GCRequester.h"
#import "GCEventModel.h"
// TODO: UArena disabled
//#import "GCLoggerManager.h"
#import "NsSnUserManager.h"
#import "GCFayeWorker.h"

@implementation GCGamerManager

+(GCGamerManager *)getInstance
{
    static GCGamerManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[GCGamerManager alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        _platformsAvailabilityCheckDone = YES;
        _platformsAvailabilityCheckRequested = NO;
        _isPlatformAvailableToPlay = YES;
        _user_generated_token = nil;
        _gamer = nil;
    }
    return self;
}

#pragma mark - Check platform
-(void) checkPlatformsAvailability:(void(^)(BOOL isPlatformAvailableToPlay))callbackCheck
{
    NSString *storedLogin = @"";
    if ([self canReconect])
    {
        NSDictionary *d = [NSDictionary getDataFromFile:@"nssn-connect.txt" temps:(365*24*60*60)];
        if (d)
            storedLogin = d[@"l"];
    }
    [GCRequester requestGET:[storedLogin length] > 0 ? SWF(@"%@/%@", [GCConfManager getURL:CGURLGETPlatformAvailability], storedLogin) : [GCConfManager getURL:CGURLGETPlatformAvailability] cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
        _platformsAvailabilityCheckDone = YES;
        if (rep)
        {
            _isPlatformAvailableToPlay = [[rep getXpathEmptyString:@"can_play"]isEqualToString:@"ok"] ? YES : NO;
        }
        else
            _isPlatformAvailableToPlay = NO;
        _platformsAvailabilityCheckRequested = NO;
        
//#warning TO CHANGE FOR PRODUCTION ONCE ITS FINISHED SERVER SIDE
//        _isPlatformAvailableToPlay = NO;

        [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_PLATFORM_CHECKED object:nil];
        
        if (callbackCheck)
            callbackCheck(_isPlatformAvailableToPlay);

    } cache:NO];
    _platformsAvailabilityCheckRequested = YES;
}


#pragma mark - Authentification NSAPI
-(void)autologin:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSDictionary *d = [NSDictionary getDataFromFile:@"nssn-connect.txt" temps:(365*24*60*60)];
    if (!d)
    {
        [NSObject removeFileDoc:@"nssn-connect.txt"];
        cb_rep(NO, NsSnUserErrorValueNotLoggedIn);
        return;
    }
    NSString *email = d[@"l"];
    NSString *pwd = d[@"p"];
    if (email && pwd) {
        [self loginByMail:email passe:pwd cb_rep:cb_rep];
    }
}

-(void)didLogInWithCompletion:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSString *deviceIdentifier = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    if (TARGET_IPHONE_SIMULATOR){
        deviceIdentifier = @"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
    }
    // Generate GC Token => NSAPI UserID + NSAPI UserCreationDate + UDID
    _user_generated_token = [[NSString stringWithFormat:@"%@%@%@", [NsSnUserManager getInstance].user._id,
                              [NSNumber numberWithInteger:[NsSnUserManager getInstance].user.user_created_at],
                              deviceIdentifier] sha1];
    
    NSLog(@">>>>>>>>>>>>>>> UDID >>>>>>>>>>>>>>>>>>> %@", deviceIdentifier);
    NSLog(@">>>>>>>>>>>>>>> TOKEN >>>>>>>>>>>>>>>>>>> %@", _user_generated_token);
    [[NsSnUserManager getInstance] updateUserMetadatas:@{@"metadata[GC_KEY]" : self.user_generated_token} cb_rep:^(BOOL ok, NSDictionary *rep)
     {
         _gamer = [GCGamerModel new];
         _gamer._id = [NsSnUserManager getInstance].user._id;
         _gamer.login = [NsSnUserManager getInstance].user.user_nickname;
         [self loadConnectedGamerAvatar];
         
         NSLog(@"[LOGGED IN] ID : %@", _gamer._id);
         [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_LOGGEDIN object:nil userInfo:@{@"user" : _gamer}];
         cb_rep(YES, NsSnUserErrorValueNone);
     }];
}

-(void)loginByMail:(NSString*)email passe:(NSString*)password cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    __weak GCGamerManager *weak_self = self;
    [[NsSnUserManager getInstance] loginByMail:email passe:password post:nil cb_rep:^(BOOL ok, NsSnUserErrorValue error)
    {
        if (ok)
            [weak_self didLogInWithCompletion:cb_rep];
        else
            cb_rep(NO, error);
    }];
}

-(void)subscribeAPI:(NsSnSignModel*)user cb_rep:(void (^)(BOOL inscription_ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    [[NsSnSignManager getInstance] subscribeAPI:user cb_rep:^(BOOL inscription_ok, NSDictionary *rep, NsSnUserErrorValue error)
     {
         cb_rep(inscription_ok, rep, error);
     }];
}

-(void)loginBySSOTVA:(NSString *)tokenSSO cb_rep:(void(^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    __weak GCGamerManager *weak_self = self;
    [[NsSnUserManager getInstance] loginTVA:tokenSSO cb_rep:^(BOOL ok, NsSnUserErrorValue error)
    {
        if (ok)
            [weak_self didLogInWithCompletion:cb_rep];
        else
            cb_rep(NO, error);
    }];
}

-(void)updateUserMetadatas:(NSDictionary *)post cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep
{
    [[NsSnUserManager getInstance] updateUserMetadatas:@{@"metadata[GC_KEY]" : self.user_generated_token} cb_rep:cb_rep];
}

-(BOOL) isLoggedIn
{
    return [[NsSnUserManager getInstance] isLoggedIn];
}

-(BOOL) isLoggingIn
{
    return [[NsSnUserManager getInstance] isLoggingIn];
}

-(BOOL) canReconect
{
    return [[NsSnUserManager getInstance] canReconect];
}

-(void)logout:(void (^)(void))cb_rep
{
    if ([FBSettings defaultAppID] && FBSession.activeSession)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
    }

    [[GCFayeWorker getInstance] shutdownFayeClient];
    [[NsSnUserManager getInstance] logout:^{
        
        _gamer = nil;
        _user_generated_token = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_LOGGEDOUT object:nil userInfo:nil];
        if (cb_rep)
            cb_rep();
    }];
}

-(void)updateUserProfile:(NSDictionary *)post cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep
{
    [[NsSnUserManager getInstance] updateUserProfile:post cb_rep:cb_rep];
}

-(void)updateUserPassword:(NSString *)newPassword cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep
{
    [[NsSnUserManager getInstance] updateUserPassword:newPassword cb_rep:cb_rep];
}

#pragma mark - Avatar
-(void) setConnectedGamerAvatar:(UIImage *)imageAvatar
{
    _connectedGamerAvatar = imageAvatar;
    [NSObject removeFileDoc:SWF(LOCAL_AVATAR_FILENAME_FORMAT, self.gamer._id)];
    [imageAvatar saveImageInFile:SWF(LOCAL_AVATAR_FILENAME_FORMAT, self.gamer._id)];
}

-(void) loadConnectedGamerAvatar
{
    UIImage *savedImage = [UIImage loadImageFromFile:SWF(LOCAL_AVATAR_FILENAME_FORMAT, self.gamer._id) inTime:CACHE_NSAPI_GC];
    _connectedGamerAvatar = savedImage;
}

-(void)uploadAvatar:(UIImage *)imageAvatar cb_send:(void (^)(long long total, long long current))cb_send cb_rep:(void (^)(GCGamerModel *gamer))cb_rep
{
    [[NsSnUserManager getInstance] uploadAvatar:imageAvatar cb_send:cb_send cb_rep:^(NSDictionary *rep, NsSnUserErrorValue error) {
        if (rep && self.gamer)
            self.gamer.Avatar_formats = [[NsSnUserManager getInstance].user.Avatar_formats copy];

      if (cb_rep) {
        if (error == NsSnUserErrorValueNone)
          cb_rep(self->_gamer);
        else
          cb_rep(nil);
      }
    }];
}

#pragma mark - Profile GameConnect
-(void) getTrophiesForGamer:(NSString *)gamerID cb_response:(void (^)(NSArray *trophies))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETGamerTrophies], gamerID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
      // TODO: UArena disabled
//        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (rep)
            cb_response([GCTrophyModel fromJSONArray:[rep getXpathNilArray:@"trophies"]]);
        else
            cb_response(@[]);
    } cache:NO];
}

-(void) getProfileForGamer:(NSString *)gamerID cb_response:(void (^)(GCGamerModel *gamer))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETGamer], gamerID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
      // TODO: UArena disabled
//        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        GCGamerModel *profileGamer = [GCGamerModel fromJSON:[rep getXpathNilDictionary:@"gamer"]];

        if ([profileGamer._id isEqualToString:[NsSnUserManager getInstance].user._id])
        {
            double diffUpdateTime = [[NSDate date] timeIntervalSince1970] - _gamer.date_update;
            if (diffUpdateTime >= CACHE_NSAPI_GC)
                _gamer = profileGamer;
            else
            {
                profileGamer.login = _gamer.login;
                _gamer._id = profileGamer._id;
                _gamer.global_rank = profileGamer.global_rank;
                _gamer.global_score = profileGamer.global_score;
                _gamer.Avatar_formats = profileGamer.Avatar_formats;
            }
        }
        cb_response(profileGamer);
    } cache:NO];
}

-(void) getPlayedEventsForGamer:(NSString *)gamerID inCompetition:(NSString *)competitionID cb_response:(void (^)(NSArray *playedEvents))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETGamerPlayedEvents], gamerID, competitionID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
     {
       // TODO: UArena disabled
//         GCLog(GCHTTPResponseLog, (long)httpcode, url);
         if (rep)
         {
             NSArray *arrayPlayedEvents = [GCEventModel fromJSONArray:[rep getXpathNilArray:@"events"]];
             cb_response(arrayPlayedEvents);
         }
         else
             cb_response(@[]);
     } cache:NO];
}

@end
