//
//  NSLEEventManager.h
//  PepsiLiveGaming
//
//  Created by Derivery Guillaume on 9/12/13.
//  Copyright (c) 2013 Seb Jallot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCEventModel.h"
#import "NsSnRequester.h"

@interface GCEventManager : NSObject

+(void) getLiveAndUpComingEventsForCompetition:(NSString *)competitionID cb_response:(void (^)(NSArray *events))cb_response;

+(void) getRankingsForEvent:(NSString *)eventID inCompetition:(NSString *)competitionID withPage:(NSUInteger)page andLimit:(NSUInteger)limit cb_response:(void (^)(NSArray *rankings))cb_response;

+(void) getMyRankForEvent:(NSString *)eventID inCompetition:(NSString *)competitionID cb_response:(void (^)(GCRankingUserModel *myEventRank))cb_response;

+(void) getEventReguardingProviderID:(NSString *)providerID cb_response:(void (^)(GCEventModel *event))cb_response;

@end
