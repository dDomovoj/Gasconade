//
//  NSShareMenuConfiguration.m
//  RenderSharingKit
//
//  Created by Céline Cheung on 06/01/13.
//  Copyright (c) 2013 Céline Cheung. All rights reserved.
//

#import "NSShareMenuConfiguration.h"

@implementation NSShareMenuConfiguration

- (id) init
{
    self = [super init];
    if (self)
    {
        self.nearRadius = 90.0f;
        self.endRadius = 90.0f;
        self.farRadius = 90.0f;
        self.rotateAngle = -M_PI / 2;
        self.menuWholeAngle = M_PI;
        self.expandStartScale = 0.5f;
        self.expandEndScale = 1.0f;
        self.closeStartScale = 1.0f;
        self.closeEndScale = 0.0f;
        self.animationDuration = 0.75;
    }
    return self;
}

@end
