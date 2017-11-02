//
//  NsSnSignManager.h
//  NsSn
//
//  Created by adelskott on 20/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnSignModel.h"
#import "NsSnRequester.h"
#import "NsSnUserModel.h"

#define PREFIX_MAIL_FB @"fb."
#define FILE_FB_CONNECTION @"fb-connect"

typedef enum
{
    eNsSnThirdPartyConnectionFB,
    eNsSnThirdPartyConnectionNone,
} eNsSnThirdPartyConnection;

@interface NsSnSignManager : NSObject

+(NsSnSignManager*)getInstance;

// Field checking
-(void) checkEmailAvailability:(NSString *)email cb_response:(void(^)(BOOL ok))cb_response;
-(void) checkNicknameAvailability:(NSString *)login cb_response:(void(^)(BOOL ok))cb_response;

// Subscribe NSAPI
-(void)subscribeAPI:(NsSnSignModel*)user cb_rep:(void (^)(BOOL inscription_ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep;
-(void)subscribeSecutixAPI:(NsSnSignModel*)user cb_rep:(void (^)(BOOL inscription_ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

// Third party connection
+(eNsSnThirdPartyConnection) isHeConnectedUsingThirdParty:(NsSnUserModel *)userModel;

+(void)storeThirdPartyConnect:(eNsSnThirdPartyConnection)thirdPartyConnect forEmail:(NSString *)userEmail;
+(void)removeThirdPartyConnect:(eNsSnThirdPartyConnection)thirdPartyConnect forEmail:(NSString *)userEmail;
+(BOOL)shouldIImportNetwork:(eNsSnThirdPartyConnection)thirdPartyConnect forEmail:(NSString *)userEmail;

// Specific Facebook
+(NSString *)formatFacebookEmailFrom:(NSString *)fbEmail;
+(NSString *)formatFacebookLoginFromFirstName:(NSString *)firstName andLastName:(NSString *)lastName;

@end
