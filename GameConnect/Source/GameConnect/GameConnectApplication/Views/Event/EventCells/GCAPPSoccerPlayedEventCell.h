//
//  GCFootballPlayedEventCell.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 09/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCAPPSoccerEventCell.h"


@interface GCAPPSoccerPlayedEventCell : GCAPPSoccerEventCell <IRenderGG, IGCExternalGameEvent>

@property (weak, nonatomic) IBOutlet UILabel *lb_rankingPosition;
@property (weak, nonatomic) IBOutlet UILabel *lb_rankingPositionSuffix;
@property (weak, nonatomic) IBOutlet UILabel *lb_points;
@property (weak, nonatomic) IBOutlet UILabel *lb_groupName;
@property (weak, nonatomic) IBOutlet UIView  *v_points;

@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet UIView *v_bottomBackground;

@end
