//
//  GCAPPLeaguesViewControlleriPad.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPLeaguesViewControlleriPad+GCAPPUI.h"
#import "GCAPPLeaguesViewControlleriPad.h"
#import "GCProcessLeagueManager.h"
#import "GCBluredImageSingleton.h"
#import "GCLeagueManager.h"
#import "GCGamerManager.h"
//#import "GCLoggerManager.h"

@interface GCAPPLeaguesViewControlleriPad ()
{
    GCLeagueModel *selectedLeagueModel;
}
- (IBAction)clickOnAddLeague:(id)sender;
- (IBAction)clickOnAddPeople:(id)sender;
- (IBAction)clickOnEdition:(id)sender;
- (IBAction)clickOnDelete:(id)sender;
- (IBAction)clickOnQuit:(id)sender;
@end

@implementation GCAPPLeaguesViewControlleriPad

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
    isLeagueOwner = NO;
    leagues.leagueSelectionActive = YES;
    
    [self setUpLeagueRanking];
    [self setUpLeagueViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkLeagueAvailability];
}

-(void)checkLeagueAvailability
{
    [self.bt_quit setEnabled:selectedLeagueModel ? YES : NO];
    [self.bt_leagueDeletion setEnabled:selectedLeagueModel ? YES : NO];
    [self.bt_leagueEdition setEnabled:selectedLeagueModel ? YES : NO];
    [self.bt_leagueInvitation setEnabled:selectedLeagueModel ? YES : NO];
}

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

-(void)setUpLeagueRanking
{
    _rankingsLeague = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCRankingsVCIdentifier];
    
    _rankingsLeague.firstTabRanking = eRankingLeagueOverall;
    _rankingsLeague.secondTabRanking = eRankingLeagueLastMatch;

    [self.v_containerLeagueRanking addSubviewToBonce:_rankingsLeague.view autoSizing:YES];
    [self addChildViewController:_rankingsLeague];

    // Remove it to make the segmented control appearing
    [_rankingsLeague.sc_overallLeague setAlpha:0];
    [_rankingsLeague.cv_overallRanking setFrame:CGRectMake(0, 0, _rankingsLeague.cv_overallRanking.frame.size.width, self.v_containerLeagueRanking.frame.size.height)];
    //

    [_rankingsLeague.cv_overallRanking setDynamicFlowLayoutEnable:YES];
    [_rankingsLeague.cv_secondaryRanking setDynamicFlowLayoutEnable:YES];
}

-(void)setSelectedLeague:(GCLeagueModel *)leagueModel
{
    selectedLeagueModel = leagueModel;
    [self checkLeagueAvailability];
    
    if (leagueModel.gamer && leagueModel.gamer._id && [leagueModel.gamer._id isEqualToString:[GCGamerManager getInstance].gamer._id])
    {
        isLeagueOwner = YES;
        [self.bt_leagueInvitation setAlpha:1];
        [self.bt_leagueEdition setAlpha:1];
        [self.bt_leagueDeletion setAlpha:1];
    }
    else
    {
        isLeagueOwner = NO;
        [self.bt_leagueInvitation setAlpha:0];
        [self.bt_leagueEdition setAlpha:0];
        [self.bt_leagueDeletion setAlpha:0];
    }
    if (self.rankingsLeague)
    {
        [self.rankingsLeague loadRankingForLeague:leagueModel usingCallBack:^(NSArray *rankings) {
        }];
    }
}

#pragma User - Interactions
- (IBAction)clickOnAddPeople:(id)sender
{
    if (!selectedLeagueModel)
    {
        DLog(@"Selected league doesn't exist");
        return ;
    }
    [[GCProcessLeagueManager sharedManager] requestLeagueInvitation:selectedLeagueModel fromViewController:self];
}

- (IBAction)clickOnEdition:(id)sender
{
    if (!selectedLeagueModel)
    {
        DLog(@"Selected league doesn't exist");
        return ;
    }
    [[GCProcessLeagueManager sharedManager] requestLeagueEdition:selectedLeagueModel fromViewController:self];
}

- (IBAction)clickOnDelete:(id)sender
{
    if (isLeagueOwner)
    {
        // DELETE
        UIAlertView *alertConfirmDeletion = [[UIAlertView alloc] initWithTitle:nil
                                                                       message:NSLocalizedString(@"gc_confirm_delete_league", nil)
                                                                      delegate:self
                                                             cancelButtonTitle:NSLocalizedString(@"gc_popup_no", nil) otherButtonTitles:NSLocalizedString(@"gc_popup_yes", nil), nil];
        alertConfirmDeletion.tag = 4242;
        [alertConfirmDeletion show];
    }
    else
        //GCLog(@"You are not the owner, you cannot delete it!");
}

- (IBAction)clickOnQuit:(id)sender
{
    if (!isLeagueOwner)
    {
        // Quit
        UIAlertView *alertConfirmQuitting = [[UIAlertView alloc] initWithTitle:nil
                                                                       message:NSLocalizedString(@"gc_confirm_quit_league", nil)
                                                                      delegate:self
                                                             cancelButtonTitle:NSLocalizedString(@"gc_popup_no", nil)otherButtonTitles:NSLocalizedString(@"gc_popup_yes", nil), nil];
        alertConfirmQuitting.tag = 2323;
        [alertConfirmQuitting show];
    }
    [self setFlashMessage:NSLocalizedString(@"gc_msg_sucess_league_quit", nil)];
    [[GCProcessLeagueManager  sharedManager] leagueQuit:selectedLeagueModel fromViewController:self];
}

- (IBAction)clickOnAddLeague:(id)sender
{
    [[GCProcessLeagueManager sharedManager] requestLeagueEdition:nil fromViewController:self];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == 4242) // Delete
            [self deleteLeague];
        else if (alertView.tag == 2323) // Quit
            [self quitLeague];
    }
}

-(void)deleteLeague
{
    if (selectedLeagueModel)
    {
        __block GCAPPLeaguesViewControlleriPad *weak_self = self;
        [GCLeagueManager deleteLeague:selectedLeagueModel._id cb_response:^(BOOL success)
         {
             if (success)
             {
                 [self setFlashMessage:NSLocalizedString(@"gc_msg_sucess_league_deletion", nil)];
                 [[GCProcessLeagueManager sharedManager] leagueDeleted:self->selectedLeagueModel fromViewController:weak_self];
                 [self->leagues loadData];
                 [self.rankingsLeague loadRankingForLeague:nil usingCallBack:nil];
             }
         }];
    }
    else
        //GCLog(@"Selected league doesn't exist");
}

-(void)quitLeague
{
    if (selectedLeagueModel)
    {
        //TODO: Quit League
        [self setFlashMessage:NSLocalizedString(@"gc_msg_sucess_league_quit", nil)];
        [[GCProcessLeagueManager  sharedManager] leagueQuit:selectedLeagueModel fromViewController:self];
    }
    else
        //GCLog(@"Selected league doesn't exist");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
