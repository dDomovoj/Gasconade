//
//  GCAPPProfileViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPProfileViewController.h"
#import "GCAPPSoccerPlayedEventCell.h"
#import "GCCompetitionManager.h"
#import "GCAPPMatchManager.h"

@interface GCAPPProfileViewController ()

@end

@implementation GCAPPProfileViewController

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
    self.title = nil;//[NSLocalizedString(@"gc_profile", nil) capitalizedString];

    [self setUpProfile];
}

-(void)setUpProfile
{
    profile = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCProfileVCIdentifier];
    [self.v_containerProfile addSubviewToBonce:profile.view autoSizing:YES];
    [self addChildViewController:profile];
    profile.competitionModel = [GCCompetitionManager getInstance].competitionDefault;

    [profile initPlayedEventListWithSpecificRender:[GCAPPSoccerEventCell class]];
    
    [profile.cv_playedEvents setDynamicFlowLayoutEnable:NO];
    [profile.cv_playedEvents setMinimumLineSpacing:10.0f];
    [profile.cv_trophies setDynamicFlowLayoutEnable:NO];
    [profile.cv_trophies setMinimumLineSpacing:10.0f];
    
    [profile updateWithGamer:self.gamerModel];
    [self bindExternalGameForPassedEvents];
}

-(void)bindExternalGameForPassedEvents{
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
//    NSLog(@">>>>> DEALLOC APP PROFILE");
}

@end
