//
//  GCPointsView.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCView.h"

typedef enum
{
    eGCPointsQuestionAnswered,
    eGCPointsQuestionRightAnswer,
    eGCPointsQuestionWrongAnswer,
    eGCPointsQuestionMissed,
} eGCPointsType;

@interface GCPointsView : GCView

@property (weak, nonatomic) IBOutlet UIView *v_backgrounds;
@property (weak, nonatomic) IBOutlet UILabel *lb_points;
@property (weak, nonatomic) IBOutlet UIImageView *iv_pictoPoints;

-(void) updateWithInteger:(NSUInteger)points;
-(void) updateWithInteger:(NSUInteger)points andPointsType:(eGCPointsType)pointsType;
-(void) removePictoPoints;

@end
