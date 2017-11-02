//
//  NsSnUserManager.m
//  NsSn
//
//  Created by adelskott on 20/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "Extends+Libs.h"
#import "NsSnUserManager.h"
#import "NsSnConfManager.h"
#import "NsSnRequester.h"
#import "Extends+Libs.h"
#import "NsSnFriendModel.h"
#import "NsSnSubscribeModel.h"
#import "NsSnMetadataModel.h"
#import "NsSnThirdPartyModel.h"
//#import "PSGOneApp-Swift.h"

@interface NsSnUserManager()
@end

@implementation NsSnUserManager

+(NsSnUserManager *)getInstance{
    static NsSnUserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnUserManager alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        _isLoggingIn = NO;
        _user = nil;
    }
    return self;
}


-(void)setMyUser:(NsSnUserModel *)model{
    _user = model;
}


#pragma mark - Log in
-(BOOL) isLoggedIn
{
    return !!self.user || !!self.user._id;
}

-(BOOL)isLoggedInUsingThirdParty
{
    if (self.user && self.user.third_partys && [self.user.third_partys count] > 0)
        return true;
    return false;
}

-(BOOL)canReconect
{
    return !![NSDictionary getDataFromFile:@"nssn-connect.txt" temps:(365*24*60*60)];
}

-(void)loginByMail:(NSString*)email
             passe:(NSString*)password
              post:(NSDictionary*)post
            cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    _isLoggingIn = YES;

	NSString *app_bundle = [[NSBundle mainBundle] bundleIdentifier];
	NSString *device_uid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    NSString *device_model = [[UIDevice currentDevice] model];
    NSString *device_version = [[UIDevice currentDevice] systemVersion];
    
    NSMutableDictionary *postParams = [@{
                                         @"email" : email,
                                         @"password":password,
                                         @"app_bundle": app_bundle,
                                         @"device_uid": device_uid,
                                         @"device_model": device_model,
                                         @"device_version": device_version,
                                         } ToMutable];
    
    [post each:^(id key, id elt)
     {
         if ([elt isKindOfClass:[NSArray class]] || [elt isKindOfClass:[NSDictionary class]])
         {
             NSError *writeError = nil;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:elt options:NSJSONWritingPrettyPrinted error:&writeError];
             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             if (!writeError)
                 elt = jsonString;
         }
         [postParams setObject:elt forKey:key];
     }];
    NSLog(@"Post for login => %@", [postParams description]);
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLLoginByMail] post:postParams cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         if (rep && !cache)
         {
             NSDictionary *user_data = [rep getXpathNilDictionary:@"user"];
             if ((error == NsSnUserErrorValueNone || error == NsSnUserErrorValueUnknown) && user_data)
             {
                 _user = [NsSnUserModel fromJSON:user_data];
                 uid = _user._id;
                 
                 [@{@"l" : email, @"p":password} setDataSaveNSDictionary:@"nssn-connect.txt"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NSSNNOTIF_LOGGEDIN object:nil userInfo:@{@"user" : [NsSnUserManager getInstance].user}];
                 cb_rep(YES, error);
             }
             else
             {
                 [NSObject removeFileDoc:@"nssn-connect.txt"];
                 _user = nil;
                 cb_rep(NO, error);
             }
         }
         else if (!cache)
             cb_rep(NO, error);
         else
             cb_rep(NO, error);
         _isLoggingIn = NO;
     } cache:NO];
}

-(void)autologin:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSDictionary *d = [NSDictionary getDataFromFile:@"nssn-connect.txt" temps:(365*24*60*60)];
    if (!d)
    {
        [NSObject removeFileDoc:@"nssn-connect.txt"];
        _user = nil;
        cb_rep(NO, NsSnUserErrorValueNotLoggedIn);
        return;
    }
    NSString *email = d[@"l"];
    NSString *pwd = d[@"p"];
//    [self login:l passe:p  post:post cb_rep:cb_rep];
    [self loginByMail:email passe:pwd post:post cb_rep:cb_rep];
}

