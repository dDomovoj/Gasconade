//
//  GCAPPHomeViewControlleriPadViewController.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 28/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+libs.h"
#import "GCAPPHomeViewControlleriPad.h"
#import "GCRankingsViewController.h"
#import "GCBluredImageSingleton.h"
#import "GCProcessLeagueManager.h"
#import "GCProcessRankingManager.h"
#import "GCAPPSoccerEventCell.h"
#import "GCProcessPushManager.h"
#import "GCCompetitionManager.h"
#import "GCAPPMatchManager.h"
#import "GCAPPNavigationManager.h"
#import "GCConfManager.h"

@interface GCAPPHomeViewControlleriPad ()
{
    GCRankingsViewController *rankings;
}
- (IBAction)clickOnMyLeagues:(id)sender;
- (IBAction)clickOnRankings:(id)sender;
@end

@implementation GCAPPHomeViewControlleriPad

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
    [self setUpButtons];
}

#pragma UI
-(void)setUpButtons
{
    [self.bt_leagues setTitle:[NSLocalizedString(@"gc_my_leagues", nil) uppercaseString] forState:UIControlStateNormal];
    [self.bt_rankings setTitle:[NSLocalizedString(@"gc_rankings", nil) uppercaseString] forState:UIControlStateNormal];
    
    [self.bt_leagues setTitleColor:GCAPPColorButtonLB forState:UIControlStateNormal];
    [self.bt_rankings setTitleColor:GCAPPColorButtonLB forState:UIControlStateNormal];
    
    [self.bt_leagues setBackgroundColor:GCAPPColorButtonBG];
    [self.bt_rankings setBackgroundColor:GCAPPColorButtonBG];
    
    [self.bt_leagues.titleLabel setFont:CONFFONTMEDIUMSIZE(14)];
    [self.bt_rankings.titleLabel setFont:CONFFONTMEDIUMSIZE(14)];
}

-(void)setUpEventsList
{
    events = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCEventsVCIdentifier];
    events.competitionModel = [GCCompetitionManager getInstance].competitionDefault;
    [self.v_containerEvents addSubviewToBonce:events.view autoSizing:YES];
    [self addChildViewController:events];
    
    [events initEventsListWithSpecificRender:[GCAPPSoccerEventCell class]];

    [events.cv_events setDynamicFlowLayoutEnable:NO];
    [events.cv_events setMinimumLineSpacing:20];

    [super bindExternalGameForEvents];
}


#pragma Notifications CallBack for Blured Image
-(void)notificationImageBlured:(NSNotification *)notification
{
//    NSString *keyWantedHere = GCAPPBluredBackground2Columns;
//    
//    if (notification.userInfo && [[notification.userInfo getXpathEmptyString:@"key"] isEqualToString:keyWantedHere])
//        [self setBackgroundImage:[[GCBluredImageSingleton getInstance] getMyBluredImageUsingKey:keyWantedHere]];
}

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

#pragma User - Interactions
- (IBAction)clickOnMyLeagues:(id)sender
{
    [[GCProcessLeagueManager sharedManager] requestLeaguesFromViewController:self];
}

- (IBAction)clickOnRankings:(id)sender
{
    [[GCProcessRankingManager sharedManager] requestRankingsFromViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
