//
//  GCAnswersViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "GCQuestionModel.h"
#import "GCAnswerView.h"
#import "GCStatsView.h"

@class GCStatisticsView;
@class GCAnswersView;
@class QuestionProgressView;
@class GCAnswerPointsView;

@interface GCAnswersViewController : GCConnectViewController <GCAnswerViewDelegate>
{
}
// AnswerViewController Inside the Game Connect Universe

@property (nonatomic) GCStatisticsView *statisticsView;
@property (nonatomic) GCAnswersView *answersView;
@property (nonatomic) QuestionProgressView *progressView;
@property (nonatomic) GCAnswerPointsView *answerPointsView;
@property (nonatomic) UIButton *sponsorsAnswersButton;
@property (nonatomic) UIView *statsContainer;
@property (nonatomic) UIView *answersContainer;
@property (nonatomic) UITextView *questionTextView;

@property (weak, nonatomic) IBOutlet UIView *v_backgroundTypeOfQuestion;
@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet UIView *v_generalPoints;
//@property (weak, nonatomic) IBOutlet UIView *v_containerAnswer;
//@property (weak, nonatomic) IBOutlet UIView *v_containerStats;
@property (weak, nonatomic) IBOutlet UILabel *lb_typeOfQuestion;
@property (weak, nonatomic) IBOutlet UIButton *bt_validationSelectedAnswers;
@property (weak, nonatomic) IBOutlet UIButton *bt_sharing;

// AnswerViewController Outside the Game Connect Universe
@property (weak, nonatomic) IBOutlet UIButton *bt_closeQuestion;

@property (copy, nonatomic) void(^callBackClosingViewController)(void);

@property (strong, nonatomic, readonly) GCQuestionModel *questionModel;

-(void) updateQuestion:(GCQuestionModel *)questionModel;
-(void) updateNewQuestion:(GCQuestionModel *)questionModel;
-(void) updateStatsQuestion:(GCQuestionModel *)questionModel;
-(void) updateEndQuestion:(GCQuestionModel *)questionModel;

@end
