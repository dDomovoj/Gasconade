//
//  GCEventManager
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/26/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCEventManager.h"
#import "GCConfManager.h"
#import "GCRequester.h"
//#import "GCLoggerManager.h"
#import "GCGamerManager.h"
#import "GCCompetitionManager.h"

@implementation GCEventManager

+(void) getLiveAndUpComingEventsForCompetition:(NSString *)competitionID cb_response:(void (^)(NSArray *events))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETLiveUpComingEvents], competitionID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (rep)
        {
            cb_response([GCEventModel fromJSONArray:[rep getXpathNilArray:@"events"]]);
        }
        else
            cb_response(@[]);
    } cache:NO];
}

+(void) getRankingsForEvent:(NSString *)eventID inCompetition:(NSString *)competitionID withPage:(NSUInteger)page andLimit:(NSUInteger)limit cb_response:(void (^)(NSArray *rankings))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETEventRankings], competitionID, eventID, [NSNumber numberWithUnsignedInteger:page], [NSNumber numberWithUnsignedInteger:limit]);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
     {
         GCLog(GCHTTPResponseLog, (long)httpcode, url);
         if (rep)
             cb_response([GCRankingModel fromJSONArray:[rep getXpathNilArray:@"ranks"]]);
         else
             cb_response(@[]);
     } cache:NO];
}

+(void) getMyRankForEvent:(NSString *)eventID inCompetition:(NSString *)competitionID cb_response:(void (^)(GCRankingUserModel *myEventRank))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETMyEventRanking], competitionID, eventID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
     {
         GCLog(GCHTTPResponseLog, (long)httpcode, url);
         GCRankingUserModel *userRankingModel = [GCRankingUserModel fromJSON:rep];

         cb_response(userRankingModel);
     } cache:NO];
}

+(void) getEventReguardingProviderID:(NSString *)providerID cb_response:(void (^)(GCEventModel *event))cb_response
{
    if (!providerID || [providerID length] == 0)
    {
        cb_response(nil);
        return ;
    }

    // SHOULD WORK FOR ANY COMPETITIONS
    [self getLiveAndUpComingEventsForCompetition:[GCCompetitionManager getInstance].competitionDefault._id cb_response:^(NSArray *events)
    {
        for (GCEventModel *event in events)
        {
            if (event && event.provider_id && providerID && [event.provider_id isEqualToString:providerID])
            {
                if (cb_response)
                    cb_response(event);
                return;
            }
        }
        if (cb_response)
            cb_response(nil);
    }];
}

@end
