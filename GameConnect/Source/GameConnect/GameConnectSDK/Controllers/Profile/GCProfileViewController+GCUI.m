//
//  GCProfileViewController+GCUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 17/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProfileViewController+GCUI.h"
#import "Extends+Libs.h"

@implementation GCProfileViewController (GCUI)

-(void)initColors
{
    [self.cv_playedEvents setBackgroundColor:CONFCOLORFORKEY(@"profile_bg")];
    [self.cv_trophies setBackgroundColor:CONFCOLORFORKEY(@"profile_bg")];
    [self.v_containerSegmentedControl setBackgroundColor:CONFCOLORFORKEY(@"profile_bg")];
}

-(void)initSegmentedControl
{
    [self.sc_playedTrophies removeAllSegments];
    [self.sc_playedTrophies insertSegmentWithTitle:NSLocalizedString(@"gc_played", nil) atIndex:0 animated:NO];
    [self.sc_playedTrophies insertSegmentWithTitle:NSLocalizedString(@"gc_trophies", nil) atIndex:1 animated:NO];

    [self.sc_playedTrophies setTintColor:CONFCOLORFORKEY(@"tab_bg")];
    [self.sc_playedTrophies setTitleTextAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"tab_title_lb")} forState:UIControlStateSelected];
    [self.sc_playedTrophies setTitleTextAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"tab_title_lb")} forState:UIControlStateNormal];

    self.sc_playedTrophies.selectedSegmentIndex = 0;
    [self.cv_playedEvents setAlpha:1.0f];
    [self.cv_trophies setAlpha:0.0f];
}

-(void)setUpProfilerHeader
{
    self.profileHeader = [GCRankingHeaderLargeView instanceFromNib];
    self.profileHeader.delegate = self;
    [self.v_containerHeaderProfile addSubviewToBonce:self.profileHeader autoSizing:YES];
}

- (IBAction)changeValueSegmentedControl:(id)sender
{
    if (self.sc_playedTrophies.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.cv_playedEvents setAlpha:1.0f];
            [self.cv_trophies setAlpha:0.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (self.sc_playedTrophies.selectedSegmentIndex == 1)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.cv_playedEvents setAlpha:0.0f];
            [self.cv_trophies setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
