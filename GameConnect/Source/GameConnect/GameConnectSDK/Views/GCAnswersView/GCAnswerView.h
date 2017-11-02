//
//  GCAnswerView
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWGCircleCounter.h"
#import "OBShapedButton.h"
#import "GCPointsView.h"
#import "GCQuestionModel.h"
#import "GCAnswerModel.h"

@protocol GCAnswerViewDelegate <NSObject>
@optional
-(void) GCDidSelectAnswer:(GCAnswerModel *)answerModel onQuestion:(GCQuestionModel *)questionModel fromAnswerView:(GCView *)answerView;
-(void) GCTimerDidEndOnQuestion:(GCQuestionModel *)questionModel fromAnswerView:(GCView *)answerView;
@end

@interface GCAnswerView : GCView

// Timer
@property (weak, nonatomic) IBOutlet UIView *v_centeredTimer;
@property (weak, nonatomic) IBOutlet UIImageView *iv_borderTimer;
@property (weak, nonatomic) IBOutlet UIView *v_centerBackgroundTimer;
@property (weak, nonatomic) IBOutlet UILabel *lb_timer;
@property (weak, nonatomic) IBOutlet JWGCircleCounter *progress;

// 2 answers
@property (weak, nonatomic) IBOutlet UIView *answer_two;
@property (weak, nonatomic) IBOutlet UIView *vw_central;

@property (weak, nonatomic) IBOutlet UIButton *bt_left;
@property (weak, nonatomic) IBOutlet UIButton *bt_right;

@property (weak, nonatomic) IBOutlet UILabel *lb_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_right;

@property (weak, nonatomic) IBOutlet UIView *points_left;
@property (weak, nonatomic) IBOutlet UIView *points_right;

@property (nonatomic, strong) GCPointsView *points_answer_left;
@property (nonatomic, strong) GCPointsView *points_answer_right;

// 3 answers
@property (weak, nonatomic) IBOutlet UIView *answer_three;
@property (weak, nonatomic) IBOutlet UIView *vw3_central;
@property (weak, nonatomic) IBOutlet OBShapedButton *bt3_top;
@property (weak, nonatomic) IBOutlet OBShapedButton *bt3_left;
@property (weak, nonatomic) IBOutlet OBShapedButton *bt3_right;

@property (weak, nonatomic) IBOutlet UILabel *lb3_top;
@property (weak, nonatomic) IBOutlet UILabel *lb3_left;
@property (weak, nonatomic) IBOutlet UILabel *lb3_right;

@property (weak, nonatomic) IBOutlet UIView *points3_left;
@property (weak, nonatomic) IBOutlet UIView *points3_right;
@property (weak, nonatomic) IBOutlet UIView *points3_top;

@property (nonatomic, strong) GCPointsView *points3_answer_left;
@property (nonatomic, strong) GCPointsView *points3_answer_right;
@property (nonatomic, strong) GCPointsView *points3_answer_top;

// 4 answers
@property (weak, nonatomic) IBOutlet UIView *answer_four;
@property (weak, nonatomic) IBOutlet UIView *vw4_central;

@property (weak, nonatomic) IBOutlet UIButton *bt4_leftbottom;
@property (weak, nonatomic) IBOutlet UIButton *bt4_lefttop;
@property (weak, nonatomic) IBOutlet UIButton *bt4_righttop;
@property (weak, nonatomic) IBOutlet UIButton *bt4_rightbottom;

@property (weak, nonatomic) IBOutlet UILabel *lb4_lefttop;
@property (weak, nonatomic) IBOutlet UILabel *lb4_righttop;
@property (weak, nonatomic) IBOutlet UILabel *lb4_rightbottom;
@property (weak, nonatomic) IBOutlet UILabel *lb4_leftbottom;

@property (weak, nonatomic) IBOutlet UIView *points4_lefttop;
@property (weak, nonatomic) IBOutlet UIView *points4_righttop;
@property (weak, nonatomic) IBOutlet UIView *points4_rightbottom;
@property (weak, nonatomic) IBOutlet UIView *points4_leftbottom;

@property (nonatomic, strong) GCPointsView *points4_answer_lefttop;
@property (nonatomic, strong) GCPointsView *points4_answer_righttop;
@property (nonatomic, strong) GCPointsView *points4_answer_rightbottom;
@property (nonatomic, strong) GCPointsView *points4_answer_leftbottom;

@property (weak, nonatomic) id<GCAnswerViewDelegate> delegate;

-(void) initWithQuestion:(GCQuestionModel *)question;
-(void) initTimer;
-(void) reset;
-(NSArray *) getSelectedQuestions;

@end
