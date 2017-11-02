//
//  GCAnswersViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAnswersViewController.h"
#import "GCAnswersViewController+GCUI.h"
#import "GCAnswersViewController_Private.h"
#import "GCProcessQuestionManager.h"
#import "GCQuestionManager.h"
#import "GCSponsorsManager.h"
#import "GCAPPNavigationManageriPhone.h"
#import "GCConfManager.h"

#import <Masonry/Masonry.h>
#import <GameConnect/GameConnect-Swift.h>

@interface GCAnswersViewController () <GCStatisticsViewDelegate, GCAnswersViewDelegate>
{
    NSTimer *timerDisplayingStats;
}

- (IBAction)clickOnValidateAnswers:(id)sender;
- (IBAction)clickOnSharing:(id)sender;
@end

@implementation GCAnswersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initFontsAndColors];

    self.v_backgroundTypeOfQuestion.hidden = YES;
    self.bt_sharing.hidden = YES;
    self.lb_typeOfQuestion.hidden = YES;

    self.questionTextView = [UITextView new];
    self.questionTextView.editable = NO;
    self.questionTextView.selectable = NO;
    self.questionTextView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.questionTextView];
    self.questionTextView.textAlignment = NSTextAlignmentLeft;
    self.questionTextView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    CGFloat inset = 20;
    [self.questionTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).insets(UIEdgeInsetsMake(inset, inset, inset, inset));
    }];

    self.sponsorsAnswersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sponsorsAnswersButton setImage:[UIImage imageNamed:@"gc_answers_sponsors"] forState:UIControlStateNormal];
    [self.sponsorsAnswersButton addTarget:self action:@selector(onTapSponsors) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.sponsorsAnswersButton];
    [self.sponsorsAnswersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@70);
    }];

    self.progressView = [QuestionProgressView new];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.size.equalTo(@(60));
        make.left.equalTo(self.questionTextView.mas_right).offset(20);
        make.top.equalTo(@30);
    }];

    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:separator];

    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.top.equalTo(self.progressView.mas_bottom).offset(40);
        make.left.equalTo(self.questionTextView);
        make.right.equalTo(self.progressView);
        make.top.equalTo(self.questionTextView.mas_bottom).offset(0);
    }];

    self.answerPointsView = [GCAnswerPointsView new];
    [self.view addSubview:self.answerPointsView];

    [self.answerPointsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
        make.centerX.equalTo(@0);
    }];

    self.statsContainer = [UIView new];

    [self.view addSubview:self.statsContainer];

    [self.statsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerPointsView.mas_bottom).offset(10);
        make.left.bottom.right.equalTo(@0);
    }];

    [self.statsContainer addSubview:self.statisticsView];

    [self.statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    [self.view addSubview:self.bt_validationSelectedAnswers];
    [self.bt_validationSelectedAnswers mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sponsorsAnswersButton.mas_top);
        make.width.equalTo(@280);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.sponsorsAnswersButton);
    }];

    self.answersContainer = [UIView new];

    [self.view addSubview:self.answersContainer];

    [self.answersContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerPointsView.mas_bottom).offset(10);
        make.width.equalTo(separator).multipliedBy(0.96);
        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.bt_validationSelectedAnswers.mas_top).offset(-10);
    }];

    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.questionTextView flashScrollIndicators];
}

#pragma mark - Updates

- (void)updateLayoutForQuestionModel:(GCQuestionModel *)questionModel isStats:(BOOL)isStats
{
    BOOL isPrediction = questionModel.type == eGCQuestionTypePrediction;
    BOOL isMCQ = questionModel.type == eGCQuestionTypeMCQ;

    [self.answerPointsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(isPrediction || isStats ? @0 : @30);
    }];

    self.answerPointsView.hidden = isPrediction || isStats;
    [self.answerPointsView loadWith:questionModel.score];

    [self.bt_validationSelectedAnswers mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(isMCQ && !isStats ? @40 : @0);
    }];

    self.bt_validationSelectedAnswers.hidden = !isMCQ || isStats;
}
-(void) updateQuestion:(GCQuestionModel *)questionModel
{
    if (questionModel && [questionModel.my_answers count] == 0 && [questionModel isQuestionActive])
        [self updateNewQuestion:questionModel];
    else if (questionModel)
        [self updateStatsQuestion:questionModel];
}

-(void) updateNewQuestion:(GCQuestionModel *)questionModel
{
    _questionModel = questionModel;
    [self stopTimerStats];
    [self setUpAnswers];
    [self updateLayoutForQuestionModel:questionModel isStats:NO];
}

-(void) updateStatsQuestion:(GCQuestionModel *)questionModel
{

    if (self.questionModel && [self.questionModel._id isEqualToString:questionModel._id])
        self.questionModel.answers = questionModel.answers;
    else
        _questionModel = questionModel;

    [self stopTimerStats];
    if ([_questionModel.my_answers count] > 0 || [_questionModel isQuestionActive] == NO)
    {
        [self updateLayoutForQuestionModel:questionModel isStats:YES];
        [self setUpStats];
    }

}

