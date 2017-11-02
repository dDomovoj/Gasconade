//
//  GCProcessQuestionManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessQuestionManager.h"
#import "Extends+Libs.h"

@implementation GCProcessQuestionManager
CREATE_INSTANCE

/* Questions */
-(void) selectItemInQuestionsList:(GCQuestionModel *)questionModel fromViewController:(GCInGameViewController *)inGameViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!questionModel || ![questionModel isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCDidSelectQuestion:fromViewController:)])
        [self.delegate GCDidSelectQuestion:questionModel fromViewController:inGameViewController];
}

-(void) questionAnswered:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)answersViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!questionModel || ![questionModel isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel is not correct !");
    if ([self.delegate respondsToSelector:@selector(GCDidAnswerQuestion:fromViewController:)])
        [self.delegate GCDidAnswerQuestion:questionModel fromViewController:answersViewController];
}

-(void) questionTimeCameOut:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)answersViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!questionModel || ![questionModel isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel is not correct !");

    if ([self.delegate respondsToSelector:@selector(GCDidEndQuestionCountdown:fromViewController:)])
        [self.delegate GCDidEndQuestionCountdown:questionModel fromViewController:answersViewController];
}

-(void) shareQuestion:(GCQuestionModel *)questionModel fromViewController:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!questionModel || ![questionModel isKindOfClass:[GCQuestionModel class]])
        DLog(@"QuestionModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCShareQuestion:fromViewController:)])
        [self.delegate GCShareQuestion:questionModel fromViewController:senderViewController];
}

@end
