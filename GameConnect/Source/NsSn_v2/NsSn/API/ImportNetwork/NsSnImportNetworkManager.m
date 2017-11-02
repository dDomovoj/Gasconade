//
//  NsSnImportNetworkManager.m
//  StadeDeFrance
//
//  Created by Guillaume Derivery on 2/24/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "NsSnImportNetworkManager.h"
#import "NsSnRequester.h"
#import "NSsnConfManager.h"
#import "Extends+Libs.h"

@implementation NsSnImportNetworkManager

+(void) importNetworkFromLinkedIn:(NSString *)oauth2_access_token cb_rep:(void (^)(BOOL ok, NSDictionary *response))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLImportLinkedInNetwork], oauth2_access_token];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        if (rep && [rep getXpathEmptyString:@"number_of_friends_created"])
        {
            if (cb_rep)
                cb_rep(YES, rep);
        }
        else
        {
            if (cb_rep)
                cb_rep(NO, rep);
        }
    } cache:NO];
}

+(void) importNetworkFromFacebook:(NSString *)oauth2_access_token cb_rep:(void (^)(BOOL ok, NSDictionary *response))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLImportFacebookNetwork], oauth2_access_token];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         if (rep && [rep getXpathEmptyString:@"number_of_friends_created"])
         {
            if (cb_rep)
                cb_rep(YES, rep);
         }
         else
         {
             if (cb_rep)
                cb_rep(NO, rep);
         }
     } cache:NO];
}

@end
