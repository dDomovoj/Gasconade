//
//  GCProfileViewController+GCUI.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 17/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProfileViewController.h"

@interface GCProfileViewController (GCUI)

-(void)initColors;

-(void)initSegmentedControl;

-(void)setUpProfilerHeader;

- (IBAction)changeValueSegmentedControl:(id)sender;

@end
