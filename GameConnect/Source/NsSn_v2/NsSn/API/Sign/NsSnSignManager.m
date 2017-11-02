//
//  NsSnSignManager.m
//  NsSn
//
//  Created by adelskott on 20/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnSignManager.h"
#import "NsSnRequester.h"
#import "NsSnConfManager.h"
#import "NsSnUserManager.h"
#import "NsSnMetadataModel.h"
#import "Extends+Libs.h"

@interface NsSnUserManager (Private)
-(void)setMyUser:(NsSnUserModel*)model;
@end
@implementation NsSnSignManager

+(NsSnSignManager*)getInstance
{
    static NsSnSignManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnSignManager alloc] init];
    });
    return sharedMyManager;
}

+(void)storeThirdPartyConnect:(eNsSnThirdPartyConnection)thirdPartyConnect forEmail:(NSString *)userEmail;
{
    switch (thirdPartyConnect)
    {
        case eNsSnThirdPartyConnectionFB:
            [userEmail setDataSave:FILE_FB_CONNECTION];
            break;
            
        default:
            break;
    }
}

+(BOOL)shouldIImportNetwork:(eNsSnThirdPartyConnection)thirdPartyConnect forEmail:(NSString *)userEmail
{
    BOOL isFirstTimeUsingFacebookConnection = YES;
    
    switch (thirdPartyConnect)
    {
        case eNsSnThirdPartyConnectionFB:
        {
            NSString *dataFile = [NSString getDataFromFile:FILE_FB_CONNECTION temps:(365*24*60*60)];
            isFirstTimeUsingFacebookConnection = dataFile && [dataFile length]  > 0 && [dataFile isEqualToString:userEmail] ? NO : YES;
        } break;
            
        default:
            break;
    }
    return isFirstTimeUsingFacebookConnection;
}

+(void)removeThirdPartyConnect:(eNsSnThirdPartyConnection)thirdPartyConnect forEmail:(NSString *)userEmail
{
    switch (thirdPartyConnect)
    {
        case eNsSnThirdPartyConnectionFB:
            [NSObject removeFileDoc:FILE_FB_CONNECTION];
            break;
            
        default:
            break;
    }

}

-(void) checkEmailAvailability:(NSString *)email cb_response:(void(^)(BOOL ok))cb_response
{
    if (!email)
    {
        cb_response(NO);
        return ;
    }
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLCheckEmail], [[email trim] lowercaseString]];
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         NSLog(@"REP CHECK EMAIL => %@", rep);
         if (rep)
         {
             NSInteger not_already_used = [rep getXpathInteger:@"email_not_already_used"];
             if (not_already_used == 1)
                 cb_response(YES);
             else
                 cb_response(NO);
         }
         else
             cb_response(NO);
     } cache:NO];
}

-(void) checkNicknameAvailability:(NSString *)login cb_response:(void(^)(BOOL ok))cb_response
{
    if (!login)
    {
        cb_response(NO);
        return ;
    }
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLCheckNickname], [login trim]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         NSLog(@"REP CHECK NICKNAME => %@", rep);
         if (rep)
         {
             NSInteger not_already_used = [rep getXpathInteger:@"nickname_not_already_used"];
             if (not_already_used == 1)
                 cb_response(YES);
             else
                 cb_response(NO);
         }
         else
             cb_response(NO);

     } cache:NO];
}

-(void)subscribeAPI:(NsSnSignModel*)user cb_rep:(void (^)(BOOL inscription_ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSDictionary *u = [user toDictionary];
    if (!u){
        if (cb_rep)
            cb_rep(NO, nil, NsSnUserErrorValueUnknown);
        return;
    }
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLSubscribe] post:u cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         if (rep && !cache)
         {
             if (error == NsSnUserErrorValueNone)
             {
                 NSDictionary *user_data = [rep getXpathNilDictionary:@"feeds/user"];
                 [[NsSnUserManager getInstance] setMyUser:[NsSnUserModel fromJSON:user_data]];
                 [@{@"l":user.email,@"p":user.password} setDataSaveNSDictionary:@"nssn-connect.txt"];
                 cb_rep(YES, rep, error);
             }
             else
                 cb_rep(NO, rep, error);
         }
     } cache:NO];
}

-(void)subscribeSecutixAPI:(NsSnSignModel*)user cb_rep:(void (^)(BOOL inscription_ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSDictionary *u = [user toSecutixDictionary];
    if (!u){
        if (cb_rep)
            cb_rep(NO, nil, NsSnUserErrorValueUnknown);
        return;
    }
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLSubscribeSecutix] post:u cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         if (rep && !cache)
         {
             if (error == NsSnUserErrorValueNone)
             {
                 NSDictionary *user_data = [rep getXpathNilDictionary:@"user"];
                 NsSnUserModel *userModel = [NsSnUserModel fromJSON:user_data];
                 [[NsSnUserManager getInstance] setMyUser:userModel];
                 [@{@"l":user.email, @"p":user.password} setDataSaveNSDictionary:@"nssn-connect.txt"];
                 cb_rep(YES, rep, error);
             }
             else{
                 cb_rep(NO, rep, error);
             }
         }
     } cache:NO];
}

+(NSString *)formatFacebookEmailFrom:(NSString *)fbEmail
{
    return [NSString stringWithFormat:@"%@%@", PREFIX_MAIL_FB, fbEmail];
}

+(NSString *)formatFacebookLoginFromFirstName:(NSString *)firstName andLastName:(NSString *)lastName
{
    return [NSString stringWithFormat:@"%@.%@", firstName, lastName];
}

+(eNsSnThirdPartyConnection) isHeConnectedUsingThirdParty:(NsSnUserModel *)userModel
{
    BOOL foundThirdPartyInMetadata = NO;
    if (userModel && userModel.Metadata && [userModel.Metadata count] > 0)
    {
        for (NsSnMetadataModel *metadata in userModel.Metadata)
        {
            if (metadata && metadata.key && metadata.value && [metadata.key isEqualToString:@"facebook_id"])
                foundThirdPartyInMetadata = YES;
        }
    }
    else
    {
        DLog(@"User doesn't have any metadata!");
    }
    
    
    if ([userModel.user_email hasPrefix:PREFIX_MAIL_FB])
    {
        return eNsSnThirdPartyConnectionFB;
    }
    
    return eNsSnThirdPartyConnectionNone;
}

@end
