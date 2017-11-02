//
//  GCAnswerView
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAnswerView.h"
#import "GCAnswerModel.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

#define TIME_UPDATE_TIMER 0.1

@interface GCAnswerView()
{
    GCQuestionModel *questionModel;
    NSMutableArray *arrayOfAnswers;
    
    NSTimer *countDownTimer;
    CGFloat countDownSecondsRemaining;
    CGFloat totalSecondsToAnswer;
    
    NSMutableArray *arrayOfLabelEmbedded;
}
@end

@implementation GCAnswerView

-(void)initWithQuestion:(GCQuestionModel *)question
{
    if (!question )
    {
        DLog(@"No question provided to the GCAnswersView");
        return ;
    }
    questionModel = question;

    if ([self initAnswers])
        [self initTimer];
}

-(BOOL) initAnswers
{
    if (!questionModel.answers || [questionModel.answers count] == 0)
    {
        DLog(@"No answers provided to the GCAnswersView");
        return FALSE;
    }
    
    if (questionModel.type != eGCQuestionTypePrediction)
    {
        // Hide specific points
        [self.points3_left setHidden:YES];
        [self.points3_right setHidden:YES];
        [self.points3_top setHidden:YES];
        
        [self.points4_leftbottom setHidden:YES];
        [self.points4_lefttop setHidden:YES];
        [self.points4_rightbottom setHidden:YES];
        [self.points4_righttop setHidden:YES];
        
        [self.points_left setHidden:YES];
        [self.points_right setHidden:YES];
    }
    else
    {
        // Show specific points
        [self.points3_left setHidden:NO];
        [self.points3_right setHidden:NO];
        [self.points3_top setHidden:NO];
        
        [self.points4_leftbottom setHidden:NO];
        [self.points4_lefttop setHidden:NO];
        [self.points4_rightbottom setHidden:NO];
        [self.points4_righttop setHidden:NO];
        
        [self.points_left setHidden:NO];
        [self.points_right setHidden:NO];
    }

    switch ([questionModel.answers count])
    {
        case 2:
            [self setUpViewForTwo];
            break;
            
        case 3:
            [self setUpViewForThree];
            break;

        case 4:
            [self setUpViewForFour];
            break;

        default:
            DLog(@"To less or to much answers in question");
            break;
    }
    return YES;
}

-(void)initTimer
{
    totalSecondsToAnswer = [questionModel getRemainingSeconds];
    countDownSecondsRemaining = totalSecondsToAnswer;
    [countDownTimer invalidate];
    countDownTimer = nil;
    
    if (countDownSecondsRemaining > 0)
    {
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_UPDATE_TIMER
                                                              target:self
                                                            selector:@selector(timerQuestionFired)
                                                            userInfo:nil
                                                             repeats:YES];

        [self updateCountdownLabel:countDownSecondsRemaining];
        [self.progress startWithSeconds:countDownSecondsRemaining usingTimer:NO];
    }
    else
    {
        questionModel.status = eGCEventStatusFinished;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(GCTimerDidEndOnQuestion:fromAnswerView:)])
            [self.delegate GCTimerDidEndOnQuestion:questionModel fromAnswerView:self];
    }
}

- (void)timerQuestionFired
{
    countDownSecondsRemaining = [questionModel getRemainingSeconds];
    
    if (countDownSecondsRemaining >= 0)
    {
        [self updateCountdownLabel:countDownSecondsRemaining];

        CGFloat diff = (totalSecondsToAnswer - countDownSecondsRemaining);
        [self.progress updateWithSecondsRemaining:diff];
        
        if (countDownSecondsRemaining <= 15.0f)
            [self.lb_timer setTextColor:CONFCOLORFORKEY(@"countdown_progress_tint")];
        else
            [self.lb_timer setTextColor:CONFCOLORFORKEY(@"countdown_lb")];
    }
    else
    {
        [countDownTimer invalidate];
        countDownTimer = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(GCTimerDidEndOnQuestion:fromAnswerView:)])
            [self.delegate GCTimerDidEndOnQuestion:questionModel fromAnswerView:self];
    }
}

-(void)reset
{
    [countDownTimer invalidate];
    countDownTimer = nil;
    questionModel = nil;
}

