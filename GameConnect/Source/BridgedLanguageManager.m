//
//  BridgedLanguageManager.m
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 7/18/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

#import "BridgedLanguageManager.h"
#import <UIKit/UIKit.h>

@implementation BridgedLanguageManager

+ (NSString *)localizedStringForString:(NSString *)string {
  return string;
//    return [string localizedString];
}

+ (NSString *)applicationLanguage {
  // @"fr"
  return @"en";
}

@end
