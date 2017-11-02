//
//  GCCompetitionManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 28/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCRankingModel.h"
#import "GCCompetitionModel.h"

@interface GCCompetitionManager : NSObject

@property (strong, nonatomic) GCCompetitionModel *competitionDefault;

+(GCCompetitionManager *) getInstance;

-(BOOL) competitionHasBeenRequested;

-(void) getCompetitionsWithResponse:(void (^)(NSArray *competitions))cb_response;

+(void) getRankingsForCompetition:(NSString *)competitionID withPage:(NSUInteger)page andLimit:(NSUInteger)limit cb_response:(void (^)(NSArray *rankings))cb_response;

+(void) getMyRankForCompetition:(NSString *)competitionID cb_response:(void (^)(GCRankingUserModel *myCompetitionRank))cb_response;

@end
