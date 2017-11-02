//
//  GCPushModels.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCPushModels.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"

@implementation GCPushModel

+(id) fromJSON:(NSDictionary*)data
{
    GCPushModel *pushModel = [GCPushModel new];
    pushModel.type = eGCPushTypeNone;
    pushModel.gc_timestamp = nil;
    
    if (data)
    {
        pushModel.type = [GCPushModel pushTypeFromString:[data getXpathEmptyString:@"type"]];
        pushModel.gc_timestamp = [GCConfManager ISO8601StringToNSDate:[data getXpathEmptyString:@"gc_timestamp"]];
    }
    return pushModel;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCPushModel fromJSON:elt]];
    }];
    return ret;
}

+(eGCPushType) pushTypeFromString:(NSString *)type
{
    // Event Questions
    if ([type isEqualToString:@"START_QUESTION"])
        return eGCPushTypeStartQuestion;
    
    else if ([type isEqualToString:@"END_QUESTION"])
        return eGCPushTypeEndQuestion;
    
    else if ([type isEqualToString:@"STATS_QUESTION"])
        return eGCPushTypeStatsQuestion;
    
    // Gamer
    else if ([type isEqualToString:@"EARNED_TROPHY"])
        return eGCPushTypeEarnedTrophy;
    
    else if ([type isEqualToString:@"QUESTION_SCORE"])
        return eGCPushTypeScoreQuestion;
    
    else if ([type isEqualToString:@"EVENT_RANKING"])
        return eGCPushTypeRankingEvent;
    
    // Competition Events
    else if ([type isEqualToString:@"START_EVENT"])
        return eGCPushTypeStartEvent;
    
    else if ([type isEqualToString:@"END_EVENT"])
        return eGCPushTypeEndEvent;
    
    return eGCPushTypeNone;
}

@end

@implementation GCPushQuestionModel

+(id) fromJSON:(NSDictionary*)data
{
    GCPushQuestionModel *questionPushModel = [GCPushQuestionModel new];
    if (data)
    {
        questionPushModel.pushInfo = [GCPushModel fromJSON:data];
        questionPushModel.question = [GCQuestionModel fromJSON:[data getXpathNilDictionary:@"question"]];
    }
    return questionPushModel;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCPushQuestionModel fromJSON:elt]];
    }];
    return ret;
}

@end

@implementation GCPushTrophyModel

+(id) fromJSON:(NSDictionary*)data
{
    GCPushTrophyModel *trophyModel = [GCPushTrophyModel new];
    if (data)
    {
        trophyModel.pushInfo = [GCPushModel fromJSON:data];
        trophyModel.trophy_id = [data getXpathEmptyString:@"trophy_id"];
    }
    return trophyModel;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCPushTrophyModel fromJSON:elt]];
    }];
    return ret;
}

@end

@implementation GCPushScoreQuestionModel

+(id) fromJSON:(NSDictionary*)data
{
    GCPushScoreQuestionModel *scoreQuestion = [GCPushScoreQuestionModel new];
    if (data)
    {
        scoreQuestion.pushInfo = [GCPushModel fromJSON:data];
        scoreQuestion.question_id = [data getXpathEmptyString:@"question_id"];
        scoreQuestion.event_id = [data getXpathEmptyString:@"event_id"];
        scoreQuestion.competition_id = [data getXpathEmptyString:@"competition_id"];
        scoreQuestion.score = [data getXpathInteger:@"score"];
    }
    return scoreQuestion;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCPushScoreQuestionModel fromJSON:elt]];
    }];
    return ret;
}

@end


@implementation GCPushRankingEventModel

+(id) fromJSON:(NSDictionary*)data
{
    GCPushRankingEventModel *rankingEvent = [GCPushRankingEventModel new];
    if (data)
    {
        rankingEvent.pushInfo = [GCPushModel fromJSON:data];
        rankingEvent.event_id = [data getXpathEmptyString:@"event_id"];
        rankingEvent.competition_id = [data getXpathEmptyString:@"competition_id"];
        rankingEvent.score = [data getXpathInteger:@"score"];
        rankingEvent.rank = [data getXpathInteger:@"rank"];
    }
    return rankingEvent;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCPushRankingEventModel fromJSON:elt]];
    }];
    return ret;
}

@end

@implementation GCPushEventModel

+(id) fromJSON:(NSDictionary*)data
{
    GCPushEventModel *pushEvent = [GCPushEventModel new];
    if (data)
    {
        pushEvent.pushInfo = [GCPushModel fromJSON:data];
        pushEvent.event = [GCEventModel fromJSON:[data getXpathNilDictionary:@"event"]];
    }
    return pushEvent;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCPushEventModel fromJSON:elt]];
    }];
    return ret;
}

@end
