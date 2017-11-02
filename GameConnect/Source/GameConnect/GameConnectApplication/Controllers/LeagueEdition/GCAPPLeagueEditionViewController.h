//
//  GCAPPLeagueEdition.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCLeagueEditionViewController.h"
#import "GCLeagueModel.h"

@interface GCAPPLeagueEditionViewController : GCAPPMasterViewController
{
    GCLeagueEditionViewController *leagueEdition;
}
@property (weak, nonatomic) IBOutlet UIImageView *iv_brandLogo;
@property (weak, nonatomic) IBOutlet UIView *v_containerLeagueEdition;

@property (weak, nonatomic) GCLeagueModel *leagueToEdit;

-(void) goToLeagueCreation;
-(void) goToLeagueNameModification;
-(void) goToLeagueInvitation;

@end
