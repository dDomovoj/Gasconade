//
//  BridgedLanguageManager.h
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 7/18/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BridgedLanguageManager : NSObject

+ (NSString *)localizedStringForString:(NSString *)string;
+ (NSString *)applicationLanguage;

@end
