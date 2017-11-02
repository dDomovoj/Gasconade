//
//  GCAPPExternalAnswersViewController.h
//  TVA Sports Second Screen
//
//  Created by Guillaume on 05/08/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCQuestionModel.h"
#import "GCEventModel.h"

@interface GCAPPExternalAnswersViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, assign) CGFloat heightSeparator;

@property (copy, nonatomic) void(^showPanelWithCallBack)(GCAPPExternalAnswersViewController *, void(^completionBlock)());
@property (copy, nonatomic) void(^hidePanelWithCallBack)(GCAPPExternalAnswersViewController *, void(^completionBlock)());

@property (weak, nonatomic) IBOutlet UIView *v_header;
@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet UIButton *bt_closePanel;
@property (weak, nonatomic) IBOutlet UIScrollView *sv_stackOfQuestions;

-(void)insertNewQuestion:(GCQuestionModel *)questionModel;

-(void)insertResultQuestion:(GCQuestionModel *)questionModel;

-(void)insertCustomPopUpWithData:(id)data andBlockOnceSelected:(void(^)())completion;

-(void)removeQuestion:(GCQuestionModel *)questionModel;

-(void)removeQuestionsFromEvent:(GCEventModel *)eventQuestionToRemove;

-(NSUInteger)numberOfElementsInPanel;

-(CGFloat)getHeightOfScrollSubviews;

-(CGFloat)getHeightOfHeader;

@end
