//
//  GCRankingsViewController+GCUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 11/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCRankingsViewController+GCUI.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCRankingsViewController (GCUI)

-(void)setLeaguesView
{
    [self showLeagueSelectionHeader];
    
    // Colors
    [self.v_containerSelectionLeague setBackgroundColor:CONFCOLORFORKEY(@"league_selection_bg")];
    [self.lb_selectedLeagueName setTextColor:CONFCOLORFORKEY(@"league_name_lb")];
    [self.lb_selectedLeagueMembers setTextColor:CONFCOLORFORKEY(@"league_members_lb")];

    // Fonts
    [self.lb_selectedLeagueName setFont:CONFFONTSIZE(15)];
    [self.lb_selectedLeagueMembers setFont:CONFFONTITALICSIZE(13)];
    
    // SetFrame of cv_leaguesSelection since it's autosizing is not set.
    // Animation on frame.size.height of UICollectionVie make cells dispear unexpectedly.
    [self.cv_leaguesSelection setFrame:CGRectMake(self.cv_leaguesSelection.frame.origin.x, self.cv_leaguesSelection.frame.origin.y, self.cv_leaguesSelection.frame.size.width, self.v_containerLeagueRanking.frame.size.height - self.v_containerSelectionLeague.frame.size.height)];
}

-(void)setLastMatchView
{
    [self hideLeagueSelectionHeader];
}

-(void)initSegmentedControl
{
    [self.sc_overallLeague removeAllSegments];
    
    // Second Tab
    if (self.secondTabRanking == eRankingLeagueLastMatch)
    {
        [self.sc_overallLeague insertSegmentWithTitle:NSLocalizedString(@"gc_lastmatch_tab", nil) atIndex:1 animated:NO];
        [self setLastMatchView];
    }
    else if (self.secondTabRanking == eRankingMyLeagues)
    {
        [self.sc_overallLeague insertSegmentWithTitle:NSLocalizedString(@"gc_myleagues_tab", nil) atIndex:1 animated:NO];
        [self setLeaguesView];
    }
    
    // FirstTAB
    if (self.firstTabRanking == eRankingLeagueOverall)
    {
        [self.sc_overallLeague insertSegmentWithTitle:NSLocalizedString(@"gc_league_overall_tab", nil) atIndex:0 animated:NO];
    }
    else if (self.firstTabRanking == eRankingoverall)
    {
        [self.sc_overallLeague insertSegmentWithTitle:NSLocalizedString(@"gc_overall_tab", nil) atIndex:0 animated:NO];
    }
    
    [self.sc_overallLeague setSelectedSegmentIndex:0];
    [self changeSelectedTabInSegmentedControl];
    
    [self.sc_overallLeague setTintColor:CONFCOLORFORKEY(@"tab_bg")];
    [self.sc_overallLeague setTitleTextAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"tab_title_lb")} forState:UIControlStateSelected];
    [self.sc_overallLeague setTitleTextAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"tab_title_lb")} forState:UIControlStateNormal];
}

-(void)changeSelectedTabInSegmentedControl
{
    if (self.sc_overallLeague.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.cv_overallRanking setAlpha:1.0f];
            [self.v_containerLeagueRanking setAlpha:0.0f];
        } completion:^(BOOL finished) {
        }];
    }
    else if (self.sc_overallLeague.selectedSegmentIndex == 1)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.cv_overallRanking setAlpha:0.0f];
            [self.v_containerLeagueRanking setAlpha:1.0f];
        } completion:^(BOOL finished) {
        }];
     }
}

-(void)hideLeagueSelectionHeader
{
    if (self.v_containerSelectionLeague.frame.size.height > 0)
    {
        [self.v_containerSelectionLeague setFrame:CGRectMake(self.v_containerSelectionLeague.frame.origin.x,
                                                         self.v_containerSelectionLeague.frame.origin.y,
                                                         self.v_containerSelectionLeague.frame.size.width,
                                                         0)];
        [self.cv_secondaryRanking setFrame:CGRectMake(0, 0, self.cv_secondaryRanking.frame.size.width, self.v_containerLeagueRanking.frame.size.height)];
    }
}

-(void)showLeagueSelectionHeader
{
    if (self.v_containerSelectionLeague.frame.size.height == 0)
    {
        [self.v_containerSelectionLeague setFrame:CGRectMake(self.v_containerSelectionLeague.frame.origin.x,
                                                             self.v_containerSelectionLeague.frame.origin.y,
                                                             self.v_containerSelectionLeague.frame.size.width,
                                                             45)];
        
        [self.cv_secondaryRanking setFrame:CGRectMake(0,
                                                      self.v_containerSelectionLeague.frame.size.height,
                                                      self.cv_secondaryRanking.frame.size.width,
                                                      self.v_containerLeagueRanking.frame.size.height - self.v_containerSelectionLeague.frame.size.height)];
    }
}

#pragma Up and Down motion of the League Selection List
-(void)showLeagueSelectionListWithAnimation
{
    CGFloat finalHeightForLeagueSelection = self.v_containerSelectionLeague.frame.size.height + self.cv_secondaryRanking.frame.size.height;

    [UIView animateWithDuration:0.4 animations:^{

        // League Selection frame growing
        [self.v_containerSelectionLeague setFrame:CGRectMake(self.v_containerSelectionLeague.frame.origin.x, self.v_containerSelectionLeague.frame.origin.y, self.v_containerSelectionLeague.frame.size.width, finalHeightForLeagueSelection)];

        // Ranking secondary tab frame reduction
        [self.cv_secondaryRanking setFrame:CGRectMake(self.cv_secondaryRanking.frame.origin.x, self.cv_secondaryRanking.frame.origin.y + self.cv_secondaryRanking.frame.size.height, self.cv_secondaryRanking.frame.size.width, self.cv_secondaryRanking.frame.size.height)];

    } completion:^(BOOL finished) {
        // Highlight of header 'Select your league'
    }];
}

-(void)hideLeagueSelectionListWithAnimation
{
    [UIView animateWithDuration:0.4 animations:^{

        [self.v_containerSelectionLeague setFrame:CGRectMake(self.v_containerSelectionLeague.frame.origin.x,
                                                             self.v_containerSelectionLeague.frame.origin.y,
                                                             self.v_containerSelectionLeague.frame.size.width,
                                                             45)];
        
        [self.cv_secondaryRanking setFrame:CGRectMake(self.cv_secondaryRanking.frame.origin.x,
                                                      45,
                                                      self.cv_secondaryRanking.frame.size.width,
                                                      self.v_containerLeagueRanking.frame.size.height - 45)];

    } completion:^(BOOL finished) {
        
    }];
}

-(void) openLeagueSelection
{
    [UIView animateWithDuration:0.2 animations:^{
        self.iv_arrowSelection.transform = CGAffineTransformMakeRotation(M_PI/2);
    }];
    [self showLeagueSelectionListWithAnimation];
}

-(void) closeLeagueSelection
{
    [UIView animateWithDuration:0.2 animations:^{
        self.iv_arrowSelection.transform = CGAffineTransformMakeRotation(2*M_PI);
    }];
    [self hideLeagueSelectionListWithAnimation];
}

@end