-(void)logout:(void (^)(void))cb_rep{
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLLogout] cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error){
        [NSObject removeFileDoc:@"nssn-connect.txt"];
        _isLoggingIn = NO;
        _user = nil;
        if (cb_rep)
            cb_rep();
    } cache:NO];
}

#pragma mark - Secutix
-(void)autologinSecutix:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSDictionary *d = [NSDictionary getDataFromFile:@"nssn-connect.txt" temps:(365*24*60*60)];
    if (!d)
    {
        [NSObject removeFileDoc:@"nssn-connect.txt"];
        _user = nil;
        cb_rep(NO, NsSnUserErrorValueNotLoggedIn);
        return;
    }
    NSString *l = d[@"l"];
    NSString *p = d[@"p"];
    [self loginSecutix:l passe:p  post:post cb_rep:cb_rep];
}

-(void)loginSecutix:(NSString*)login passe:(NSString*)password post:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep{
	NSString *app_bundle = [[NSBundle mainBundle] bundleIdentifier];
	NSString *device_uid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    NSString *device_model = [[UIDevice currentDevice] model];
    NSString *device_version = [[UIDevice currentDevice] systemVersion];
    
    NSMutableDictionary *postParams = [@{
                                         @"email":login,
                                         @"password":password,
                                         @"app_bundle": app_bundle,
                                         @"device_uid": device_uid,
                                         @"device_model": device_model,
                                         @"device_version": device_version,
                                         } ToMutable];
    [post each:^(id key, id elt) {
        if ([elt isKindOfClass:[NSArray class]] || [elt isKindOfClass:[NSDictionary class]]){
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:elt options:NSJSONWritingPrettyPrinted error:&writeError];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (!writeError)
                elt = jsonString;
        }
        [postParams setObject:elt forKey:key];
    }];
    
    DLog(@"Post for login secutix => %@", [postParams description]);
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLLoginSecutix] post:postParams cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep && !cache)
        {
            NSDictionary *user_data = [rep getXpathNilDictionary:@"user"];
            NSDictionary *secutix_login = [rep getXpathNilDictionary:@"secutix_login"];
            if ((error == NsSnUserErrorValueNone || error == NsSnUserErrorValueUnknown) && user_data && secutix_login)
            {
                NSMutableDictionary *dic = [[user_data ToMutable] dictionaryByMergingDictionary:secutix_login];
                _user = [NsSnUserModel fromJSON:dic];
                uid = _user._id;
                [@{@"l":login,@"p":password} setDataSaveNSDictionary:@"nssn-connect.txt"];
                cb_rep(YES, error);
//                [[NsSnUserManager getInstance] updateUserMetadatas:@{@"metadata[sdf_is_in_stade]":@"1"}  cb_rep:^(BOOL ok, NSDictionary *rep){
//                }];
            }
            else{
                [NSObject removeFileDoc:@"nssn-connect.txt"];
                _user = nil;
                cb_rep(NO, error);
            }
        }
        else if (!cache){
            cb_rep(NO, error);
        }
        else{
            cb_rep(NO, error);
        }
    } cache:NO];
}

-(void)recoverPasswordSecutix:(NSString *)email cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLRecoverPasswordSecutix], email];
    [NsSnRequester request:url post:nil cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         cb_rep(YES, error);
     } credential:nil cache:NO];
}

-(void)logoutSecutix:(void (^)(void))cb_rep{
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLLogout] cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error){
        [NSObject removeFileDoc:@"nssn-connect.txt"];
        _user = nil;
        if (cb_rep)
            cb_rep();
    } cache:NO];
}

