//
//  GCLeagueModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCLeagueModel.h"
#import "GCGamerModel.h"

@implementation GCLeagueModel

+(id) fromJSON:(NSDictionary*)data
{
    GCLeagueModel *league = [GCLeagueModel new];
    if (data)
    {
        league._id = [data getXpathEmptyString:@"id"];
        league.name = [data getXpathEmptyString:@"name"];
        league.count = [data getXpathInteger:@"count"];
        league.gamer = [GCGamerModel fromJSON:[data getXpathNilDictionary:@"gamer"]];
    }
    return league;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCLeagueModel fromJSON:elt]];
    }];
    return ret;
}

+(BOOL)validateLeagueName:(NSString *)leagueName
{
    if (leagueName && [leagueName length] >= 4)
        return TRUE;
    return FALSE;
}


/*
 **
 {
 private_league: {
 name: "",
 gamers: [uuidv4, uuidv4]
 }
 }
 
 */

@end