-(void) updateCountdownLabel:(NSUInteger)secondsAvailable
{
    if (secondsAvailable <= 0)
        secondsAvailable = 0;

    NSUInteger hoursRemaining = secondsAvailable / 3600;
    NSUInteger remainder = secondsAvailable % 3600;
    NSUInteger minutesRemaining = remainder / 60;
    NSUInteger secondsRemaining = remainder % 60;

    if (self.lb_timer)
    {
        if (hoursRemaining != 0)
            [self.lb_timer setText:[NSString stringWithFormat:@"%lu h", (unsigned long)hoursRemaining]];

        else if (minutesRemaining != 0)
            [self.lb_timer setText:[NSString stringWithFormat:@"%lu\' %02lu\"", (unsigned long)minutesRemaining, (unsigned long)secondsRemaining]];
        
        else 
            [self.lb_timer setText:[NSString stringWithFormat:@"%02lu\"", (unsigned long)secondsRemaining]];
    }
}

/*
 ** UI Multiples Answers Management and Central View with Timer
 */

-(void)setUpViewTimer:(UIView *)centralView
{
    [self.iv_borderTimer setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Question/timer_border.png"]];

    [self.v_centerBackgroundTimer setBackgroundColor:CONFCOLORFORKEY(@"countdown_bg")];
    [self.lb_timer setTextColor:CONFCOLORFORKEY(@"countdown_lb")];
    
    [self.lb_timer setFont:CONFFONTULTRALIGHTSIZE(40)];
    [self.lb_timer setMinimumScaleFactor:0.5f];
    
    [self.progress setCircleBackgroundColor:[UIColor clearColor]];
    [self.progress setCircleColor:CONFCOLORFORKEY(@"countdown_progress_tint")];
    [self.progress setCircleTimerWidth:13.0f];
    
    self.v_centerBackgroundTimer.layer.cornerRadius = self.v_centerBackgroundTimer.frame.size.width/2;
    self.v_centeredTimer.layer.cornerRadius = self.v_centeredTimer.frame.size.width/2;
    centralView.layer.cornerRadius = centralView.frame.size.width/2;
    [centralView addSubviewToBonce:self.v_centeredTimer];
}

-(void)setUpViewForTwo
{
    UIImage *imgBtLeft = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/2Answers/button_2answers_left"];
    UIImage *imgBtRight = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/2Answers/button_2answers_right"];
    UIImage *imgBtLeftSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/2Answers/button_2answers_left_selected"];
    UIImage *imgBtRightSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/2Answers/button_2answers_right_selected"];
    
    [self.bt_left setBackgroundImage:imgBtLeft  forState:UIControlStateNormal];
    [self.bt_left setBackgroundImage:imgBtLeftSelected forState:UIControlStateSelected];
    
    [self.bt_left addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt_left setTag:0];
    
    [self.bt_right setBackgroundImage:imgBtRight  forState:UIControlStateNormal];
    [self.bt_right setBackgroundImage:imgBtRightSelected  forState:UIControlStateSelected];
    [self.bt_right addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt_right setTag:1];
    
    [self.lb_left setFont:CONFFONTBOLDSIZE(17)];
    [self.lb_right setFont:CONFFONTBOLDSIZE(17)];
    [self.lb_left setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    [self.lb_right setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    
    GCAnswerModel *answerModelLeft = [questionModel.answers objectAtIndex:0];
    if (answerModelLeft && [answerModelLeft isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points_answer_left)
        {
            self.points_answer_left = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points_left addSubviewToBonce:self.points_answer_left];
        }
        [self.points_answer_left updateWithInteger:answerModelLeft.score];
        [self.lb_left setText:answerModelLeft.answer];
    }

    GCAnswerModel *answerModelRight = [questionModel.answers objectAtIndex:1];
    if (answerModelRight && [answerModelRight isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points_answer_right)
        {
            self.points_answer_right = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points_right addSubviewToBonce:self.points_answer_right];
        }
        [self.points_answer_right updateWithInteger:answerModelRight.score];
        [self.lb_right setText:answerModelRight.answer];
    }
    [self addSubviewToBonce:self.answer_two];
    [self setUpViewTimer:self.vw_central];
    
    // Store label to change their color
    if (!arrayOfLabelEmbedded)
        arrayOfLabelEmbedded = [[NSMutableArray alloc]initWithCapacity:2];
    else
        [arrayOfLabelEmbedded removeAllObjects];
    [arrayOfLabelEmbedded addObject:self.lb_left];
    [arrayOfLabelEmbedded addObject:self.lb_right];
}

-(void)setUpViewForThree
{
    UIImage *imgBtTop = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/3Answers/button_3answers_top"];
    UIImage *imgBtLeft = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/3Answers/button_3answers_left"];
    UIImage *imgBtRight = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/3Answers/button_3answers_right"];

    UIImage *imgBtTopSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/3Answers/button_3answers_top_selected"];
    UIImage *imgBtLeftSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/3Answers/button_3answers_left_selected"];
    UIImage *imgBtRightSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/3Answers/button_3answers_right_selected"];
    
    [self.bt3_top setBackgroundImage:imgBtTop forState:UIControlStateNormal];
    [self.bt3_top setBackgroundImage:imgBtTopSelected forState:UIControlStateSelected];
    [self.bt3_top addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt3_top setTag:0];
    
    [self.bt3_left setBackgroundImage:imgBtLeft forState:UIControlStateNormal];
    [self.bt3_left setBackgroundImage:imgBtLeftSelected forState:UIControlStateSelected];
    [self.bt3_left addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt3_left setTag:1];
    
    [self.bt3_right setBackgroundImage:imgBtRight forState:UIControlStateNormal];
    [self.bt3_right setBackgroundImage:imgBtRightSelected forState:UIControlStateSelected];
    [self.bt3_right addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt3_right setTag:2];
    
    [self.lb3_top setFont:CONFFONTBOLDSIZE(17)];
    [self.lb3_left setFont:CONFFONTBOLDSIZE(17)];
    [self.lb3_right setFont:CONFFONTBOLDSIZE(17)];
    
    [self.lb3_top setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    [self.lb3_left setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    [self.lb3_right setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    
    GCAnswerModel *answerModelTop = [questionModel.answers objectAtIndex:0];
    if (answerModelTop && [answerModelTop isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points3_answer_top)
        {
            self.points3_answer_top = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points3_top addSubviewToBonce:self.points3_answer_top];
        }
        [self.points3_answer_top updateWithInteger:answerModelTop.score];
        [self.lb3_top setText:answerModelTop.answer];
    }

    GCAnswerModel *answerModelLeft = [questionModel.answers objectAtIndex:1]; // LEFT
    if (answerModelLeft && [answerModelLeft isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points3_answer_left)
        {
            self.points3_answer_left = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points3_left addSubviewToBonce:self.points3_answer_left];
        }
        [self.points3_answer_left updateWithInteger:answerModelLeft.score];
        [self.lb3_left setText:answerModelLeft.answer];
    }

    GCAnswerModel *answerModelRight = [questionModel.answers objectAtIndex:2]; // RIGHT
    if (answerModelRight && [answerModelRight isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points3_answer_right)
        {
            self.points3_answer_right = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points3_right addSubviewToBonce:self.points3_answer_right];
        }
        [self.points3_answer_right updateWithInteger:answerModelRight.score];
        [self.lb3_right setText:answerModelRight.answer];
    }
    [self addSubviewToBonce:self.answer_three];
    [self setUpViewTimer:self.vw3_central];
    
    // Store label to change their color
    if (!arrayOfLabelEmbedded)
        arrayOfLabelEmbedded = [[NSMutableArray alloc]initWithCapacity:2];
    else
        [arrayOfLabelEmbedded removeAllObjects];
    [arrayOfLabelEmbedded addObject:self.lb3_top];
    [arrayOfLabelEmbedded addObject:self.lb3_left];
    [arrayOfLabelEmbedded addObject:self.lb3_right];
}

-(void)setUpViewForFour
{
    UIImage *imgBtLeftTop = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_left_top"];
    UIImage *imgBtRightTop = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_right_top"];
    UIImage *imgBtLeftBottom = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_left_bottom"];
    UIImage *imgBtRightBottom = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_right_bottom"];

    UIImage *imgBtLeftTopSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_left_top_selected"];
    UIImage *imgBtRightTopSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_right_top_selected"];
    UIImage *imgBtLeftBottomSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_left_bottom_selected"];
    UIImage *imgBtRightBottomSelected = [UIImage imageNamed:@"GCBundleRessources.bundle/Question/4Answers/button_4answers_right_bottom_selected"];
    
    [self.bt4_lefttop setBackgroundImage:imgBtLeftTop forState:UIControlStateNormal];
    [self.bt4_lefttop setBackgroundImage:imgBtLeftTopSelected forState:UIControlStateSelected];
    [self.bt4_lefttop addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt4_lefttop setTag:0];

    [self.bt4_righttop setBackgroundImage:imgBtRightTop forState:UIControlStateNormal];
    [self.bt4_righttop setBackgroundImage:imgBtRightTopSelected forState:UIControlStateSelected];
    [self.bt4_righttop addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt4_righttop setTag:1];

    [self.bt4_leftbottom setBackgroundImage:imgBtLeftBottom forState:UIControlStateNormal];
    [self.bt4_leftbottom setBackgroundImage:imgBtLeftBottomSelected forState:UIControlStateSelected];
    [self.bt4_leftbottom addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt4_leftbottom setTag:2];
    
    [self.bt4_rightbottom setBackgroundImage:imgBtRightBottom forState:UIControlStateNormal];
    [self.bt4_rightbottom setBackgroundImage:imgBtRightBottomSelected forState:UIControlStateSelected];
    [self.bt4_rightbottom addTarget:self action:@selector(clickButtonAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bt4_rightbottom setTag:3];
    
    [self.lb4_lefttop setFont:CONFFONTBOLDSIZE(17)];
    [self.lb4_righttop setFont:CONFFONTBOLDSIZE(17)];
    [self.lb4_leftbottom setFont:CONFFONTBOLDSIZE(17)];
    [self.lb4_rightbottom setFont:CONFFONTBOLDSIZE(17)];
    
    [self.lb4_lefttop setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    [self.lb4_righttop setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    [self.lb4_leftbottom setTextColor:CONFCOLORFORKEY(@"answers_lb")];
    [self.lb4_rightbottom setTextColor:CONFCOLORFORKEY(@"answers_lb")];

    // Data set
    GCAnswerModel *answerModelLeftTop = [questionModel.answers objectAtIndex:0];
    if (answerModelLeftTop && [answerModelLeftTop isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points4_answer_lefttop)
        {
            self.points4_answer_lefttop = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points4_lefttop addSubviewToBonce:self.points4_answer_lefttop];
        }
        [self.points4_answer_lefttop updateWithInteger:answerModelLeftTop.score];
        [self.lb4_lefttop setText:answerModelLeftTop.answer];
    }
    
    GCAnswerModel *answerModeRightTop = [questionModel.answers objectAtIndex:1];
    if (answerModeRightTop && [answerModeRightTop isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points4_answer_righttop)
        {
            self.points4_answer_righttop = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points4_righttop addSubviewToBonce:self.points4_answer_righttop];
        }
        [self.points4_answer_righttop updateWithInteger:answerModeRightTop.score];
        [self.lb4_righttop setText:answerModeRightTop.answer];
    }
    
    GCAnswerModel *answerModelLeftBottom = [questionModel.answers objectAtIndex:2];
    if (answerModelLeftBottom && [answerModelLeftBottom isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points4_answer_leftbottom)
        {
            self.points4_answer_leftbottom = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points4_leftbottom addSubviewToBonce:self.points4_answer_leftbottom];
        }
        [self.points4_answer_leftbottom updateWithInteger:answerModelLeftBottom.score];
        [self.lb4_leftbottom setText:answerModelLeftBottom.answer];
    }
    
    GCAnswerModel *answerModelRightBottom = [questionModel.answers objectAtIndex:3];
    if (answerModelRightBottom && [answerModelRightBottom isKindOfClass:[GCAnswerModel class]])
    {
        if (!self.points4_answer_rightbottom)
        {
            self.points4_answer_rightbottom = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:self options:nil]getObjectsType:[GCPointsView class]];
            [self.points4_rightbottom addSubviewToBonce:self.points4_answer_rightbottom];
        }
        [self.points4_answer_rightbottom updateWithInteger:answerModelRightBottom.score];
        [self.lb4_rightbottom setText:answerModelRightBottom.answer];
    }
    [self addSubviewToBonce:self.answer_four];
    [self setUpViewTimer:self.vw4_central];
    
    // Store label to change their color
    if (!arrayOfLabelEmbedded)
        arrayOfLabelEmbedded = [[NSMutableArray alloc]initWithCapacity:2];
    else
        [arrayOfLabelEmbedded removeAllObjects];
    [arrayOfLabelEmbedded addObject:self.lb4_lefttop];
    [arrayOfLabelEmbedded addObject:self.lb4_righttop];
    [arrayOfLabelEmbedded addObject:self.lb4_leftbottom];
    [arrayOfLabelEmbedded addObject:self.lb4_rightbottom];
}

