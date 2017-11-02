//
//  GCMediaManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageViewJA.h"

typedef enum
{
    NSLETeamProfile_20x20,
    NSLETeamProfile_25x25,
    NSLETeamProfile_50x50,
    NSLETeamProfile_150x150
} NSLETeamProfile;

@interface GCAPPTeamMediaManager : NSObject

+(GCAPPTeamMediaManager *)getInstance;

+(NSString *)getDirectoryGSMpics:(NSString *)idPic;

+(void) setTeamImageViewJA:(UIImageViewJA *)img teamProfile:(NSLETeamProfile)teamProfile_ teamIdGSM:(NSString *)teamIdGSM_;

@end