//
//  GCQuestionRender.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCQuestionRender.h"
#import "GCQuestionModel.h"
#import "GCAnswerModel.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCQuestionRender
{
    GCQuestionModel *questionModel;
    NSTimer *timerCountdown;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    { }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    if (timerCountdown)
    {
        [timerCountdown invalidate];
        timerCountdown = nil;
        [self launchTimer];
    }
}

-(void) setFonts
{
    [self.lb_question setFont:CONFFONTBOLDSIZE(17)];
    [self.lb_statusAnswer setFont:CONFFONTITALICSIZE(14)];
}

-(void)setColors:(BOOL) hasSupplementaryTint
{
    [self.lb_question setTextColor:CONFCOLORFORKEY(@"question_render_title_lb")];
    [self.lb_statusAnswer setTextColor:CONFCOLORFORKEY(@"question_status_lb")];

    if (hasSupplementaryTint)
        [self setBackgroundColor:CONFCOLORFORKEY(@"question_cell_supplementary_tint_bg")];
    else
        [self setBackgroundColor:CONFCOLORFORKEY(@"question_cell_bg")];
}

/* Answered */
-(void)setUpStatusAnsweredQuestion
{
    [points setHidden:NO];
    NSUInteger scoreYouCouldHaveWon = 0;
    
    if (questionModel.type == eGCQuestionTypePrediction)
    {
        for (GCAnswerModel *answerRightModel in [questionModel getMyAnswersModel])
            scoreYouCouldHaveWon += answerRightModel.score;
    }
    else
        scoreYouCouldHaveWon = questionModel.score;

    if (clock)
    {
        [clock removeFromSuperview];
        clock = nil;
    }
    
    [points updateWithInteger:scoreYouCouldHaveWon andPointsType:eGCPointsQuestionAnswered];
    UIImage *image = [[UIImage imageNamed:@"GCBundleRessources.bundle/Game/question_status_answered"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self.iv_questionResultStatus setImage:image];
    self.iv_questionResultStatus.tintColor = CONFCOLORFORKEY(@"points_won_bg");

    [self.v_countdown setHidden:YES];
    
    NSString *strRep = SWF(@"%@: %@", [questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil), [questionModel formatMyAnswers]);
    NSMutableAttributedString *attRep = [[NSMutableAttributedString alloc] initWithString:strRep];
    [attRep addAttributes:@{NSFontAttributeName:CONFFONTITALICSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"question_status_lb")} range:NSMakeRange(0, [[questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil) length] + 1)];
    [attRep addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"question_myanswer_lb")} range:NSMakeRange([[questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil) length] + 2, [[questionModel formatMyAnswers] length])];
    [self.lb_statusAnswer setAttributedTexteRecadre:attRep width:self.lb_statusAnswer.frame.size.width];
    [self.lb_statusAnswer setFrame:CGRectMake(self.v_countdown.frame.origin.x, self.lb_statusAnswer.frame.origin.y, self.lb_statusAnswer.frame.size.width, self.lb_statusAnswer.frame.size.height)];
}

/* Right answer */
-(void)setUpStatusAnsweredQuestionWithRightAnswer
{
    [points setHidden:NO];
    NSUInteger scoreYouHaveWon = questionModel.points_earned;

    [points updateWithInteger:scoreYouHaveWon andPointsType:eGCPointsQuestionRightAnswer];

    if (clock)
    {
        [clock removeFromSuperview];
        clock = nil;
    }

    UIImage *image = [[UIImage imageNamed:@"GCBundleRessources.bundle/Game/good_answer"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self.iv_questionResultStatus setImage:image];
    self.iv_questionResultStatus.tintColor = CONFCOLORFORKEY(@"points_won_bg");
    [self.v_countdown setHidden:YES];

    NSString *strRep = SWF(@"%@: %@", [questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil), [questionModel formatMyAnswers]);
    NSMutableAttributedString *attRep = [[NSMutableAttributedString alloc] initWithString:strRep];
    [attRep addAttributes:@{NSFontAttributeName:CONFFONTITALICSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"question_status_lb")} range:NSMakeRange(0, [[questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil) length] + 1)];
    [attRep addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"question_myanswer_lb")} range:NSMakeRange([[questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil) length] + 2, [[questionModel formatMyAnswers] length])];
    [self.lb_statusAnswer setAttributedTexteRecadre:attRep width:self.lb_statusAnswer.frame.size.width];
    [self.lb_statusAnswer setFrame:CGRectMake(self.v_countdown.frame.origin.x, self.lb_statusAnswer.frame.origin.y, self.lb_statusAnswer.frame.size.width, self.lb_statusAnswer.frame.size.height)];
}

