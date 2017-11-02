//
//  GCAPPHomeViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPHomeViewController.h"
#import "GCAPPSoccerEventCell.h"
#import "GCBluredImageSingleton.h"
#import "GCCompetitionManager.h"
#import "GCGamerManager.h"
#import "GCAPPMatchManager.h"
#import "GCConfManager.h"
#import "GCAppDefines.h"

@interface GCAPPHomeViewController ()
@end

@implementation GCAPPHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = NSLocalizedString(@"gc_home", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationImageBlured:) name:CGAPPNotificationBluredDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedInGameConnect:) name:GCNOTIF_LOGGEDIN object:nil];
    
    [self setUpEventsList];
    [self setUpProfile];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [profile updateWithGamer:[GCGamerManager getInstance].gamer];
}

-(void)notificationImageBlured:(NSNotification *)notification
{
}

-(void)loggedInGameConnect:(NSNotification *)notification
{
    if (notification && notification.userInfo)
    {
        GCGamerModel *gamerProfile = [notification.userInfo getXpathNil:@"user" type:[GCGamerModel class]];
        if (gamerProfile)
            [self updateWithGamer:[GCGamerManager getInstance].gamer];
    }
}

-(void) updateWithGamer:(GCGamerModel *)gamer
{
    if (profile)
        [profile updateWithGamer:gamer];
}

-(void)updateNewEvent:(GCEventModel *)newEvent
{
    if (events)
        [events updateNewEvent:newEvent];
}

-(void)updateEndEvent:(GCEventModel *)endEvent
{
    if (events)
        [events updateEndEvent:endEvent];
}

-(void) setUpProfile
{
    profile = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCProfileVCIdentifier];
    [self.v_containerProfile setClipsToBounds:YES];
    [self.v_containerProfile addSubviewToBonce:profile.view autoSizing:YES];
    [self addChildViewController:profile];
    profile.competitionModel = [GCCompetitionManager getInstance].competitionDefault;
    [profile initPlayedEventListWithSpecificRender:[GCAPPSoccerEventCell class]];

    [profile.cv_playedEvents setDynamicFlowLayoutEnable:NO];
    [profile.cv_trophies setDynamicFlowLayoutEnable:NO];

    [profile.cv_playedEvents setMinimumLineSpacing:10.0f];
    [profile.cv_trophies setMinimumLineSpacing:10.0f];

    [self bindExternalGameForPassedEvents];
}

-(void)setUpEventsList
{ }

-(void)bindExternalGameForEvents
{
    if (!events){
        return;
    }
    events.loadGameEvents = ^(NSArray *arEvents, void(^repEvent)(void)){
        __block NSMutableString *listOfMatchIds = [[NSMutableString alloc] init];
        
        [arEvents each:^(NSInteger index, GCEventModel *event, BOOL last){
            NSString *mId = event.provider_id;
            if (mId && [mId length] > 0)
            {
                if (index != 0){
                    [listOfMatchIds appendString:@","];
                }
                [listOfMatchIds appendString:mId];
            }
        }];
        [GCAPPMatchManager getGCListMatchsHeads:listOfMatchIds rep:^(GCAPPMatchManager *rep, BOOL cache, NSData *data)
        {
            [arEvents each:^(NSInteger index, GCEventModel *event, BOOL last)
            {
                event.gameContent = [GCAPPMatchManager getGCEventMatchFromId:event.provider_id];
            }];
            
            if (repEvent){
                repEvent();
            }
        }];
    };
    
}

-(void)bindExternalGameForPassedEvents
{
    if (!profile){
        return;
    }
    profile.loadGameEvents = ^(NSArray *arEvents, void(^repEvent)(void)){
        __block NSMutableString *listOfMatchIds = [[NSMutableString alloc] init];
        
        [arEvents each:^(NSInteger index, GCEventModel *event, BOOL last){
            NSString *mId = event.provider_id;
            if (mId && [mId length] > 0)
            {
                if (index != 0){
                    [listOfMatchIds appendString:@","];
                }
                [listOfMatchIds appendString:mId];
            }
        }];
        [GCAPPMatchManager getGCListMatchsHeads:listOfMatchIds rep:^(GCAPPMatchManager *rep, BOOL cache, NSData *data)
        {
            [arEvents each:^(NSInteger index, GCEventModel *event, BOOL last)
            {
                event.gameContent = [GCAPPMatchManager getGCEventMatchFromId:event.provider_id];
            }];
            
            if (repEvent){
                repEvent();
            }
        }];
    };
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
