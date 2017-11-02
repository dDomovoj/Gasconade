//
//  GCRankUserModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCRankingModel.h"
#import "Extends+Libs.h"

@implementation GCRankingModel

+(id)fromJSON:(NSDictionary *)data
{
    GCRankingModel *rank = [GCRankingModel new];
    rank.score = 0;
    rank.rank = 0;
    
    if (data)
    {
        rank.rank = [data getXpathInteger:@"rank"];
        rank.score = [data getXpathInteger:@"score"];
        rank.gamer = [GCGamerModel fromJSON:[data getXpathNilDictionary:@"gamer"]];
    }
    return rank;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCRankingModel fromJSON:elt]];
    }];
    return ret;
}

@end

@implementation GCRankingUserModel

+(id)fromJSON:(NSDictionary *)data
{
    GCRankingUserModel *rank = [GCRankingUserModel new];
    
    if (data)
    {
        rank.event_ranking = [GCRankingModel fromJSON:[data getXpathNilDictionary:@"event"]];
        rank.competition_ranking = [GCRankingModel fromJSON:[data getXpathNilDictionary:@"competition"]];
        rank.global_ranking = [GCRankingModel fromJSON:[data getXpathNilDictionary:@"global"]];
        rank.gamer = [GCGamerModel fromJSON:[data getXpathNilDictionary:@"gamer"]];
        
        rank.event_ranking.gamer = rank.gamer;
        rank.competition_ranking.gamer = rank.gamer;
        rank.global_ranking.gamer = rank.gamer;
    }
    return rank;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCRankingModel fromJSON:elt]];
    }];
    return ret;
}

@end