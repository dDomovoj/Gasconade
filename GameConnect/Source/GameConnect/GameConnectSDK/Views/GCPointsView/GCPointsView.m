//
//  GCPointsView.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCPointsView.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCPointsView()
{
    eGCPointsType currentPointsType;
}
@end

@implementation GCPointsView

-(void)myInit
{
    currentPointsType = eGCPointsQuestionRightAnswer;
    [self.lb_points setFont:CONFFONTBOLDSIZE(13)];
    [self.lb_points setTextColor:CONFCOLORFORKEY(@"points_lb")];
    self.v_backgrounds.layer.cornerRadius = 4.0f;

    if (GCPICTOPOINTSENABLED == NO)
        [self removePictoPoints];
}

-(void)removePictoPoints
{
    self.v_backgrounds.frame = CGRectMake(0,
                                      0,
                                      self.frame.size.width,
                                      self.frame.size.height);
    
    self.lb_points.frame = CGRectMake(self.lb_points.frame.origin.x,
                                      self.lb_points.frame.origin.y,
                                      self.frame.size.width - 4,
                                      self.frame.size.height);
    [self.iv_pictoPoints setHidden:YES];
}

-(void) updateWithInteger:(NSUInteger)points
{
    [self updateWithInteger:points andPointsType:currentPointsType];
}

-(void) updateWithInteger:(NSUInteger)points andPointsType:(eGCPointsType)pointsType
{
    NSString *strAdd = @"";
    
    if (pointsType == eGCPointsQuestionAnswered)
    {
        [self.v_backgrounds setBackgroundColor:CONFCOLORFORKEY(@"points_won_bg")];
    }
    else if (pointsType == eGCPointsQuestionRightAnswer)
    {
        strAdd = @"+";
        [self.v_backgrounds setBackgroundColor:CONFCOLORFORKEY(@"points_won_bg")];
    }
    else if (pointsType == eGCPointsQuestionWrongAnswer)
    {
        [self.v_backgrounds setBackgroundColor:CONFCOLORFORKEY(@"points_lost_bg")];
    }
    else if (pointsType == eGCPointsQuestionMissed)
    {
        [self.v_backgrounds setBackgroundColor:CONFCOLORFORKEY(@"points_lost_bg")];
    }
    
    [self.lb_points setText:SWF(@"%@%ld", strAdd, (unsigned long)points)];
}

@end
