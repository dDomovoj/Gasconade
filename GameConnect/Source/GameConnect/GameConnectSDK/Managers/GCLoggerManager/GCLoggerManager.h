//
//  GCLoggerManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 25/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCLoggerManager : NSObject

@property (copy, nonatomic) void(^blockEventTrackingVCAPP)(NSString *vcScreenName);
@property (copy, nonatomic) void(^blockEventTrackingVCSDK)(NSString *vcSdkName);

+(GCLoggerManager *) getInstance;

-(NSString *) getTagNameForKey:(NSString *)key;
+(void)GCLog:(NSString *)format, ...;
-(void)GCTag:(NSString *)format;
-(void)GCTagApp:(NSString *)tag;

@end
