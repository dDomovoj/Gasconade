//
//  GCProcessNotificationManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 12/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"
#import "GCNotificationView.h"

@protocol GCProcessNotificationManagerDelegate <GCProcessManagerDelegate>
@optional

/* Notifications */
-(void) GCDidSelectQuestion:(GCQuestionModel *)questionModel fromNotification:(GCNotificationView *)notificationView;

-(void) GCDidRequestPushInfoFromNotification:(GCNotificationView *)notificationView forPushInfos:(NSArray *)arrayOfPushInfos;
@end

@interface GCProcessNotificationManager : GCProcessManager
@property (weak, nonatomic) id<GCProcessNotificationManagerDelegate> delegate;

-(void) selectQuestion:(GCQuestionModel *)questionModel fromNotification:(GCNotificationView *)notificationView;

-(void) requestPushInfoFromNotification:(GCNotificationView *)notificationView forPushInfos:(NSArray *)arrayOfPushInfos;

@end
