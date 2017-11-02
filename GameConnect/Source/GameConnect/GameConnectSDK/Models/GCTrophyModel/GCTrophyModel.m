//
//  GCTrophiesModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 09/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCTrophyModel.h"
#import "Extends+Libs.h"

@implementation GCTrophyModel

+(id) fromJSON:(NSDictionary*)data
{
    GCTrophyModel *trophy = [[GCTrophyModel alloc] init];
    
    if (data)
    {
        trophy._id = [data getXpathEmptyString:@"id"];
        trophy.name = [data getXpathEmptyString:@"name"];
        trophy.desc = [data getXpathEmptyString:@"description"];
        trophy.picture_url = [data getXpathNilString:@"picture_url"];
    }
    return trophy;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCTrophyModel fromJSON:elt]];
    }];
    return ret;
}

@end