#pragma mark - TVA
-(void)loginTVA:(NSString *)tokenSSO cb_rep:(void(^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSString *urlForLoginTVA = [[NsSnConfManager getInstance] getURL:NsSnConfigURLLoginTVA];
    
    if (!tokenSSO || [tokenSSO length] == 0)
    {
        DLog(@"Bad token passed to loginTVA method /!\\");
        cb_rep(NO, NsSnUserErrorValueUnknown);
        return ;
    }

    [NsSnRequester request:urlForLoginTVA post:@{@"token" : tokenSSO} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        if (rep && !cache)
        {
            NSDictionary *user_data = [rep getXpathNilDictionary:@"user"];
            if ((error == NsSnUserErrorValueNone || error == NsSnUserErrorValueUnknown) && user_data)
            {
                _user = [NsSnUserModel fromJSON:user_data];
                uid = _user._id;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NSSNNOTIF_LOGGEDIN object:nil userInfo:@{@"user" : [NsSnUserManager getInstance].user}];
                cb_rep(YES, error);
            }
            else
            {
                _user = nil;
                cb_rep(NO, error);
            }
        }
        else if (!cache)
            cb_rep(NO, error);
        else
            cb_rep(NO, error);
    } cache:NO];
}

#pragma mark - Update data
-(void)refreshUser:(void (^)(BOOL ok))cb_rep
{
    if (self.user)
        [self getUser:self.user cb_rep:^(NsSnUserModel *user,BOOL cache) {
            cb_rep(YES);
        }];
}

-(void)updateUserProfile:(NSDictionary *)post cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep
{
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLUserUpdateProfile] post:post cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        NSDictionary *user_data = nil;
        if (rep)
        {
            user_data = [rep getXpathNilDictionary:@"user"];
            NsSnUserModel *userUpdated = [NsSnUserModel fromJSON:user_data];
            if ([userUpdated._id isEqual:self.user._id])
                _user = userUpdated;
        }
        cb_rep(user_data, error);
    } cache:NO];
}

-(void)updateUserPassword:(NSString *)newPassword cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep
{
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLUserUpdatePassword] post:@{@"password" : newPassword} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         if (rep)
         {
             NSString *password_change = [rep getXpathEmptyString:@"password_changed"];
             if ([password_change isEqualToString:@"ok"])
             {
                 [NSObject removeFileDoc:@"nssn-connect.txt"];
                 [@{@"l" : self.user.user_nickname, @"p" : newPassword} setDataSaveNSDictionary:@"nssn-connect.txt"];
                 cb_rep(YES, rep);
                 return ;
             }
         }
         cb_rep(NO, rep);
     } cache:NO];
}

-(void)updateUserMetadatas:(NSDictionary *)post cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep
{
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLUserUpdateMetadatas] post:post cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         DLog(@"REP UP METADATA : %@", [rep description]);
         if (rep)
         {
             NSArray *user_metadata = [rep getXpathNilArray:@"user/metadata"];
             if ((error == NsSnUserErrorValueNone || error == NsSnUserErrorValueUnknown) && user_metadata)
             {
                 _user.Metadata = [NsSnMetadataModel fromJSONArray:user_metadata];
                 cb_rep(YES, rep);
             }
             else
             {
                 cb_rep(NO, rep);
             }
         }
         else
         {
             cb_rep(NO, rep);
         }
     } cache:NO];
}

#pragma mark - Searching
-(BOOL)isMe:(NSString*)tuid
{
    return [self.user._id isEqualToString:tuid];
}

-(void)search:(NSDictionary *)datas page:(NSInteger)page limit:(NSInteger)limit post:(NSDictionary *)post cb_rep:(void (^)(BOOL ok, NSArray *users, NSInteger nbUser))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLUserSearchByMetadatasPaginated], page, limit];
    if (page == 0 && limit == 0)
        url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLUserSearchByMetadatas];
    
    [NsSnRequester request:url post:datas cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSLog(@"search REP : %@", [rep description]);
        if (rep){
            NSArray *users = [NsSnUserModel fromJSONArray:[rep getXpathNilArray:@"users"]];
            if ((error == NsSnUserErrorValueNone || error == NsSnUserErrorValueUnknown) && users){
                cb_rep(YES, users, [rep getXpathInteger:@"count"]);
            }
            else{
                cb_rep(NO, nil, 0);
            }
        }
        else{
            cb_rep(NO, nil, 0);
        }
    } cache:NO];
}

