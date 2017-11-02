//
//  GCAPPLeagueRankingsViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCRankingsViewController.h"
#import "GCLeagueModel.h"

@interface GCAPPLeagueRankingsViewController : GCAPPMasterViewController <UIActionSheetDelegate, UIAlertViewDelegate>
{
    GCRankingsViewController *rankingsLeague;
    BOOL isLeagueOwner;
}
@property (weak, nonatomic) IBOutlet UIView *v_containerLeagueRanking;

@property (strong, nonatomic) GCLeagueModel *leagueModel;

-(void) deleteLeague;
-(void) quitLeague;

-(void) goToLeagueEdition;
-(void) goToLeagueInvitation;

@end
