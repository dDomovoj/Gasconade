//
//  GCAPPGameViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPGameViewController.h"
#import "GCAPPMatchManager.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

#import <Masonry/Masonry.h>

@interface GCAPPGameViewController ()
@end

@implementation GCAPPGameViewController

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
    self.title = nil;//[NSLocalizedString(@"gc_game", nil) capitalizedString];

    [self setUpQuestionsList];
    [self setUpRankingsEvent];
}

-(void)bindExternalGameForEvent
{
    if (!eventHeader)
        return;
    
    eventHeader.loadGameEvent = ^(GCEventModel *event, void(^repEvent)(void))
    {
        [GCAPPMatchManager getGCListMatchsHeads:event.provider_id rep:^(GCAPPMatchManager *rep, BOOL cache, NSData *data)
        {
            event.gameContent = [GCAPPMatchManager getGCEventMatchFromId:event.provider_id];
            if (repEvent)
                repEvent();
        }];
    };
}

-(void)setUpQuestionsList
{
    gameLists = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCInGameVCIdentifier];
    gameLists.eventModel = self.eventModel;
    [self.v_containerQuestions addSubviewToBonce:gameLists.view autoSizing:YES];
    [self addChildViewController:gameLists];
}

-(void)setUpRankingsEvent
{
    rankingsEvent = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCRankingsEventVCIdentifier];
    rankingsEvent.eventModel = self.eventModel;
    [self.v_containerRanking addSubviewToBonce:rankingsEvent.view autoSizing:YES];
    [self addChildViewController:rankingsEvent];
    
    [rankingsEvent initWithRankingsEventHeaderType:([UIDevice isIPAD] ? eGCRankingsEventHeaderLarge : eGCRankingsEventHeaderSmall)];
}

-(void) updateMyRanking:(GCRankingModel *)myRanking
{
    if (rankingsEvent)
        [rankingsEvent updateHeaderRankingWithRankingModel:myRanking];
}

-(void)updateNewQuestion:(GCQuestionModel *)question
{
    if (gameLists)
        [gameLists updateNewQuestion:question];
}

-(void)updateEndQuestion:(GCQuestionModel *)question
{
    if (gameLists)
        [gameLists updateEndQuestion:question];
}

-(void)updateEndEvent:(GCEventModel *)event
{
    if (event && self.eventModel && self.eventModel._id && event._id && [event._id isEqualToString:self.eventModel._id])
    {
        _eventModel = event;
        [self setFlashMessage:NSLocalizedString(@"gc_event_ended", nil)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)navigationBarOffset {
    return 64 + 10;
}

-(void)dealloc
{
//    NSLog(@">>>>>>>>>>>> DEALLOC APP GAME");
}

@end
