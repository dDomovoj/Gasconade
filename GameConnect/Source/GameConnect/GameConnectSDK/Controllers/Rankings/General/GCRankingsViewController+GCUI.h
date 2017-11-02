//
//  GCRankingsViewController+GCUI.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 11/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCRankingsViewController.h"

@interface GCRankingsViewController (GCUI)

-(void) initSegmentedControl;

-(void) showLeagueSelectionHeader;
-(void) hideLeagueSelectionHeader;

-(void) changeSelectedTabInSegmentedControl;
-(void) openLeagueSelection;
-(void) closeLeagueSelection;

-(void)setLeaguesView;

@end