-(void) updateEndQuestion:(GCQuestionModel *)questionModel
{
    if (self.questionModel && [self.questionModel._id isEqualToString:questionModel._id])
        self.questionModel.status = questionModel.status;
    else
        _questionModel = questionModel;
    
    if (![self.questionModel isQuestionActive] && [self.questionModel.my_answers count] == 0)
        [self setFlashMessage:NSLocalizedString(@"gc_question_finished_message", nil)];
    [self setUpStats];
    [self startTimerStats];
}

- (void)onTapSponsors
{
    [[GCSponsorsManager sharedManager] postPixelRequest];
    NSString *websiteURLString = [GCConfManager getInstance].pmuWebsiteURLString;
//    if ([WifiManager isInPSGStadium]) {
//        websiteURLString = gcConfigModel.pmuPSGWiFiWebsiteURLString;
//    } else {
//        websiteURLString = [GCConfManager getInstance].pmuWebsiteURLString;
//    }

    [[GCAPPNavigationManageriPhone getInstance] pushWebViewControllerWithURLString:websiteURLString pinToTopLayoutGuide:YES];
}

#pragma mark - Timer Displaying Stats
-(void)startTimerStats
{
    [self stopTimerStats];
    timerDisplayingStats = [NSTimer scheduledTimerWithTimeInterval:[[[GCConfManager getInstance] getValue:CGConfigDelayDisplayingStats] doubleValue] target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
}

-(void)timerFired
{
    [self stopTimerStats];
    [self clickOnCloseQuestion:nil];
}

-(void)stopTimerStats
{
    if (timerDisplayingStats)
        [timerDisplayingStats invalidate];
    timerDisplayingStats = nil;
}

#pragma mark - User Interactions
- (IBAction)clickOnValidateAnswers:(id)sender
{
    [self launchAnswer];
}

- (IBAction)clickOnSharing:(id)sender
{
    [[GCProcessQuestionManager sharedManager] shareQuestion:self.questionModel fromViewController:self];
}

- (IBAction)clickOnCloseQuestion:(id)sender
{
    if (self.callBackClosingViewController)
        self.callBackClosingViewController();
}

-(void)launchAnswer
{
    NSArray *arrayOfSelectedAnswersIds = [GCAnswerModel arrayOfAnswersIdsFromArrayOfAnswers:self.answersView.selectedAnswers];
    
    if (!arrayOfSelectedAnswersIds || [arrayOfSelectedAnswersIds count] == 0)
    {
        [self setFlashMessage:NSLocalizedString(@"gc_must_select_one_answer_at_least", nil)];
        return ;
    }

    self.questionModel.my_answers = arrayOfSelectedAnswersIds;

    [self.questionModel addMyAnswersOnTotalCount];
    [self updateStatsQuestion:self.questionModel];
    [self startTimerStats];
    
    __weak GCAnswersViewController *weak_self = self;
    [GCQuestionManager postAnswersQuestion:self.questionModel._id forEvent:self.questionModel.event_id inCompetition:self.questionModel.competition_id withAnswers:arrayOfSelectedAnswersIds cb_response:^(BOOL ok)
     {
         if (ok)
             [[GCProcessQuestionManager sharedManager] questionAnswered:self.questionModel fromViewController:self];
         else
             [weak_self setFlashMessage:NSLocalizedString(@"gc_error_post_answer", nil)];
     }];
}

#pragma mark - GCAnswerViewDelegate
-(void) GCTimerDidEndOnQuestion:(GCQuestionModel *)questionModel fromAnswerView:(GCView *)answerView
{
    [self setFlashMessage:NSLocalizedString(@"gc_question_timeout_message", nil)];
    self.questionModel.status = eGCEventStatusFinished;
    [self setUpStats];
    [self startTimerStats];
    [[GCProcessQuestionManager sharedManager] questionTimeCameOut:questionModel fromViewController:self];
}

-(void) GCDidSelectAnswer:(GCAnswerModel *)answerModel onQuestion:(GCQuestionModel *)questionModel fromAnswerView:(GCView *)answerView
{
    [self launchAnswer];
}

#pragma mark - GCAnswersViewDelegate

- (void)answersView:(GCAnswersView *)answersView didSelectAnswers:(NSArray<GCAnswerModel *> *)answerModels onQuestion:(GCQuestionModel *)questionModel {
    if (questionModel.type != eGCQuestionTypeMCQ) {
        [self launchAnswer];
    }
}

- (void)answersView:(GCAnswersView *)answersView timerDidEndOnQuestion:(GCQuestionModel *)questionModel {
    [self setFlashMessage:NSLocalizedString(@"gc_question_timeout_message", nil)];
    self.questionModel.status = eGCEventStatusFinished;
    [self setUpStats];
    [self startTimerStats];
    [[GCProcessQuestionManager sharedManager] questionTimeCameOut:questionModel fromViewController:self];
}

- (QuestionProgressView *)questionProgressView {
    return self.progressView;
}

#pragma mark - GCStatisticsViewDelegate

- (void)statisticsView:(GCStatisticsView *)statisticsView didRequestShare:(GCQuestionModel *)shareModel
{
    [[GCProcessQuestionManager sharedManager] shareQuestion:shareModel fromViewController:self];
}

- (void)statisticsViewDidTapSponsors:(GCStatisticsView *)statisticsView
{
    [self onTapSponsors];
}

@end
