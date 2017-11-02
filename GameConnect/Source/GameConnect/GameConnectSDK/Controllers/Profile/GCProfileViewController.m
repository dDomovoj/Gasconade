//
//  GCProfileViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCProfileViewController.h"
#import "DefaultCellRenderGG.h"
#import "GCGamerManager.h"
#import "GCProcessProfileManager.h"
#import "GCEventManager.h"
#import "GCTrophyRender.h"
#import "GCProfileViewController+GCUI.h"
//#import "GCLoggerManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCProfileViewController ()
{
    NSDictionary *dataEvents;
}
@end

@implementation GCProfileViewController

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
    
    [self initColors];
    [self initSegmentedControl];
    [self setUpProfilerHeader];
    [self initTrophiesList];
}

-(void)loadData
{
    if (self.gamerModel)
    {
        [self loadProfile];
        [self loadTrophies];
        if (self.competitionModel)
            [self loadPlayedEvents];
        else
            DLog(@"CompetitionModel doesn't exist");
    }
    else
        DLog(@"GamerModel doesn't exist");
}

-(void)loadProfile
{

    __weak typeof(self) weakSelf = self;
    [[GCGamerManager getInstance] getProfileForGamer:self.gamerModel._id cb_response:^(GCGamerModel *gamer)
     {
         _gamerModel = gamer;
         [weakSelf.profileHeader updateWithGamerModel:_gamerModel];
     }];
}

-(void)loadPlayedEvents
{
    __weak GCProfileViewController *weak_self = self;
    
    [self.cv_playedEvents beginRefreshing];
    [[GCGamerManager getInstance] getPlayedEventsForGamer:self.gamerModel._id inCompetition:self.competitionModel._id cb_response:^(NSArray *playedEvents)
     {
         [self setNoInfoForPlayedEvents];

         if (self.loadGameEvents)
         {
             self.loadGameEvents(playedEvents, ^{
                 [weak_self.cv_playedEvents setData:@{@"flux" : playedEvents}];
                 [weak_self.cv_playedEvents endRefreshing];
             });
         }
         else
         {
             [weak_self.cv_playedEvents setData:@{@"flux" : playedEvents}];
             [weak_self.cv_playedEvents endRefreshing];
         }
     }];
}

-(void)setNoInfoForPlayedEvents
{
    if ([self.gamerModel._id isEqualToString:[GCGamerManager getInstance].gamer._id])
        [self.cv_playedEvents setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_played_events_available_for_me", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
    else
        [self.cv_playedEvents setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_played_events_available_for_gamer", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
}

-(void)loadTrophies
{
    __weak GCProfileViewController *weak_self = self;
    
    [self.cv_trophies beginRefreshing];
    [[GCGamerManager getInstance] getTrophiesForGamer:self.gamerModel._id cb_response:^(NSArray *trophies)
     {
         [self setNoInfoForTrophies];
         [weak_self.cv_trophies setData:@{@"flux" : trophies}];
         [weak_self.cv_trophies endRefreshing];
     }];
}

-(void) setNoInfoForTrophies
{
    if ([self.gamerModel._id isEqualToString:[GCGamerManager getInstance].gamer._id])
        [self.cv_trophies setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_trophies_available_for_me", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
    else
        [self.cv_trophies setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_trophies_available_for_gamer", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
}

#pragma init UICollectionView - TROPHIES
-(void)initTrophiesList
{
    __weak GCProfileViewController *weak_self = self;

    [self.cv_trophies setDelegateGG:self];
    [self.cv_trophies setParentViewController:self];
    [self.cv_trophies setRender:[GCTrophyRender class]];
    [self.cv_trophies setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_trophies loadConfiguration];
    
    [self.cv_trophies setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_trophies setCallRefresh:^{
        [weak_self loadTrophies];
    }];
}

#pragma init UICollectionView - EVENTS
-(void)updateWithGamer:(GCGamerModel *)gamerModel
{
    _gamerModel = gamerModel;
}

-(void)initPlayedEventListWithDefaultRender
{
    [self initPlayedEventListWithSpecificRender:[DefaultCellRenderGG class]];
}

-(void)initPlayedEventListWithSpecificRender:(Class<IRenderGG>)render
{
    __weak GCProfileViewController *weak_self = self;
    
    [self.cv_playedEvents setDelegateGG:self];
    [self.cv_playedEvents setParentViewController:self];
    [self.cv_playedEvents setRender:render];
    [self.cv_playedEvents setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_playedEvents loadConfiguration];
    
    [self.cv_playedEvents setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_playedEvents setCallRefresh:^{
        [weak_self loadPlayedEvents];
    }];
}

-(void)initPlayedEventListWithSpecificLinker:(id<ILinkerGG>)linker
{
    __weak GCProfileViewController *weak_self = self;
    
    [self.cv_playedEvents setDelegateGG:self];
    [self.cv_playedEvents setParentViewController:self];
    [self.cv_playedEvents setItemLinker:linker];
    [self.cv_playedEvents setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_playedEvents setBackgroundColor:[UIColor redColor]];
    
    if ([self.gamerModel._id isEqualToString:[GCGamerManager getInstance].gamer._id])
        [self.cv_playedEvents setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_played_events_available_for_me", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
    else
        [self.cv_playedEvents setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_played_events_available_for_gamer", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];

    [self.cv_playedEvents loadConfiguration];
    
    [self.cv_playedEvents setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_playedEvents setCallRefresh:^{
        [weak_self loadPlayedEvents];
    }];
}

#pragma UICollectionViewGGDelegate
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView
{
    if (collectionView == self.cv_playedEvents)
    {
        if (!dataElement || ![dataElement isKindOfClass:[GCEventModel class]])
            DLog(@"Bad data for item at indexPath %@", [indexPath description]);
        
        [[GCProcessProfileManager sharedManager] selectItemInPlayedEventList:dataElement atIndexPath:indexPath fromViewController:self];
    }
    else if (collectionView == self.cv_trophies)
    {
        if (!dataElement || ![dataElement isKindOfClass:[GCTrophyModel class]])
            DLog(@"Bad data for item at indexPath %@", [indexPath description]);
        
        [[GCProcessProfileManager sharedManager] selectItemInTrophiesList:dataElement atIndexPath:indexPath fromViewController:self];
    }
}

#pragma GCProfileHeaderDelegate
- (void)didRequestEditProfiel:(GCGamerModel *)gamerModel fromView:(GCRankingHeaderView *)headerView
{
    [[GCProcessProfileManager sharedManager] requestProfileEdition:gamerModel fromViewController:self];
}

- (BOOL)isProfileEditEnabled
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
