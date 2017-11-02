//
//  PLGStatsBarView.m
//  PepsiLiveGaming
//
//  Created by Quimoune NetcoSports on 20/09/13.
//  Copyright (c) 2013 Édouard Richard. All rights reserved.
//

#import "GCStatsBarView.h"
#import "Extends+Libs.h"
#import "GCEventModel.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCStatsBarView()
{
    CGFloat minHeight;
    CGFloat maxHeight;
    
    CGFloat percent;
    CGFloat finalPercent;
    
    BOOL isToUp;
    BOOL isMyAnswer;
    
    NSTimer *timer;
}
@end

@implementation GCStatsBarView

-(void)initColorsAndFonts
{
    isMyAnswer = NO;
    percent = 0;
    minHeight = 112; // bar : 1; => 0%
    maxHeight =  self.superview.frame.size.height; // [UIDevice isIphone5] ? 368 : 280; // bar : 190; => 100%

    [self.lb_is_answer setAlpha:0.0];
    [self.lb_is_answer setFont:CONFFONTBOLDSIZE(13)];
    [self.lb_percent setFont:CONFFONTBOLDSIZE(15)];
    
    if ([UIDevice isIPAD])
    {
        [self.lb_response setFont:CONFFONTREGULARSIZE(14)];
    }
    else
    {
        [self.lb_response setFont:CONFFONTREGULARSIZE(12)];
    }
    
    [self.lb_is_answer setTextColor:CONFCOLORFORKEY(@"stats_bar_my_answer_bg")];
    [self.lb_percent setTextColor:CONFCOLORFORKEY(@"stats_answers_lb")];
    [self.lb_response setTextColor:CONFCOLORFORKEY(@"stats_answers_lb")];
    
    [self.v_bar setAlpha:0.8];
    [self.v_bar setBackgroundColor:CONFCOLORFORKEY(@"stats_bar_answer_bg")];
    [self.lb_is_answer setText:[NSLocalizedString(@"gc_your_answer", @"") uppercaseString]];
}

-(void)updateQuestionModel:(GCQuestionModel *)questionModel andIndex:(NSNumber *)index
{
    GCAnswerModel *answerModel = [questionModel.answers getXpath:[NSString stringWithFormat:@"[%d]", [index intValue]] type:[GCAnswerModel class] def:nil];
    if (answerModel)
    {
        [self.lb_response setText:answerModel.answer];
        
        if ([questionModel isQuestionActive] == NO)
        {
            if (answerModel.is_right_answer)
            {
                if ([UIDevice isIPAD])
                    [self.lb_response setFont:CONFFONTBOLDSIZE(14)];
                else
                    [self.lb_response setFont:CONFFONTBOLDSIZE(12)];
            }
        }
        
        for (NSString *answerID in questionModel.my_answers)
        {
            if ([answerID isEqualToString:answerModel._id])
            {
                isMyAnswer = YES;
                [self.v_bar setBackgroundColor:CONFCOLORFORKEY(@"stats_bar_my_answer_bg")];
                break;
            }
        }
        
        finalPercent = [questionModel calculateNumberOfPersonAnswers] > 0 ? (((answerModel.total_answers * 1.0) / ([questionModel calculateNumberOfPersonAnswers] * 1.0)) * 100) : 0;
        [self.im_top setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Question/stats_bar_top_pin"]];
    }
}

-(void)startBarAnimation
{
    float newY = self.frame.origin.y;
    float newH = self.frame.size.height;
    [self setFrame:CGRectMake(self.frame.origin.x, newY, self.frame.size.width, newH)];
    
    isToUp = (percent < finalPercent) ? YES : NO;
    
    if (timer)
        [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateAnimationElements) userInfo:nil repeats:YES];
}

-(void)updateAnimationElements
{
    [self.lb_percent setText:[NSString stringWithFormat:@"%.0f%%", percent]];
    if (percent < finalPercent && isToUp)
    {
        percent += 1.5;
        float diff = maxHeight - minHeight;
        float newH = floorf(diff * (percent / 100.0));
//        NSLog(@"[1] percent : %f on FinalPercent : %f  newH => %f / %f", percent, finalPercent, newH, diff);
        [self setFrame:CGRectMake(self.frame.origin.x, diff - newH, self.frame.size.width, minHeight + newH)];
    }
    else if (finalPercent < percent && !isToUp)
    {
        percent -= 1.5;
        float diff = maxHeight - minHeight;
        float newH = floorf(diff * (percent / 100.0));
//        NSLog(@"[2] newH => %f / %f", newH, diff);
        [self setFrame:CGRectMake(self.frame.origin.x, diff - newH, self.frame.size.width, minHeight + newH)];
    }
    else
    {
        [self.lb_percent setText:[NSString stringWithFormat:@"%.1f%%", finalPercent]];
        if (finalPercent == 0.0 || finalPercent == 100.0)
            [self.lb_percent setText:[NSString stringWithFormat:@"%.0f%%", finalPercent]];
        [timer invalidate];
        timer = nil;
        [self finisedAnimation];
    }
}

-(void)finisedAnimation
{
    if (isMyAnswer)
    {
//        [self.lb_is_answer setAlpha:1.0];
        [self.lb_is_answer bouingAppear:YES oncomplete:^{
        }];
    }
//    float minPercentToShowTrait = [UIDevice isIphone5] ? 10 : 15;
//
//    if (finalPercent <= minPercentToShowTrait)
//        [self.im_top setImage:[UIImage imageNamed:@"im_top_bar_stats_trait.png"]];
//    else
//        [self.im_top setImage:[UIImage imageNamed:@"im_top_bar_stats.png"]];
}


-(void)dealloc
{
    [timer invalidate];
    timer = nil;
}

@end
