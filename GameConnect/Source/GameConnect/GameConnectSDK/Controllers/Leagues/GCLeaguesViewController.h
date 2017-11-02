//
//  GCLeaguesViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "UICollectionViewGG.h"
#import "GCLeagueModel.h"

@interface GCLeaguesViewController : GCConnectViewController <UICollectionViewGGDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_leagues;
@property (assign) BOOL leagueSelectionActive;

//-(NSArray *) getLeagues;
//-(GCLeagueModel *) getSelectedLeague;

//-(void) setLeagueSelectionActivated:(BOOL)leagueSelection andLeagueLoading:(BOOL)leagueLoading;

//-(void) unselectAllLeagues;
//-(void) unselectLeague:(GCLeagueModel *)selectedLeague;
//-(void) selectLeagueAtIndexPath:(NSIndexPath *)indexPath;
//-(void) selectLeague:(GCLeagueModel *)selectedLeague;
//-(void) preselectLeagueAtIndexPath:(NSIndexPath *)indexPath;

@end
