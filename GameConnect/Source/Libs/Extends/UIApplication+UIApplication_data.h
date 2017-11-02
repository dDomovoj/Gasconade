//
//  UIApplication+UIApplication_UIApplication_data.h
//  CAN 2013
//
//  Created by Benjamin Bouachour on 07/12/12.
//  Copyright (c) 2012 Netco Sports. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (UIApplication_data)

+(NSString *)getItunesUrlWithAppleID:(NSString *)appleID;

+(NSString*)getDeviceInfoInHtml;

@end
