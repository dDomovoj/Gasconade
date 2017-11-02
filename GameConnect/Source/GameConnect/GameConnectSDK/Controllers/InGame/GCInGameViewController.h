//
//  GCInGameViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "UICollectionViewGG.h"
#import "GCEventModel.h"
#import "GCQuestionModel.h"

@interface GCInGameViewController : GCConnectViewController <UICollectionViewGGDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sc_questionsResults;
@property (weak, nonatomic) IBOutlet UIView *v_containerSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_questionsGame;
@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_resultsGame;

@property (copy, nonatomic) void(^callBackQuestionSelected)(GCQuestionModel *question);

@property (strong, nonatomic) NSArray *preloadedQuestions;
@property (strong, nonatomic) GCEventModel *eventModel;

-(void)updateNewQuestion:(GCQuestionModel *)question;
-(void)updateEndQuestion:(GCQuestionModel *)question;

@end
