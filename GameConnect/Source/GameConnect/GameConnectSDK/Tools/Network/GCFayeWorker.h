//
//  GCFayeWorker.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 07/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FayeClient.h"
#import "GCEventModel.h"
#import "GCCompetitionModel.h"

@interface GCFayeWorker : NSObject <FayeClientDelegate>

+(GCFayeWorker*) getInstance;
// -(void) initialize;

-(void) runFayeForGamer:(GCGamerModel *)gamer;
-(void) runFayeForCompetitions:(NSArray *)competitions;
-(void) runFayeForEventsInCompetition:(GCCompetitionModel *)competition;
-(void) runFayeForEvents:(NSArray *)events;
-(void) runFayeForQuestionsInEvent:(GCEventModel *)event;

-(void) stopFayeForGamer:(GCGamerModel *)gamer;
-(void) stopFayeForQuestionsInEvent:(GCEventModel *)event;
-(void) stopFayeForEventsInCompetition:(GCCompetitionModel *)competition;

-(void) shutdownFayeClient;
-(void) sleep;
-(void) restart;

@end
