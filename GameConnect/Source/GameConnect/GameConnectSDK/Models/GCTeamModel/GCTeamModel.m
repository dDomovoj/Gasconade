//
//  GCTeamModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//


#import "GCTeamModel.h"
#import "Extends+Libs.h"

@implementation GCTeamModel

+(GCTeamModel *) fromJSON:(NSDictionary*)data
{
    GCTeamModel *league = [GCTeamModel new];
    if (data)
    {
        league.team_id = [data getXpathInteger:@"tid"];
        league.team_name = [data getXpathEmptyString:@"name"];
        league.team_picture = [data getXpathBool:@"has_pic" defaultValue:NO];
        league.team_abbreviation = [data getXpathEmptyString:@"abbrev"];
    }
    return league;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCTeamModel fromJSON:elt]];
    }];
    return ret;
}

@end

@implementation GCFavoriteTeamModel

+(GCFavoriteTeamModel *) fromJSON:(NSDictionary*)data
{
    GCFavoriteTeamModel *league = [GCFavoriteTeamModel new];
    if (data)
    {
        league._id = [data getXpathEmptyString:@"_id"];
        league.tag_id = [data getXpathEmptyString:@"tag_id"];
        league.tag_name = [data getXpathEmptyString:@"tag_name"];
        league.tag_xid = [data getXpathEmptyString:@"tag_xid"];
    }
    return league;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCFavoriteTeamModel fromJSON:elt]];
    }];
    return ret;
}


@end
