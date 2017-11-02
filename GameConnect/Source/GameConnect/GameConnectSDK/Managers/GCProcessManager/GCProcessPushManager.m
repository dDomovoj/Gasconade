    //
//  GCProcessPushManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GCProcessPushManager.h"
#import "GCGamerManager.h"
#import "GCQuestionManager.h"
#import "GCFayeWorker.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"

@implementation GCProcessPushManager
CREATE_INSTANCE

-(void)playTheSoundNotification
{
    if ([[GCConfManager getInstance] isSoundEnabled])
    {
        NSString *soundName = @"sound_question";
        SystemSoundID soundID;
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"aiff"];
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    if ([[GCConfManager getInstance] isVibrationEnabled])
    {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
}

/* Push Event */
-(void) receiveNewQuestionNotification:(GCPushQuestionModel *)pushQuestionModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!pushQuestionModel ||
        ![pushQuestionModel isKindOfClass:[GCPushQuestionModel class]] ||
        !pushQuestionModel.question ||
        ![pushQuestionModel.question isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel is not correct !");
    else
        [self playTheSoundNotification];
    
    if ([self.delegate respondsToSelector:@selector(GCDidReceiveNewQuestionNotification:)])
        [self.delegate GCDidReceiveNewQuestionNotification:pushQuestionModel.question];
}

-(void) receiveStatsQuestionNotification:(GCPushQuestionModel *)pushQuestionModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!pushQuestionModel ||
        ![pushQuestionModel isKindOfClass:[GCPushQuestionModel class]] ||
        !pushQuestionModel.question ||
        ![pushQuestionModel.question isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCDidReceiveStatsQuestionNotification:)])
        [self.delegate GCDidReceiveStatsQuestionNotification:pushQuestionModel.question];
}

-(void) receiveEndQuestionNotification:(GCPushQuestionModel *)pushQuestionModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!pushQuestionModel ||
        ![pushQuestionModel isKindOfClass:[GCPushQuestionModel class]] ||
        !pushQuestionModel.question ||
        ![pushQuestionModel.question isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCDidReceiveEndQuestionNotification:)])
        [self.delegate GCDidReceiveEndQuestionNotification:pushQuestionModel.question];
}

-(void) receiveTrophyNotification:(GCPushTrophyModel *)pushTrophyModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!pushTrophyModel  || ![pushTrophyModel isKindOfClass:[GCPushTrophyModel class]] || !pushTrophyModel.trophy_id)
        DLog(@"TrophyModel is not correct !");
    else
        [self playTheSoundNotification];
    
    __weak GCProcessPushManager *weak_self = self;

    [[GCGamerManager getInstance] getTrophiesForGamer:[GCGamerManager getInstance].gamer._id cb_response:^(NSArray *trophies)
    {
        for (GCTrophyModel *trophyModel in trophies)
        {
            if (trophyModel && [trophyModel._id isEqualToString:pushTrophyModel.trophy_id])
            {
                NSLog(@"MessageReceived TROPHY %@", trophyModel.name);
                if ([weak_self.delegate respondsToSelector:@selector(GCDidReceiveTrophyNotification:)])
                    [weak_self.delegate GCDidReceiveTrophyNotification:trophyModel];
                break ;
            }
        }
    }];
}

-(void) receiveScoreQuestionNotification:(GCPushScoreQuestionModel *)pushScoreQuestionModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!pushScoreQuestionModel || ![pushScoreQuestionModel isKindOfClass:[GCPushScoreQuestionModel class]] || !pushScoreQuestionModel.question_id)
        DLog(@"ScoreQuestionModel is not correct !");
//    else
//        [self playTheSoundNotification];
    
    __weak GCProcessPushManager *weak_self = self;
    [GCQuestionManager getQuestion:pushScoreQuestionModel.question_id forEvent:pushScoreQuestionModel.event_id inCompetition:pushScoreQuestionModel.competition_id cb_response:^(GCQuestionModel *question)
    {
        if ([weak_self.delegate respondsToSelector:@selector(GCDidReceiveResultQuestionNotification:)])
            [weak_self.delegate GCDidReceiveResultQuestionNotification:question];
        
        [weak_self playTheSoundNotification];
    }];
}

-(void) receiveRankingEventNotification:(GCPushRankingEventModel *)pushRankEventModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    if (!pushRankEventModel || ![pushRankEventModel isKindOfClass:[GCPushRankingEventModel class]] || !pushRankEventModel.event_id)
        DLog(@"RankingEventModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCDidReceiveRankUpdateForEvent:)])
        [self.delegate GCDidReceiveRankUpdateForEvent:pushRankEventModel];
}

/* Competition Events */
-(void) receiveNewEventNotification:(GCPushEventModel *)pushEventModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!pushEventModel || ![pushEventModel isKindOfClass:[GCPushEventModel class]] || !pushEventModel.event || !pushEventModel.event._id)
        DLog(@"PushEventModel is not correct !");
    
    [[GCFayeWorker getInstance] runFayeForQuestionsInEvent:pushEventModel.event];
    
    if ([self.delegate respondsToSelector:@selector(GCDidReceiveNewEventNotification:)])
        [self.delegate GCDidReceiveNewEventNotification:pushEventModel.event];
}

-(void) receiveEndEventNotification:(GCPushEventModel *)pushEventModel
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!pushEventModel || ![pushEventModel isKindOfClass:[GCPushEventModel class]] || !pushEventModel.event || !pushEventModel.event._id)
        DLog(@"PushEventModel is not correct !");

    [[GCFayeWorker getInstance] stopFayeForQuestionsInEvent:pushEventModel.event];
    
    if ([self.delegate respondsToSelector:@selector(GCDidReceiveEndEventNotification:)])
        [self.delegate GCDidReceiveEndEventNotification:pushEventModel.event];
}

@end
