//
//  GCRankingsEventViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCRankingsEventViewController.h"
#import "GCProcessRankingManager.h"
#import "GCRankingRender.h"
#import "GCEventManager.h"
#import "GCCompetitionManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCRankingsEventViewController ()
{
    eGCRankingsEventHeaderType rankingsEventHeaderType;
    BOOL firstTimeLoading;
}
@end

@implementation GCRankingsEventViewController

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
    firstTimeLoading = YES;
    [self initLeaguesList];
}

-(void)initLeaguesList
{
    [self.cv_rankingsEvent setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_rankingsEvent setDelegateGG:self];
    [self.cv_rankingsEvent setParentViewController:self];
    [self.cv_rankingsEvent setRender:[GCRankingRender class]];
    [self.cv_rankingsEvent setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_rankingsEvent setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_event_rankings_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];

    [self.cv_rankingsEvent loadConfiguration];
    
    __weak GCRankingsEventViewController *weak_self = self;
    [self.cv_rankingsEvent setCallRefresh:^{
        [weak_self loadAllRankings];
    }];
}

-(void)initWithRankingsEventHeaderType:(eGCRankingsEventHeaderType)configRankingsEventHeaderType
{
    rankingsEventHeaderType = configRankingsEventHeaderType;
    rankingHeaderView = [GCRankingHeaderLargeView instanceFromNib];

    [self.v_headerRankingMe setFrame:CGRectMake(self.v_headerRankingMe.frame.origin.x, self.v_headerRankingMe.frame.origin.y, self.v_headerRankingMe.frame.size.width, 100)];
    [self.cv_rankingsEvent setFrame:CGRectMake(self.cv_rankingsEvent.frame.origin.x, self.v_headerRankingMe.frame.origin.y + self.v_headerRankingMe.frame.size.height, self.cv_rankingsEvent.frame.size.width, self.view.frame.size.height - self.v_headerRankingMe.frame.size.height)];
    [self.v_headerRankingMe addSubviewToBonce:rankingHeaderView autoSizing:YES];
}

-(void) updateHeaderRankingWithRankingModel:(GCRankingModel *)rankingModel
{
    if (rankingHeaderView)
        [rankingHeaderView updateWithRankingModel:rankingModel];
    
    [self loadAllRankings];
}

-(void)loadData
{
    if (!self.eventModel)
    {
        DLog(@"EventModel doesn't exist.");
        return ;
    }
    [self loadAllRankings];
    [self loadMyRanking];
}

-(void)loadAllRankings
{
    __weak GCRankingsEventViewController *weaK_self = self;
    
    [self.cv_rankingsEvent beginRefreshing];
    [GCEventManager getRankingsForEvent:self.eventModel._id inCompetition:self.eventModel.competition_id  withPage:1 andLimit:50 cb_response:^(NSArray *rankings)
    {
        [weaK_self.cv_rankingsEvent setData:@{@"flux" : rankings}];
        [weaK_self.cv_rankingsEvent endRefreshing];
     }];
}

-(void)loadMyRanking
{
    if (firstTimeLoading)
    {
        if (rankingsEventHeaderType == eGCRankingsEventHeaderLarge)
            [rankingHeaderView startLoaderInView:rankingHeaderView.lb_points andHideView:YES];
        else if (rankingsEventHeaderType == eGCRankingsEventHeaderSmall)
            [rankingHeaderView startLoaderInView:rankingHeaderView.lb_playerName andHideView:YES];
    }
    [GCEventManager getMyRankForEvent:self.eventModel._id inCompetition:self.eventModel.competition_id cb_response:^(GCRankingUserModel *myEventRank)
    {
        [self->rankingHeaderView updateWithRankingModel:myEventRank.event_ranking];
        
        if (self->firstTimeLoading)
        {
            if (self->rankingsEventHeaderType == eGCRankingsEventHeaderLarge)
                [self->rankingHeaderView stopLoaderInView:self->rankingHeaderView.lb_points andShowView:YES];
            
            else if (self->rankingsEventHeaderType == eGCRankingsEventHeaderSmall)
                [self->rankingHeaderView stopLoaderInView:self->rankingHeaderView.lb_playerName andShowView:YES];
        }
        
        if (self->firstTimeLoading)
            self->firstTimeLoading = NO;
    }];
}

#pragma UICollectionViewGGDelegate
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView
{
    [[GCProcessRankingManager sharedManager] selectItemInRankingsList:dataElement atIndexPath:indexPath fromViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
//    NSLog(@"DEALLOC Rankings events");
}


@end
