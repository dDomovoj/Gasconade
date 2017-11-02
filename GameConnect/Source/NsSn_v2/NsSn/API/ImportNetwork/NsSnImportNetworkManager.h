//
//  NsSnImportNetworkManager.h
//  StadeDeFrance
//
//  Created by Guillaume Derivery on 2/24/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NsSnImportNetworkManager : NSObject

+(void) importNetworkFromLinkedIn:(NSString *)oauth2_access_token cb_rep:(void (^)(BOOL ok, NSDictionary *response))cb_rep;

+(void) importNetworkFromFacebook:(NSString *)oauth2_access_token cb_rep:(void (^)(BOOL ok, NSDictionary *response))cb_rep;

@end
