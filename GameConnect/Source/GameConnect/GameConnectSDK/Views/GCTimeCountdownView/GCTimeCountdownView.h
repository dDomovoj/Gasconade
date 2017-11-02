//
//  GCTimeCountdownView.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCView.h"

@interface GCTimeCountdownView : GCView

@property (weak, nonatomic) IBOutlet UIImageView *iv_clock;
@property (weak, nonatomic) IBOutlet UILabel *lb_countdown;

-(CGRect) updateCountDownAndReturnFrame:(NSTimeInterval)secondsRemaining;

@end
