//
//  GCAPPLeaguesViewControlleriPad.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLeaguesViewController.h"
#import "GCRankingsViewController.h"

@interface GCAPPLeaguesViewControlleriPad : GCAPPLeaguesViewController
{
    BOOL isLeagueOwner;
}
@property (strong, nonatomic, readonly) GCRankingsViewController *rankingsLeague;
@property (weak, nonatomic) IBOutlet UIImageView *iv_brandLogo;

@property (weak, nonatomic) IBOutlet UILabel *lb_headerLeaguesList;
@property (weak, nonatomic) IBOutlet UILabel *lb_headerRanking;

@property (weak, nonatomic) IBOutlet UIButton *bt_leagueDeletion;
@property (weak, nonatomic) IBOutlet UIButton *bt_leagueEdition;
@property (weak, nonatomic) IBOutlet UIButton *bt_leagueInvitation;
@property (weak, nonatomic) IBOutlet UIButton *bt_leagueAddition;
@property (weak, nonatomic) IBOutlet UIButton *bt_quit;

@property (weak, nonatomic) IBOutlet UIView *v_headerLeagueList;
@property (weak, nonatomic) IBOutlet UIView *v_containerLeagueControls;
@property (weak, nonatomic) IBOutlet UIView *v_containerLeagueRanking;
@property (weak, nonatomic) IBOutlet UIView *v_headerRanking;

-(void)setSelectedLeague:(GCLeagueModel *)leagueModel;

@end
