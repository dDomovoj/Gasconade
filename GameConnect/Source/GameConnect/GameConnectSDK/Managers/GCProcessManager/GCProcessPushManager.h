//
//  GCProcessPushManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"
#import "GCPushModels.h"

/*
 ** GCProcessPushManager
 */
@protocol GCProcessPushManagerDelegate  <GCProcessManagerDelegate>
@optional
/* Push Events */
-(void) GCDidReceiveNewQuestionNotification:(GCQuestionModel *)questionModel;
-(void) GCDidReceiveStatsQuestionNotification:(GCQuestionModel *)questionModel;
-(void) GCDidReceiveResultQuestionNotification:(GCQuestionModel *)questionModel;
-(void) GCDidReceiveEndQuestionNotification:(GCQuestionModel *)questionModel;

-(void) GCDidReceiveTrophyNotification:(GCTrophyModel *) trophyModel;
-(void) GCDidReceiveRankUpdateForEvent:(GCPushRankingEventModel *)pushRankEventModel;

-(void) GCDidReceiveNewEventNotification:(GCEventModel *) eventModel;
-(void) GCDidReceiveEndEventNotification:(GCEventModel *) eventModel;
@end

@interface GCProcessPushManager : GCProcessManager

@property (weak, nonatomic) id<GCProcessPushManagerDelegate> delegate;

/* Event Questions */
-(void) receiveNewQuestionNotification:(GCPushQuestionModel *)pushQuestionModel;

-(void) receiveStatsQuestionNotification:(GCPushQuestionModel *)pushQuestionModel;

-(void) receiveEndQuestionNotification:(GCPushQuestionModel *)pushQuestionModel;

/* Gamer */
-(void) receiveTrophyNotification:(GCPushTrophyModel *)pushTrophyModel;

-(void) receiveScoreQuestionNotification:(GCPushScoreQuestionModel *)pushScoreQuestionModel;

-(void) receiveRankingEventNotification:(GCPushRankingEventModel *)pushRankEventModel;

/* Competition Events */
-(void) receiveNewEventNotification:(GCPushEventModel *)pushEventModel;

-(void) receiveEndEventNotification:(GCPushEventModel *)pushEventModel;

@end