-(NsSnUserModel *)findUser:(NsSnUserModel *)user inArray:(NSArray *)users{
    for (NsSnUserModel *u in users){
        if ([user._id isEqualToString:u._id]){
            return u;
        }
    }
    return nil;
}

#pragma mark - User data
-(void)getUser:(NsSnUserModel *)user cb_rep:(void (^)(NsSnUserModel*user,BOOL cache))cb_rep{
    
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLUserInfo], user._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil,false);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep){
            NsSnUserModel *m = [NsSnUserModel fromJSON:[rep getXpathNilDictionary:@"user"]];
            if ([m._id isEqualToString:uid])
                _user = m;
            cb_rep(m, cache);
        }
    } cache:YES];
}

-(void)uploadAvatar:(UIImage *)imageAvatar cb_send:(void (^)(long long total, long long current))cb_send cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep
{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLUploadAvatar];
    //    [NsSnUserManager getInstance].user.upAvatar = imageAvatar;
    //    NSDictionary *dic = [[NsSnUserManager getInstance].user toDictionary];
    
    NSDictionary *postDic = @{@"datas_with_content_type" : @[@{@"name": @"image", @"content_type": @"image/jpeg", @"datas": imageAvatar}]};
    postDic = @{@"test" : @"img", @"image" : imageAvatar};
    
    [NsSnRequester request:url post:postDic cb_send:^(long long total, long long current) {
        if (cb_send) {
            cb_send(total, current);
        }
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error){
        //        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"UP Avatar : %@", str);
        
        NsSnUserModel *me = [NsSnUserModel fromJSON:[rep getXpathNilDictionary:@"user"]];
        _user = nil;
        _user = me;
        if (cb_rep) {
            cb_rep(rep, error);
        }
    } credential:nil cache:NO];
}

-(void)reportAbuse:(NSString *)userId cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLUserReportAbuse], userId];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         cb_rep(rep,error);
     } cache:NO];
}

-(void)getTopUsers:(void (^)(NSArray *topUser,NsSnUserErrorValue error,BOOL cache))cb_rep{
    
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLUserTop];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSArray *a = [rep getXpathNilArray:@"/feeds/feeds"];
        cb_rep([NsSnUserModel fromJSONArray:a],error,cache);
    } cache:YES];
}

#pragma mark - Friends management
-(void)actionFriend:(NsSnUserModel *)user add:(BOOL)add cb_rep:(void (^)(BOOL ok))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendAdd], user._id];
    if (!add)
        url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendRemove], user._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep && error == NsSnUserErrorValueNone){
            cb_rep(YES);
        }
        else {
            cb_rep(NO);
        }
    } cache:NO];
}

-(void)acceptFriend:(NsSnUserModel *)user cb_rep:(void (^)(BOOL ok))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendAcceptPending], user._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep && error == NsSnUserErrorValueNone){
            cb_rep(YES);
        }
        else {
            cb_rep(NO);
        }
    } cache:NO];
}

-(void)refuseFriend:(NsSnUserModel *)user cb_rep:(void (^)(BOOL ok))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendDenyPending], user._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep && error == NsSnUserErrorValueNone){
            cb_rep(YES);
        }
        else {
            cb_rep(NO);
        }
    } cache:NO];
}


-(void)getFriendsList:(NsSnUserModel *)user cb_rep:(void (^)(NsSnUserModel *user, BOOL ok))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendsList], user._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil, NO);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep){
            user.Friends = [NsSnUserModel fromJSONArray:[rep getXpathNilArray:@"friends"] withFriendPendingType:FriendAlreadyConfirmed];
            cb_rep(user, YES);
        }
        else {
            cb_rep(nil, NO);
        }
    } cache:NO];
}

-(void)getFriendsListPendingOutgoing:(void (^)(BOOL ok))cb_rep{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendsListPendingOutgoing];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep){
            self.user.FriendsPendingOutgoing = [NsSnUserModel fromJSONArray:[rep getXpathNilArray:@"friends"] withFriendPendingType:FriendPendingOutgoing];
            cb_rep(YES);
        }
        else {
            cb_rep(NO);
        }
    } cache:NO];
}

