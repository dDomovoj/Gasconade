//
//  GCAPPGameViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCInGameViewController.h"
#import "GCRankingsEventViewController.h"
#import "GCEventModel.h"
#import "GCAPPSoccerEventHeader.h"

@interface GCAPPGameViewController : GCAPPMasterViewController
{
    GCAPPSoccerEventHeader *eventHeader;
    
    GCInGameViewController *gameLists;
    GCRankingsEventViewController *rankingsEvent;
}

@property (weak, nonatomic) IBOutlet UIImageView *iv_brandLogo;
@property (weak, nonatomic) IBOutlet UIView *v_containerEvent;
@property (weak, nonatomic) IBOutlet UIView *v_containerQuestions;
@property (weak, nonatomic) IBOutlet UIView *v_containerRanking;

@property (strong, nonatomic) GCEventModel *eventModel;

-(void)updateMyRanking:(GCRankingModel *)myRanking;
-(void)updateNewQuestion:(GCQuestionModel *)question;
-(void)updateEndQuestion:(GCQuestionModel *)question;

-(void)updateEndEvent:(GCEventModel *)event;

- (CGFloat)navigationBarOffset;

@end
