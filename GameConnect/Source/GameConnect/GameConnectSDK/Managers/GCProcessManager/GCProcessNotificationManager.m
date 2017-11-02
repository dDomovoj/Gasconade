//
//  GCProcessNotificationManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 12/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessNotificationManager.h"
#import "Extends+Libs.h"

@implementation GCProcessNotificationManager
CREATE_INSTANCE

-(void) selectQuestion:(GCQuestionModel *)questionModel fromNotification:(GCNotificationView *)notificationView
{
    if (![self checkDelegate:self.delegate])
        return ;
    if (!questionModel || ![questionModel isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel doesn't exist");
    
    if ([self.delegate respondsToSelector:@selector(GCDidSelectQuestion:fromNotification:)])
        [self.delegate GCDidSelectQuestion:questionModel fromNotification:notificationView];
}

-(void) requestPushInfoFromNotification:(GCNotificationView *)notificationView forPushInfos:(NSArray *)arrayOfPushInfos
{
    if (![self checkDelegate:self.delegate])
        return ;
    if (!arrayOfPushInfos || [arrayOfPushInfos count] == 0)
        DLog(@"QuestionModel doesn't exist");
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestPushInfoFromNotification:forPushInfos:)])
        [self.delegate GCDidRequestPushInfoFromNotification:notificationView forPushInfos:arrayOfPushInfos];
}

@end
