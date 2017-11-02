//
//  GCQuestionRender.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPointsView.h"
#import "GCTimeCountdownView.h"
#import "GCMasterCollectionViewCell.h"

@interface GCQuestionRender : GCMasterCollectionViewCell
{
    GCPointsView *points;
    GCTimeCountdownView *clock;
}
@property (weak, nonatomic) IBOutlet UIImageView *iv_questionResultStatus;
@property (weak, nonatomic) IBOutlet UILabel *lb_question;
@property (weak, nonatomic) IBOutlet UILabel *lb_statusAnswer;
@property (weak, nonatomic) IBOutlet UIView *v_points;
@property (weak, nonatomic) IBOutlet UIView *v_countdown;

@property (nonatomic) CGRect savedOriginalFrameQuestion;

@end
