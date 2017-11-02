//
//  GCHomeViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/26/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPHomeViewControlleriPhone.h"
#import "GCAPPHomeViewControlleriPhone+GCAPPUI.h"
#import "GCAPPHomeViewControlleriPhone_Private.h"
#import "GCBluredImageSingleton.h"
#import "GCAPPSoccerEventCell.h"
#import "GCAPPEventLinker.h"
#import "GCCompetitionManager.h"
#import <Masonry/Masonry.h>

@interface GCAPPHomeViewControlleriPhone()

@property (nonatomic) BOOL didSetupDynamics;

@end

@implementation GCAPPHomeViewControlleriPhone

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
	
    self.iv_arrowRankingDragging = [UIImageView new];

    [self.v_containerProfile addSubview:self.iv_arrowRankingDragging];
    [self.iv_arrowRankingDragging mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(5));
    }];

    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.v_containerProfile addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@1);
    }];

    self.v_panGesture = [UIView new];
    [self.view addSubview:self.v_panGesture];
    self.v_panGesture.frame = self.v_containerProfile.frame;

    self.didSetupDynamics = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.didSetupDynamics) {
        self.didSetupDynamics = YES;

        [self updateProfileLayout];
        [self setUpDynamicsForProfileView];
        [self.view bringSubviewToFront:self.v_containerProfile];
        [self.view bringSubviewToFront:self.v_panGesture];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.v_panGesture setFrame:CGRectMake(self.v_containerProfile.frame.origin.x, self.v_containerProfile.frame.origin.y, self.v_containerProfile.frame.size.width, self.v_panGesture.frame.size.height)];
}

- (void)updateProfileLayout
{
    CGSize sizeProfile = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.v_containerEvents.frame.origin.y - 64);
    [self.v_containerProfile setFrame:CGRectMake(self.v_containerProfile.frame.origin.x, self.view.frame.size.height - 100, sizeProfile.width, sizeProfile.height)];
    [self.v_panGesture setFrame:CGRectMake(self.v_containerProfile.frame.origin.x, self.v_containerProfile.frame.origin.y, self.v_containerProfile.frame.size.width, self.v_panGesture.frame.size.height)];
    [profile.cv_trophies setFrame:CGRectMake(profile.cv_trophies.frame.origin.x, profile.cv_trophies.frame.origin.y, profile.cv_trophies.frame.size.width, profile.view.frame.size.height - profile.cv_trophies.frame.origin.y)];
    [profile.cv_playedEvents setFrame:CGRectMake(profile.cv_playedEvents.frame.origin.x, profile.cv_playedEvents.frame.origin.y, profile.cv_playedEvents.frame.size.width, profile.view.frame.size.height - profile.cv_playedEvents.frame.origin.y)];
}

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:@"gc_main_background"]];
}

-(void)setUpEventsList
{
    events = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCEventsVCIdentifier];
    events.competitionModel = [GCCompetitionManager getInstance].competitionDefault;
    [self.v_containerEvents addSubviewToBonce:events.view autoSizing:YES];
    [self addChildViewController:events];
    
    [events addCustomDataAfterEvents:@[
                                       @{@"title" : NSLocalizedString(@"gc_home_awards", nil), @"type" : @0},
                                       //@{@"title" : NSLocalizedString(@"gc_home_leagues", nil), @"type" : @1},
                                       @{@"title": NSLocalizedString(@"gc_home_ranking", nil), @"type" : @2},
                                       @{@"title": NSLocalizedString(@"gc_home_regulations", nil), @"type" : @3}]
                                       ];

    [events initEventsListWithSpecificLinker:[GCAPPEventLinker new]];
    
    [events.cv_events setDynamicFlowLayoutEnable:NO];
    [events.cv_events setMinimumLineSpacing:20];

    [super bindExternalGameForEvents];
}

#pragma Notifications CallBack for Blured Image
-(void)notificationImageBlured:(NSNotification *)notification
{
//    NSString *keyWantedHere = GCAPPBluredBackgroundWithNavbar;
//    
//    if (notification.userInfo && [[notification.userInfo getXpathEmptyString:@"key"] isEqualToString:keyWantedHere])
//        [self setBackgroundImage:[[GCBluredImageSingleton getInstance] getMyBluredImageUsingKey:keyWantedHere]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self stopWatchers];
}

@end
