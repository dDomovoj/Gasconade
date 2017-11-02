//
//  FacebookNetwork.h
//  FbProto
//
//  Created by Mathieu Lanoy on 05/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AbstractNetwork.h"

extern NSString* const FACEBOOK_ID;
extern NSString *const FBSessionStateChangedNotification;

@interface FacebookNetwork : AbstractNetwork<FBLoginViewDelegate>


@end
