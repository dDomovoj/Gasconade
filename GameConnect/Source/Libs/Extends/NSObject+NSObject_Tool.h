//
//  NSObject+NSObject_Tool.h
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_Tool)
+(NSString*) getLangName;
+(NSString*) getFullLangName;
+(NSString*) getCountryPhone;

+(void)backGroundBlockDownload:(void (^)(void))block;
+(void)backGroundBlock:(void (^)(void))block;
+(void)mainThreadBlock:(void (^)(void))block;
+(BOOL)isRetina;
-(void)performWithDelay:(NSTimeInterval)time block:(void(^)(void))block;
+(int)getVerionsiOS;
+(BOOL)isUniversalApplication;

-(NSDictionary *)serializeToDictionary;
@end