/* Bad answer */
-(void)setUpStatusAnsweredQuestionWithBadAnswer
{
    [points setHidden:NO];
    NSUInteger scoreYouCouldHaveWon = 0;
    
    if (questionModel.type == eGCQuestionTypePrediction)
    {
        for (GCAnswerModel *answerRightModel in [questionModel getRightAnswersModel])
            scoreYouCouldHaveWon += answerRightModel.score;
    }
    else
        scoreYouCouldHaveWon = questionModel.score;

    [points updateWithInteger:scoreYouCouldHaveWon andPointsType:eGCPointsQuestionWrongAnswer];

    if (clock)
    {
        [clock removeFromSuperview];
        clock = nil;
    }

    UIImage *image = [[UIImage imageNamed:@"GCBundleRessources.bundle/Game/bad_answer"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self.iv_questionResultStatus setImage:image];
    self.iv_questionResultStatus.tintColor = CONFCOLORFORKEY(@"points_lost_bg");
    [self.v_countdown setHidden:YES];

    NSString *strRep = SWF(@"%@: %@ (%@)", [questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil), [questionModel formatMyAnswers], [questionModel formatRightAnswers]);
    NSMutableAttributedString *attRep = [[NSMutableAttributedString alloc] initWithString:strRep];
    [attRep addAttributes:@{NSFontAttributeName:CONFFONTITALICSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"question_status_lb")} range:NSMakeRange(0, [[questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil) length] + 1)];
    [attRep addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"question_myanswer_lb")} range:NSMakeRange([[questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil) length] + 2, [[questionModel formatMyAnswers] length])];
    [attRep addAttributes:@{NSFontAttributeName:CONFFONTREGULARSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"question_myanswer_lb")} range:NSMakeRange([[questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_my_answers", nil) : NSLocalizedString(@"gc_my_answer", nil) length] + 3 + [[questionModel formatMyAnswers] length], [[questionModel formatRightAnswers] length] + 2)];
    [self.lb_statusAnswer setAttributedTexteRecadre:attRep width:self.lb_statusAnswer.frame.size.width];
    [self.lb_statusAnswer setFrame:CGRectMake(self.v_countdown.frame.origin.x, self.lb_statusAnswer.frame.origin.y, self.lb_statusAnswer.frame.size.width, self.lb_statusAnswer.frame.size.height)];
}

/* Pending */
-(void)setUpStatusPendingQuestion
{
    [points setHidden:YES];
    [self.lb_statusAnswer setTexteRecadre:SWF(@"%@...", NSLocalizedString(@"gc_pending", nil)) width:self.lb_statusAnswer.frame.size.width];
    [self.iv_questionResultStatus setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Game/question_status_pending"]];
    
    if (!clock)
    {
        clock = [[[NSBundle mainBundle] loadNibNamed:@"GCTimeCountdownView" owner:nil options:nil]getObjectsType:[GCTimeCountdownView class]];
        [self.v_countdown addSubviewToBonce:clock];
        [self launchTimer];
    }
    [self.v_countdown setHidden:NO];
}

-(void)launchTimer
{
//    NSIndexPath *indPath = [];
    NSTimeInterval timeInterval = [questionModel getRemainingSeconds];
    if (timeInterval >= 0)
    {
        CGRect rectClockFrame = [clock updateCountDownAndReturnFrame:timeInterval];
        [self.v_countdown setFrame:CGRectMake(self.v_countdown.frame.origin.x, self.v_countdown.frame.origin.y, rectClockFrame.size.width, self.v_countdown.frame.size.height)];

        if (rectClockFrame.size.width > 0.0)
        {
            [self.lb_statusAnswer setFrame:CGRectMake(self.v_countdown.frame.origin.x + rectClockFrame.size.width + 5, self.lb_statusAnswer.frame.origin.y, self.lb_statusAnswer.frame.size.width, self.lb_statusAnswer.frame.size.height)];
        }

        timerCountdown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(launchTimer) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timerCountdown forMode:NSRunLoopCommonModes];
    }
    else
    {
        [timerCountdown invalidate];
        timerCountdown = nil;
        questionModel.status = eGCQuestionStatusFinished;
        [self setUpViewsReguardingStatus:questionModel];
    }
}

/* Missed */
-(void)setUpStatusMissedQuestion
{
    [points setHidden:NO];
    
    NSUInteger scoreYouCouldHaveWon = 0;
    
    if (questionModel.type == eGCQuestionTypePrediction)
    {
        for (GCAnswerModel *answerRightModel in [questionModel getRightAnswersModel])
            scoreYouCouldHaveWon += answerRightModel.score;
    }
    else
        scoreYouCouldHaveWon = questionModel.score;
    
    [points updateWithInteger:scoreYouCouldHaveWon andPointsType:eGCPointsQuestionWrongAnswer];
    [self.lb_statusAnswer setTexteRecadre:NSLocalizedString(@"gc_missed", nil) width:self.lb_statusAnswer.frame.size.width];


    UIImage *image = [[UIImage imageNamed:@"GCBundleRessources.bundle/Game/question_status_missed"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self.iv_questionResultStatus setImage:image];
    self.iv_questionResultStatus.tintColor = CONFCOLORFORKEY(@"points_lost_bg");

    if (clock)
    {
        [clock removeFromSuperview];
        clock = nil;
    }
    [self.v_countdown setHidden:YES];
    [self.lb_statusAnswer setFrame:CGRectMake(self.v_countdown.frame.origin.x, self.lb_statusAnswer.frame.origin.y, self.lb_statusAnswer.frame.size.width, self.lb_statusAnswer.frame.size.height)];
}

-(void)setUpViewsReguardingStatus:(GCQuestionModel *)questionModelRender
{
    questionModel = questionModelRender;
    
    [self.lb_question setFrame:CGRectMake(self.lb_question.frame.origin.x, self.lb_question.frame.origin.y, self.v_points.frame.origin.x - self.lb_question.frame.origin.x - 10, self.lb_question.frame.size.height)];
    [self.lb_question setTexteRecadre:questionModel.question width:self.lb_question.frame.size.width];

    [self.lb_statusAnswer setFrame:CGRectMake(self.lb_statusAnswer.frame.origin.x,
                                              self.lb_question.frame.origin.y + self.lb_question.frame.size.height + 5,
                                              self.lb_question.frame.size.width,
                                              self.lb_statusAnswer.frame.size.height)];

    if (!points)
    {
        points = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:nil options:nil] getObjectsType:[GCPointsView class]];
        [self.v_points addSubviewToBonce:points autoSizing:YES];
    }
    if (timerCountdown)
    {
        [timerCountdown invalidate];
        timerCountdown = nil;
    }

    if ([questionModel isQuestionActive] == YES &&
        [questionModel.my_answers count] == 0)
        [self setUpStatusPendingQuestion];
    
    if ([questionModel isQuestionActive] == NO &&
        [questionModel.my_answers count] == 0)
        [self setUpStatusMissedQuestion];
    
    if ([questionModel hasRightAnswerAvailable] == NO &&
/*        [questionModel isQuestionActive] == YES && */
        [questionModel.my_answers count] > 0)
        [self setUpStatusAnsweredQuestion];
    
    if ([questionModel hasRightAnswerAvailable] == YES &&
        [questionModel.my_answers count] > 0 &&
        questionModel.points_earned > 0)
        [self setUpStatusAnsweredQuestionWithRightAnswer];

    if ([questionModel hasRightAnswerAvailable] == YES &&
        [questionModel.my_answers count] > 0 &&
        (questionModel.points_earned == 0))
        [self setUpStatusAnsweredQuestionWithBadAnswer];
}

/*
 ** SetCell - Render
 */
-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    [self setColors:indexPath.row % 2 ? NO : YES];
    [self setFonts];

    if (elt && [elt isKindOfClass:[GCQuestionModel class]])
    {
        GCQuestionModel *questionModelElement = elt;
        [self setUpViewsReguardingStatus:questionModelElement];
    }
    
    [self.v_countdown setFrame:CGRectMake(self.v_countdown.frame.origin.x, self.lb_question.frame.origin.y + self.lb_question.frame.size.height + 2, self.v_countdown.frame.size.width, self.v_countdown.frame.size.height)];
    
    CGFloat newHeight = self.lb_statusAnswer.frame.origin.y + self.lb_statusAnswer.frame.size.height + 10;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight)];
    
//    NSLog(@"[SetCell] Cell at : %@, HEIGHT => %f", indexPath, self.frame.size.height);
}

#pragma IIRenderGG Protocol
+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:[GCQuestionRender getIdentifierCell] owner:nil options:nil] getObjectsType:[GCQuestionRender class]];
    [cell layoutIfNeeded];
    [((GCQuestionRender*)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCQuestionRender";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    UICollectionReusableView *cell = [[[NSBundle mainBundle] loadNibNamed:[GCQuestionRender getIdentifierCell] owner:nil options:nil] getObjectsType:[GCQuestionRender class]];
    [cell setFrame:CGRectMake(0, 0, collectionView.frame.size.width, cell.frame.size.height)];
    [cell layoutIfNeeded];
    [((GCQuestionRender*)cell) setCell:elt vc:nil indexPath:(NSIndexPath*)indexPath];
    
//    NSLog(@"[GetSize] Cell at : %@, HEIGHT => %f", indexPath, cell.frame.size.height);
    return CGSizeMake(collectionView.frame.size.width, cell.frame.size.height);
}

@end
