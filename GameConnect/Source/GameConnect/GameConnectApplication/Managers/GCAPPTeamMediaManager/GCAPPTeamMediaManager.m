//
//  GCMediaManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPTeamMediaManager.h"
#import "UIImageViewJA.h"
#import "Extends+Libs.h"

#define TEAM_IMG_TTL @(60*60*24*5)
#define TEAM_IMG_DNS @"http://www.thefanclub.com/gsm_medias/soccer"

@implementation GCAPPTeamMediaManager

+(GCAPPTeamMediaManager*)getInstance
{
    static GCAPPTeamMediaManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[GCAPPTeamMediaManager alloc] init];
    });
    return sharedMyManager;
}

+(NSString*)getTeamNameProfile:(NSLETeamProfile)profile
{
    if (profile == NSLETeamProfile_20x20)
        return @"teams_20x20";
    else if (profile == NSLETeamProfile_25x25)
        return @"teams_25x25";
    else if (profile == NSLETeamProfile_50x50)
        return @"teams_50x50";
    else if (profile == NSLETeamProfile_150x150)
        return @"teams";
    return @"teams";
}

+(NSString *)getDirectoryGSMpics:(NSString *)idPic
{
    int dir = (floor([idPic intValue] / 1000) + 1) * 1000;
    return [NSString stringWithFormat:@"%d", dir];
}

+(void) setTeamImageViewJA:(UIImageViewJA *)img teamProfile:(NSLETeamProfile)teamProfile_ teamIdGSM:(NSString *)teamIdGSM_
{
    //TODO: Check HAS PICTURE
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@.png",
                    TEAM_IMG_DNS,
                    [GCAPPTeamMediaManager getTeamNameProfile:teamProfile_],
                    [GCAPPTeamMediaManager getDirectoryGSMpics:[NSString stringWithFormat:@"%@", teamIdGSM_]],
                    teamIdGSM_];
    
    [img loadImageFromURL:[NSString stringWithFormat:@"%@/%@/generic.png",
                           TEAM_IMG_DNS,
                           [GCAPPTeamMediaManager getTeamNameProfile:teamProfile_]]
                      ttl:[TEAM_IMG_TTL intValue]];

    return ;
    [img loadImageFromURL:url ttl:[TEAM_IMG_TTL intValue] endblock:^(UIImageViewJA *image)
    {
        if (!image || !image.image)
        {
            [img loadImageFromURL:[NSString stringWithFormat:@"%@/%@/generic.png",
                                   TEAM_IMG_DNS,
                                   [GCAPPTeamMediaManager getTeamNameProfile:teamProfile_]]
                              ttl:[TEAM_IMG_TTL intValue]];
        }
    }];
}

@end
