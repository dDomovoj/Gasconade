//
//  GCNotificationManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GCTrophyModel.h"
#import "GCQuestionModel.h"

@interface GCNotificationManager : NSObject 

@property (nonatomic, readonly) BOOL bubbleEnabled;
@property (weak, nonatomic) UIView *viewPanelBubble;

-(void) setMinimumY:(CGFloat)minimumY;
-(void) setMaximumY:(CGFloat)maximumY;

-(void) notifyUserForNewTrophy:(GCTrophyModel *)trophyModel;
-(void) notifyUserForNewResult:(GCQuestionModel *)questionModel;
-(void) notifyUserForNewQuestion:(GCQuestionModel *)questionModel;

-(void) notifyUserEndQuestion:(GCQuestionModel *)questionModel;
-(void) notifyUserEndEvent:(GCEventModel *)eventModel;

- (void)onAnswerQuestion:(GCQuestionModel *)questionModel;

-(void)closeAllNotifications;
-(void)createNotificationsViewAndHide;

@end
