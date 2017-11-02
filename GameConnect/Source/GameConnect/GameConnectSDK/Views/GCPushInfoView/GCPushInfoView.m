//
//  GCPushInfoView.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCPushInfoView.h"
#import "GCAnswerModel.h"
#import "GCProcessQuestionManager.h"
//#import "GCLoggerManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCPushInfoView()
{
    GCPointsView *points;
    NSTimer *timerDisplayingPushInfo;
}
- (IBAction)clickOnShare:(id)sender;
@end

@implementation GCPushInfoView

-(void)myInit
{
    [self initPushInfoView];
}

-(void)initPushInfoView
{
    [self setBackgroundColor:CONFCOLORFORKEY(@"question_answers_bloc_bg")];
    [self.v_pushInfoBackground setBackgroundColor:CONFCOLORFORKEY(@"push_info_title_bg")];
    
    [self.bt_sharing setTitle:NSLocalizedString(@"gc_share", nil) forState:UIControlStateNormal];
    [self.bt_sharing setTitleColor:CONFCOLORFORKEY(@"answers_selected_bt") forState:UIControlStateNormal];
    [self.bt_sharing.titleLabel setFont:CONFFONTSIZE(15)];
}

-(void) setPushInfoType:(ePushInfoType)pushInfoType
{
    if (pushInfoType == ePushInfoBadge)
    {
        [self.v_pushInfobottomBackground setBackgroundColor:CONFCOLORFORKEY(@"push_info_description_bg")];
    }
    else
    {
    }
}

-(void) updateWithTrophyModel:(GCTrophyModel *)trophyModel
{
    self.trophyModel = trophyModel;
    [self setPushInfoType:ePushInfoBadge];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    if (trophyModel)
    {
        NSMutableAttributedString *attributedQuestion = [[NSMutableAttributedString alloc] initWithString:trophyModel.name];
        [attributedQuestion addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [trophyModel.name length])];
        [attributedQuestion addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(16), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_main_title_lb")} range:NSMakeRange(0, [trophyModel.name length])];
        [self.tv_mainTitlePushInfo setAttributedText:attributedQuestion];
        
        NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] initWithString:trophyModel.desc];
        [attributedResult addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [trophyModel.desc length])];
        [attributedResult addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(12), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_result_answer_lb")} range:NSMakeRange(0, [trophyModel.desc length])];
        [self.tv_subTitlePushInfo setAttributedText:attributedResult];

        if (trophyModel.picture_url && [trophyModel.picture_url length] > 0)
        {
            [self startLoaderInView:self.iv_pushInfoImage andHideView:YES];
            [self.iv_pushInfoImage loadImageFromURL:trophyModel.picture_url ttl:[[[GCConfManager getInstance] getValue:GCConfigValueImageTTL] intValue] endblock:^(UIImageViewJA *image)
             {
                 [self stopLoaderInView:self.iv_pushInfoImage andShowView:YES];
             }];
        }
        else
            [self.iv_pushInfoImage setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/General/badge_default"]];
    }

    __weak GCPushInfoView *weak_self = self;
    [self performWithDelay:0.1 block:^{
        [weak_self makeTextViewVerticallyCentered:weak_self.tv_subTitlePushInfo];
        [weak_self makeTextViewVerticallyCentered:weak_self.tv_mainTitlePushInfo];
    }];
}