-(void)getFriendsListPendingIncoming:(void (^)(BOOL ok))cb_rep{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendsListPendingIncoming];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep){
            self.user.FriendsPendingIncoming = [NsSnUserModel fromJSONArray:[rep getXpathNilArray:@"friends"] withFriendPendingType:FriendPendingIncoming];
            cb_rep(YES);
        }
        else {
            cb_rep(NO);
        }
    } cache:NO];
}

-(void)getFriendsListPaginated:(NsSnUserModel *)user page:(NSInteger)page limit:(NSInteger)limit cb_rep:(void (^)(BOOL ok, NSInteger nbFriends, NsSnUserModel *user))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFriendsListPaginated], user._id, page, limit];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO, 0, user);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        if (rep)
        {
            user.Friends = [NsSnUserModel fromJSONArray:[rep getXpathNilArray:@"friends"] withFriendPendingType:FriendAlreadyConfirmed];
            cb_rep(YES, [rep getXpathInteger:@"count"], user);
        }
        else
        {
            cb_rep(NO, 0, user);
        }
    } cache:NO];
}

-(void)getAllMyFriendsListPaginated:(NSInteger)page limit:(NSInteger)limit cb_rep:(void (^)(BOOL ok, NSInteger nbFriends))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLAllMyFriendsListPaginated], page, limit];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO, 0);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (rep){
            self.user.AllFriends = [NsSnUserModel fromJSONArray:[rep getXpathNilArray:@"friends"]];
            NSMutableArray *friends = [[NSMutableArray alloc] init];
            NSMutableArray *friendsInc = [[NSMutableArray alloc] init];
            NSMutableArray *friendsOut = [[NSMutableArray alloc] init];
            for (NsSnUserModel *user in self.user.AllFriends){
                if (user.friends_pending_status == FriendAlreadyConfirmed){
                    [friends addObject:user];
                }
                else if (user.friends_pending_status == FriendPendingIncoming){
                    [friendsInc addObject:user];
                }
                else if (user.friends_pending_status == FriendPendingOutgoing){
                    [friendsOut addObject:user];
                }
            }
            self.user.Friends = [friends ToUnMutable];
            self.user.FriendsPendingIncoming = [friendsInc ToUnMutable];
            self.user.FriendsPendingOutgoing = [friendsOut ToUnMutable];
            
            cb_rep(YES, [rep getXpathInteger:@"count"]);
        }
        else {
            cb_rep(NO, 0);
        }
    } cache:NO];
}

#pragma mark - Third party
+(void)getFaceBookFriendsIDs:(void(^)(NSArray *friends))cb
{
    BOOL ret = [FBSession openActiveSessionWithAllowLoginUI:NO];
    if (!ret)
        return cb(nil);
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result getXpathNilArray:@"data"];
        NSMutableArray *fb_friends = [NSMutableArray new];
        for (NSDictionary<FBGraphUser>* friend in friends) {
            [fb_friends addObject:friend.objectID];
        }
        cb(fb_friends);
    }];
}

+(void)getFaceBookFriends:(void(^)(NSArray *friends))cb
{
    BOOL ret = [FBSession openActiveSessionWithAllowLoginUI:NO];
    if (!ret)
        return cb(nil);
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result getXpathNilArray:@"data"];
        NSMutableArray *fb_friends = [NSMutableArray new];
        for (NSDictionary<FBGraphUser>* friend in friends)
        {
            [fb_friends addObject:friend];
        }
        cb([fb_friends sortAlphabeticallyArrayOfObjectUsing:@"name" isAsc:YES]);
    }];
}

-(void)addThirdParty:(NsSnThirdPartyModel *)third_partyModel usingCb:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLAddThirdParty];
    
    [NsSnRequester request:url post:[third_partyModel toDictionary] cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         if (rep && [rep getXpathBool:@"ok" defaultValue:NO])
         {
             cb_rep(YES, error);
         }
         else
         {
             cb_rep(NO, error);
         }
     } cache:NO];
}
@end
