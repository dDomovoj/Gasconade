//
//  GCProfileHeader.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GCRankingHeaderLargeView.h"
#import "GCGamerModel.h"

@implementation GCRankingHeaderLargeView

-(void)initFontsAndColors
{
    [super initFontsAndColors];
    
    [self.v_points setBackgroundColor:[UIColor clearColor]];
}

@end