-(void)unselectAllButtons
{
    [self visiteurView:^(UIView *elt)
    {
        if ([elt isKindOfClass:[UIButton class]])
        {
            UIButton *buttonAnswer = (UIButton *)elt;
            buttonAnswer.selected = NO;
        }
        else if ([elt isKindOfClass:[UILabel class]])
        {
            UILabel *answerLabel = (UILabel *)elt;
            [answerLabel setTextColor:CONFCOLORFORKEY(@"answers_selected_lb")];
        }
    } cbAfter:^(UIView *elt) {
    }];
}

-(void)clickButtonAnswer:(id)sender
{
    if (!arrayOfAnswers)
        arrayOfAnswers = [NSMutableArray new];
    
    UIButton *bt_clicked = sender;
    BOOL lastSelectedState = bt_clicked.selected;
    
    if (questionModel.answers && [questionModel.answers count] > 0 && [bt_clicked isKindOfClass:[UIButton class]])
    {
        if (bt_clicked.tag < [questionModel.answers count])
        {
            GCAnswerModel *answerModelSelected = [questionModel.answers objectAtIndex:bt_clicked.tag];
            if (answerModelSelected && [answerModelSelected isKindOfClass:[GCAnswerModel class]])
            {
//                if (questionModel.type == eGCQuestionTypeMCQ)
//                {
//                    if (lastSelectedState == YES)
//                        [self removeAnswerThatMatch:answerModelSelected];
//                    else
//                        [arrayOfAnswers addObject:answerModelSelected];
//                }
//                else
//                {
//
//                }
                [arrayOfAnswers removeAllObjects];
                [arrayOfAnswers addObject:answerModelSelected];
                [self unselectAllButtons];
                if (self.delegate && [self.delegate respondsToSelector:@selector(GCDidSelectAnswer:onQuestion:fromAnswerView:)])
                    [self.delegate GCDidSelectAnswer:answerModelSelected onQuestion:questionModel fromAnswerView:self];

                NSLog(@"Answer selected id : %@, name : %@", answerModelSelected._id, answerModelSelected.answer);
            }
        }
    }
    bt_clicked.selected = !bt_clicked.selected;
    
    if (arrayOfLabelEmbedded && [arrayOfLabelEmbedded count] > bt_clicked.tag)
    {
        UILabel *answerLabel = [arrayOfLabelEmbedded objectAtIndex:bt_clicked.tag];
        if (answerLabel && [answerLabel isKindOfClass:[UILabel class]])
            [answerLabel setTextColor:bt_clicked.selected ?CONFCOLORFORKEY(@"answers_selected_lb") : CONFCOLORFORKEY(@"answers_lb")];
    }
}

-(void)removeAnswerThatMatch:(GCAnswerModel *)answerModel
{
    if (arrayOfAnswers)
    {
        NSIndexSet *indexOfAnswer = nil;
        for (GCAnswerModel *answered in arrayOfAnswers)
        {
            if ([answered._id isEqualToString:answerModel._id])
            {
                indexOfAnswer = [NSIndexSet indexSetWithIndex:[arrayOfAnswers indexOfObject:answered]];
                break;
            }
        }
        if (indexOfAnswer)
            [arrayOfAnswers removeObjectsAtIndexes:indexOfAnswer];
    }
}

-(BOOL)containsAnswerThatMatch:(GCAnswerModel *)answerModel
{
    if (arrayOfAnswers)
    {
        for (GCAnswerModel *answered in arrayOfAnswers)
        {
            if ([answered._id isEqualToString:answerModel._id])
            {
                return YES;
            }
        }
    }
    return NO;
}


-(NSArray *) getSelectedQuestions
{
    if (!arrayOfAnswers)
        arrayOfAnswers = [[NSMutableArray alloc] init];
    return [arrayOfAnswers ToUnMutable];
}

@end
