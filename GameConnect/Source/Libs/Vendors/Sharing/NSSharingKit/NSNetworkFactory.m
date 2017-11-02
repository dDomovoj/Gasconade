//
//  NSNetworkFactory.m
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import "NSNetworkFactory.h"
#import "AbstractNetwork.h"
#import "TwitterNetwork.h"
#import "FacebookNetwork.h"
#import "MailNetwork.h"

@implementation NSNetworkFactory

+ (AbstractNetwork *) getNetwork:(NSString *)networkId
{
    if ([networkId isEqualToString:FACEBOOK_ID])
    {
        return [[FacebookNetwork alloc] init];
    } else if ([networkId isEqualToString:TWITTER_ID])
    {
        return [[TwitterNetwork alloc] init];
    } else if ([networkId isEqualToString:MAIL_ID])
    {
       return [[MailNetwork alloc] init];
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ is not a valid network", networkId];
    }
    return nil;
}

@end
