//
//  GCTimeCountdownView.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCTimeCountdownView.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCTimeCountdownView()
{
    UIImage *imageClockTemplate;
}
@end

@implementation GCTimeCountdownView

-(CGRect) updateCountDownAndReturnFrame:(NSTimeInterval)secondsRemaining
{
    [self.lb_countdown setFont:CONFFONTREGULARSIZE(14)],
    [self.lb_countdown setTexteRecadre:[GCConfManager getFormatedStringForRemainingSeconds:secondsRemaining] height:self.lb_countdown.frame.size.height];

    imageClockTemplate = [[UIImage imageNamed:@"GCBundleRessources.bundle/Game/clock_pending_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (secondsRemaining <= 15.0f)
    {
        [self.lb_countdown setTextColor:CONFCOLORFORKEY(@"question_clock_late_countdown_tint")];
        [self.iv_clock setImage:imageClockTemplate];
        [self.iv_clock setTintColor:CONFCOLORFORKEY(@"question_clock_late_countdown_tint")];
    }
    else
    {
        [self.lb_countdown setTextColor:CONFCOLORFORKEY(@"question_clock_early_countdown_tint")];
        [self.iv_clock setImage:imageClockTemplate];
        [self.iv_clock setTintColor:CONFCOLORFORKEY(@"question_clock_early_countdown_tint")];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.lb_countdown.frame.origin.x + self.lb_countdown.frame.size.width, self.frame.size.height);
    return self.frame;
}

@end
