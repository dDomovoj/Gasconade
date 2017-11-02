//
//  GCAnswersViewController+GCUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 21/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAnswersViewController+GCUI.h"
#import "GCAnswersViewController_Private.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

#import <Masonry/Masonry.h>
#import <GameConnect/GameConnect-Swift.h>

//#import "GCStatisticsView.h"


@implementation GCAnswersViewController (GCUI)

-(void)initFontsAndColors
{
    savedBackgroundFrame = CGRectZero;
    [self.v_backgroundTypeOfQuestion setBackgroundColor:CONFCOLORFORKEY(@"question_type_bg")];
    [self.v_background setBackgroundColor:[UIColor clearColor]];
    [self.lb_typeOfQuestion setTextColor:[UIColor whiteColor]];
    [self.questionTextView setTextColor:[UIColor whiteColor]];
    
    [self.lb_typeOfQuestion setFont:CONFFONTMEDIUMSIZE(15)];
    [self.questionTextView setFont:CONFFONTBOLDSIZE(18)];
    [self.bt_validationSelectedAnswers.titleLabel setFont:CONFFONTMEDIUMSIZE(17)];
    [self.bt_validationSelectedAnswers setTitleColor:CONFCOLORFORKEY(@"answers_selected_bt") forState:UIControlStateNormal];
}

-(void)setUpHeaderQuestion
{
    NSMutableAttributedString *attributedQuestion = [[NSMutableAttributedString alloc] initWithString:self.questionModel.question];

    [attributedQuestion addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(18), NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, self.questionModel.question.length)];

    [self.questionTextView setAttributedText:attributedQuestion];
    [self.lb_typeOfQuestion setText:[self.questionModel getStringQuestionType]];

}

-(void)setUpStats
{
    self.sponsorsAnswersButton.hidden = YES;
    [self setUpHeaderQuestion];
    [self.v_generalPoints setAlpha:0.0];

    [self.answersContainer clearSubview];
    [self.answersContainer setAlpha:0];
    [self.statsContainer clearSubview];
    [self.statsContainer setAlpha:1];

    self.answerPointsView.hidden = YES;

    self.statisticsView = [GCStatisticsView new];
    [self.statsContainer addSubview:self.statisticsView];

    [self.statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    self.progressView.hidden = YES;
    self.statisticsView.delegate = self;
    self.statisticsView.questionModel = self.questionModel;

    self.statisticsView.isAnswerBarsHidden = YES;
    [self.statisticsView performSelector:@selector(animateView) withObject:nil afterDelay:0.4];

    timeOfAppearance = [[NSDate date] timeIntervalSince1970];
}

-(void)setUpAnswers
{
    [self setUpHeaderQuestion];

    self.sponsorsAnswersButton.hidden = NO;

    [self.statsContainer clearSubview];
    [self.statsContainer setAlpha:0];
    [self.answersContainer clearSubview];
    [self.answersContainer setAlpha:1];

    [self.statisticsView removeFromSuperview];

    [self.bt_validationSelectedAnswers setTitle:NSLocalizedString(@"gc_validate", nil) forState:UIControlStateNormal];

    self.answersView = [GCAnswersView new];
    self.progressView.hidden = NO;
    self.answersView.delegate = self;
    [self.statsContainer clearSubview];
    [self.answersContainer addSubview:self.answersView];
    [self.answersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.answersView.questionModel = self.questionModel;

    timeOfAppearance = [[NSDate date] timeIntervalSince1970];
}

@end
