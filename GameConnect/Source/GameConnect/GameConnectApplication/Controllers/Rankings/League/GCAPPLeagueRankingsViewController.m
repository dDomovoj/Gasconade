//
//  GCAPPLeagueRankingsViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLeagueRankingsViewController.h"
#import "Extends+Libs.h"
#import "GCProcessLeagueManager.h"
#import "GCAPPLeagueRankingsViewController+GCAPPUI.h"
#import "GCLeagueManager.h"
//#import "GCLoggerManager.h"
#import "GCGamerManager.h"

@interface GCAPPLeagueRankingsViewController ()
@end

@implementation GCAPPLeagueRankingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"gc_league_rankings", nil);
    isLeagueOwner = [self.leagueModel.gamer._id isEqualToString:[GCGamerManager getInstance].gamer._id];
    
    [self setUpLeagueRanking];
    [self setUpNavbarButton];
}

-(void)setUpLeagueRanking
{
    rankingsLeague = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCRankingsVCIdentifier];
    
    rankingsLeague.firstTabRanking = eRankingLeagueOverall;
    rankingsLeague.secondTabRanking = eRankingLeagueLastMatch;
    rankingsLeague.leagueModel = self.leagueModel;

    [self.v_containerLeagueRanking addSubviewToBonce:rankingsLeague.view autoSizing:YES];
    [self addChildViewController:rankingsLeague];

    // Remove it to make the segmented control appearing
    [rankingsLeague.sc_overallLeague setAlpha:0];
    [rankingsLeague.cv_overallRanking setFrame:CGRectMake(0, 0, rankingsLeague.cv_overallRanking.frame.size.width, self.v_containerLeagueRanking.frame.size.height)];
    //

    [rankingsLeague.cv_overallRanking setDynamicFlowLayoutEnable:NO];
    [rankingsLeague.cv_secondaryRanking setDynamicFlowLayoutEnable:NO];
}

-(void)deleteLeague
{
    if (self.leagueModel)
    {
        [GCLeagueManager deleteLeague:self.leagueModel._id cb_response:^(BOOL success)
         {
             if (success)
             {
                 [self setFlashMessage:NSLocalizedString(@"gc_msg_sucess_league_deletion", nil)];
                 [[GCProcessLeagueManager sharedManager] leagueDeleted:self.leagueModel fromViewController:self];
             }
         }];
    }
}

-(void)quitLeague
{
    if (self.leagueModel)
    {
        //TODO: Quit League
        [self setFlashMessage:NSLocalizedString(@"gc_msg_sucess_league_quit", nil)];
        [[GCProcessLeagueManager sharedManager] leagueQuit:self.leagueModel fromViewController:self];
    }
    else
        //GCLog(@"Selected league doesn't exist");
}

-(void)goToLeagueEdition
{
    [[GCProcessLeagueManager sharedManager] requestLeagueEdition:self.leagueModel fromViewController:self];
}

-(void)goToLeagueInvitation
{
    [[GCProcessLeagueManager sharedManager] requestLeagueInvitation:self.leagueModel fromViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
