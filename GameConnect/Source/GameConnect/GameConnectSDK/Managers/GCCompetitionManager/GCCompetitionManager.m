//
//  GCCompetitionManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 28/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCCompetitionManager.h"
#import "GCRequester.h"
#import "GCCompetitionModel.h"
//#import "GCLoggerManager.h"
#import "GCConfManager.h"

@interface GCCompetitionManager()
{
    BOOL hasBeenRequested;
}
@end
@implementation GCCompetitionManager

+(GCCompetitionManager *)getInstance
{
    static GCCompetitionManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[GCCompetitionManager alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        hasBeenRequested = NO;
    }
    return self;
}

-(BOOL) competitionHasBeenRequested
{
    return hasBeenRequested;
}

-(void) getCompetitionsWithResponse:(void (^)(NSArray *competitions))cb_response
{
    hasBeenRequested = YES;
    NSString *url = [GCConfManager getURL:GCURLGETCompetitions];
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
//        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (rep)
        {
            NSArray *arrayCompetitions = [GCCompetitionModel fromJSONArray:[rep getXpathNilArray:@"competitions"]];
            if ([arrayCompetitions count] > 0 && [arrayCompetitions objectAtIndex:0])
                self.competitionDefault = [arrayCompetitions objectAtIndex:0];
            else
                self.competitionDefault = nil;
            
            cb_response([GCCompetitionModel sortCompetitionsByStartDate:arrayCompetitions]);
        }
        else
            cb_response(@[]);
        hasBeenRequested = NO;
    } cache:NO];
}

+(void) getRankingsForCompetition:(NSString *)competitionID withPage:(NSUInteger)page andLimit:(NSUInteger)limit cb_response:(void (^)(NSArray *rankings))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETCompetitionRankings], competitionID, [NSNumber numberWithUnsignedInteger:page], [NSNumber numberWithUnsignedInteger:limit]);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
//        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (rep)
            cb_response([GCRankingModel fromJSONArray:[rep getXpathNilArray:@"ranks"]]);
        else
            cb_response(@[]);
    } cache:NO];
}

+(void) getMyRankForCompetition:(NSString *)competitionID cb_response:(void (^)(GCRankingUserModel *myCompetitionRank))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETMyCompetitionRanking], competitionID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
//        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        cb_response([GCRankingUserModel fromJSON:rep]);
    } cache:NO];
}

@end