-(void) updateWithQuestionModel:(GCQuestionModel *)questionModel
{
    self.questionModel = questionModel;
    [self setPushInfoType:ePushInfoQuestionResult];

    if (questionModel)
    {
        NSUInteger numberOfGoodAnswer = [[questionModel getRightAnswersModel] count];
        NSString *myAnswers = [questionModel formatMyAnswers];
        NSString *goodAnswers = [questionModel formatRightAnswers];
        
        BOOL iHaveAllRightAnswers = NO;
        if ([questionModel.my_answers count] == [[questionModel getMyRightAnswersModel] count] && [[questionModel getMyRightAnswersModel] count] == numberOfGoodAnswer)
            iHaveAllRightAnswers = YES;

        if (questionModel.type == eGCQuestionTypePoll)
            iHaveAllRightAnswers = YES;

        // Points
        points = [[[NSBundle mainBundle] loadNibNamed:@"GCPointsView" owner:nil options:nil] getObjectsType:[GCPointsView class]];
        [self.v_pushInfoPoints addSubviewToBonce:points];   
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;

        NSString *representationOfTopText = SWF(@"%@\n%@", questionModel.question, SWF(@"%@: %@", [questionModel.my_answers count] > 1 ? NSLocalizedString(@"gc_your_answers", @"") : NSLocalizedString(@"gc_your_answer", @""), myAnswers));
        NSUInteger indexOfReturnInQuestion = [representationOfTopText rangeOfString:@"\n"].location;

        NSMutableAttributedString *attributedQuestion = [[NSMutableAttributedString alloc] initWithString:representationOfTopText];
        [attributedQuestion addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [representationOfTopText length])];
        [attributedQuestion addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(17), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_main_title_lb")} range:[representationOfTopText rangeOfString:self.questionModel.question]];

        [attributedQuestion addAttributes:@{NSFontAttributeName:CONFFONTITALICSIZE(11), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_previous_lb")} range:NSMakeRange(indexOfReturnInQuestion, [representationOfTopText length]-indexOfReturnInQuestion)];

        [self.tv_mainTitlePushInfo setAttributedText:attributedQuestion];

        if (!iHaveAllRightAnswers) // I am wrong
        {
            
            NSString *result = [numberOfGoodAnswer > 1 ? NSLocalizedString(@"gc_good_answers", nil) : numberOfGoodAnswer == 0 ? NSLocalizedString(@"gc_no_good_answers", nil) : NSLocalizedString(@"gc_good_answer", nil) uppercaseString];
            
            NSString *representationOfBottomText = SWF(@"%@\n%@", result, goodAnswers);
            NSUInteger indexOfReturnResult = [representationOfBottomText rangeOfString:@"\n"].location;

            NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] initWithString:representationOfBottomText];
            [attributedResult addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [representationOfBottomText length])];
            [attributedResult addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(11), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_result_answer_lb")} range:[representationOfBottomText rangeOfString:result]];
            
            [attributedResult addAttributes:@{NSFontAttributeName:CONFFONTITALICSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_right_answer_lb")} range:NSMakeRange(indexOfReturnResult, [representationOfBottomText length]-indexOfReturnResult)];
            
            [self.tv_subTitlePushInfo setAttributedText:attributedResult];

            NSUInteger scoreYouCouldHaveWon = 0;
            if (questionModel.type == eGCQuestionTypePrediction)
            {
                for (GCAnswerModel *answerRightModel in [questionModel getRightAnswersModel])
                    scoreYouCouldHaveWon += answerRightModel.score;
            }
            else
                scoreYouCouldHaveWon = questionModel.score;
            
            [points updateWithInteger:scoreYouCouldHaveWon andPointsType:eGCPointsQuestionWrongAnswer];
            [points.lb_points setText:@"+0"];
            [self.v_pushInfobottomBackground setBackgroundColor:CONFCOLORFORKEY(@"push_info_bad_answer_bg")];
            [self.iv_pushInfoImage setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Game/bad_answer_image"]];
        }
        else // I am right
        {
            [self.v_pushInfobottomBackground setBackgroundColor:CONFCOLORFORKEY(@"push_info_good_answer_bg")];
            [points updateWithInteger:self.questionModel.points_earned andPointsType:eGCPointsQuestionRightAnswer];
            
            if (questionModel.type == eGCQuestionTypePoll)
            {
                [self.iv_pushInfoImage setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Game/poll_answer"]];
                NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"gc_thanks_answering_poll", nil)];
                [attributedResult addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [NSLocalizedString(@"gc_thanks_answering_poll", nil) length])];

                [attributedResult addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(11), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_result_answer_lb")} range:NSMakeRange(0, [NSLocalizedString(@"gc_thanks_answering_poll", nil) length])];
                [self.tv_subTitlePushInfo setAttributedText:attributedResult];
            }
            else
            {
                [self.iv_pushInfoImage setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Game/good_answer_image"]];
                
                NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] initWithString:goodAnswers];
                [attributedResult addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [goodAnswers length])];
                
                [attributedResult addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(11), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"push_info_result_answer_lb")} range:NSMakeRange(0, [goodAnswers length])];
                [self.tv_subTitlePushInfo setAttributedText:attributedResult];
            }
        }
        __weak GCPushInfoView *weak_self = self;
        [self performWithDelay:0.1 block:^{
            [weak_self makeTextViewVerticallyCentered:weak_self.tv_subTitlePushInfo];
            [weak_self makeTextViewVerticallyCentered:weak_self.tv_mainTitlePushInfo];
        }];
    }
    [self startTimerPushInfo];
}

-(void)makeTextViewVerticallyCentered:(id)object
{
    if (object && [object isKindOfClass:[UITextView class]])
    {
        UITextView *tv = object;
        CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])  / 2.0;
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    }
}

#pragma mark - Timer
-(void)startTimerPushInfo
{
    [self stopTimerPushInfo];
    timerDisplayingPushInfo = [NSTimer scheduledTimerWithTimeInterval:[[[GCConfManager getInstance] getValue:CGConfigDelayDisplayingPushInfo] doubleValue] target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
}

-(void)timerFired
{
    [self stopTimerPushInfo];
    [self clickOnClose:nil];
}

-(void)stopTimerPushInfo
{
    if (timerDisplayingPushInfo)
        [timerDisplayingPushInfo invalidate];
    timerDisplayingPushInfo = nil;
}

#pragma mark - User Interactions
- (IBAction)clickOnShare:(id)sender
{
    if (!self.delegate)
    {
        //GCLog(@"Delegate <GCPushInfoViewDelegate> doesn't exist");
        return ;
    }

    if ([self.delegate respondsToSelector:@selector(GCDidRequestToShare:fromSender:)])
    {
        if (self.questionModel)
            [self.delegate GCDidRequestToShare:self.questionModel fromSender:self];

        if (self.trophyModel)
            [self.delegate GCDidRequestToShare:self.trophyModel fromSender:self];
    }
}

- (IBAction)clickOnClose:(id)sender
{
    if (self.callBackClosingView)
        self.callBackClosingView();
}

@end
