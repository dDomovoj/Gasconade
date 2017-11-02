//
//  GCAPPAnswersViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCAnswersViewController.h"

@interface GCAPPAnswersViewController : GCAPPMasterViewController
{
    GCAnswersViewController *answers;
}
@property (weak, nonatomic) IBOutlet UIView *v_containerAnswers;

@property (strong, nonatomic, readonly) GCQuestionModel *questionModelForAnswers;

-(void) updateNewQuestion:(GCQuestionModel *)questionModel;
-(void) updateStatsQuestion:(GCQuestionModel *)questionModel;
-(void) updateEndQuestion:(GCQuestionModel *)questionModel;

//-(BOOL) isUpdatingStats;

@end
