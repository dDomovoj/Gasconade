//
//  GCProcessQuestionManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"

@protocol GCProcessQuestionManagerDelegate <GCProcessManagerDelegate>
@optional
-(void) GCDidSelectQuestion:(GCQuestionModel *)questionModel fromViewController:(GCInGameViewController *)inGameViewController;

-(void) GCDidAnswerQuestion:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)inGameViewController;

-(void) GCShareQuestion:(GCQuestionModel *)questionModel fromViewController:(GCMasterViewController *)senderViewController;

-(void) GCDidEndQuestionCountdown:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)answersViewController;

@end

@interface GCProcessQuestionManager : GCProcessManager
@property (weak, nonatomic) id<GCProcessQuestionManagerDelegate> delegate;
-(void) selectItemInQuestionsList:(GCQuestionModel *)questionModel fromViewController:(GCInGameViewController *)inGameViewController;

-(void) questionAnswered:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)answersViewController;

-(void) questionTimeCameOut:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)answersViewController;

-(void) shareQuestion:(GCQuestionModel *)questionModel fromViewController:(GCMasterViewController *)senderViewController;

@end
