//
//  UIApplication+UIApplication_UIApplication_data.m
//  CAN 2013
//
//  Created by Benjamin Bouachour on 07/12/12.
//  Copyright (c) 2012 Netco Sports. All rights reserved.
//

#import "UIApplication+UIApplication_data.h"
#import "Extends+Libs.h"

@implementation UIApplication (UIApplication_data)

+(NSString *)getItunesUrlWithAppleID:(NSString *)appleID{
    NSString *storeLang = [[NSObject getLangName] isEqualToString:@"fr"] ? @"fr" : @"en";
    if ([[[NSBundle mainBundle] bundleIdentifier] isSubString:@".F1Lance"] || [[[NSBundle mainBundle] bundleIdentifier] isSubString:@".horaDoGol"]){
        storeLang = @"br";
    }
    
    return [NSString stringWithFormat:@"http://itunes.apple.com/%@/app/id%@?mt=8", storeLang, appleID];
}


+(NSString*)getDeviceInfoInHtml
{
 
    NSString *deviceInfo = [NSString stringWithFormat:@"%@ (%@)",
                                   [[UIDevice currentDevice] model],
                                   [[UIDevice currentDevice] systemVersion]];
    
    NSString *appInfo = [NSString stringWithFormat:@"%@ (%@)",
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    // NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *language = [[locale displayNameForKey:NSLocaleIdentifier value:[NSObject getLangName]] capitalizedString];
    
    return [NSString stringWithFormat:@"%@<br>%@<br>%@",deviceInfo,appInfo,language] ;
}

@end
