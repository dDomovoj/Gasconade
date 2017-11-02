//
//  GCRankingsViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCRankingsViewController+GCUI.h"
#import "GCRankingsViewController.h"
#import "GCProcessRankingManager.h"
#import "GCRankingRender.h"
#import "GCLeagueManager.h"
#import "GCLeagueRender.h"
#import "GCCompetitionManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCRankingsViewController ()
{
    NSArray *myLeagues;
    NSInteger preselectIndexInLeagues;
    BOOL leagueSelectionIsOpen;
}
- (IBAction)changeSegmentedControlValue:(id)sender;
- (IBAction)clickOnLeagueSelection:(id)sender;
@end

@implementation GCRankingsViewController

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

    preselectIndexInLeagues = -1;
    leagueSelectionIsOpen = NO;
    
    [self.sc_overallLeague removeAllSegments];

    [self initFirstTabList];
    [self initSecondaryTabList];
    [self initSegmentedControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLeaguesView];
}

#pragma mark - Init - Tabs
-(void)initFirstTabList
{
    [self.cv_overallRanking setDelegateGG:self];
    [self.cv_overallRanking setParentViewController:self];
    [self.cv_overallRanking setRender:[GCRankingRender class]];
    [self.cv_overallRanking setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_overallRanking setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_overallRanking loadConfiguration];

    __weak GCRankingsViewController *weak_self = self;
    [self.cv_overallRanking setCallRefresh:^{
        [weak_self loadDataForPrimaryList];
    }];
}

-(void)initSecondaryTabList
{
    if (self.secondTabRanking == eRankingMyLeagues)
        [self initLeaguesSelectionList];

    [self.cv_secondaryRanking setDelegateGG:self];
    [self.cv_secondaryRanking setParentViewController:self];
    [self.cv_secondaryRanking setRender:[GCRankingRender class]];
    [self.cv_secondaryRanking setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_secondaryRanking setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_secondaryRanking loadConfiguration];

    __weak GCRankingsViewController *weak_self = self;
    [self.cv_secondaryRanking setCallRefresh:^{
        [weak_self loadDataForSecondaryList];
    }];
}

-(void)initLeaguesSelectionList
{
    [self.cv_leaguesSelection setDelegateGG:self];
    [self.cv_leaguesSelection setParentViewController:self];
    [self.cv_leaguesSelection setRender:[GCLeagueRender class]];
    [self.cv_leaguesSelection setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_leaguesSelection setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_leaguesSelection loadConfiguration];

    __weak GCRankingsViewController *weak_self = self;
    [self.cv_leaguesSelection setCallRefresh:^{
        [weak_self loadDataLeagues:^(BOOL ok) {
            [weak_self.cv_leaguesSelection endRefreshing];
        }];
    }];
}

#pragma mark - Data - Loading
-(void)loadData
{
    [self loadDataForPrimaryList];
    [self loadDataForSecondaryList];
}

-(void)loadDataForPrimaryList
{
    __weak GCRankingsViewController *weak_self = self;
    if (self.firstTabRanking == eRankingoverall)
    {
        [self loadRanKingForCompetition:self.competitionModel usingCallback:nil];
    }
    else if (self.firstTabRanking == eRankingLeagueOverall)
    {
        [self.cv_overallRanking setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_overall_league_rankings_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];

        if (preselectIndexInLeagues == -1)
            preselectIndexInLeagues = 0;

        if (preselectIndexInLeagues < [myLeagues count])
        {
            GCLeagueModel *leagueModel = [myLeagues objectAtIndex:preselectIndexInLeagues];
            if (!leagueModel)
            {
                DLog(@"No league at index : %ld", (long)preselectIndexInLeagues);
                return ;
            }
            [self.cv_overallRanking beginRefreshing];
            [self loadRankingForLeague:leagueModel usingCallBack:^(NSArray *rankings) {
                [weak_self.cv_overallRanking endRefreshing];
            }];
        }
        else if (self.leagueModel)
        {
            [self.cv_overallRanking beginRefreshing];
            [self loadRankingForLeague:self.leagueModel usingCallBack:^(NSArray *rankings) {
                [weak_self.cv_overallRanking endRefreshing];
            }];
        }
        else
        {
            [self.cv_overallRanking setData:@{@"flux" : @[]}];
            [self.cv_overallRanking endRefreshing];
        }
    }
}

-(void)loadDataForSecondaryList
{
    __weak GCRankingsViewController *weak_self = self;
    if (self.secondTabRanking == eRankingMyLeagues)
    {
        [self.cv_leaguesSelection beginRefreshing];
        [self loadDataLeagues:^(BOOL ok)
         {
             [weak_self.cv_leaguesSelection endRefreshing];
             
             if (!ok)
                 return ;
             
             [weak_self.cv_secondaryRanking setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_overall_league_rankings_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
             
             if (self->preselectIndexInLeagues == -1)
                 self->preselectIndexInLeagues = 0;
             
             if (self->myLeagues && self->preselectIndexInLeagues < [self->myLeagues count])
             {
                 GCLeagueModel *leagueModel = [self->myLeagues objectAtIndex:self->preselectIndexInLeagues];
                 if (!leagueModel)
                 {
                     DLog(@"No league at index : %ld", (long)self->preselectIndexInLeagues);
                     return ;
                 }
                 [self.lb_selectedLeagueName setText:leagueModel.name];
                 [self.lb_selectedLeagueMembers setText:SWF(@"%ld", (long)leagueModel.count)];

                 [self loadRankingForLeague:leagueModel usingCallBack:nil];
             }
             else
                 [self loadRankingForLeague:nil usingCallBack:nil];
         }];
    }
    else if (self.secondTabRanking == eRankingLeagueLastMatch)
    {
        [self.cv_secondaryRanking beginRefreshing];
        [weak_self.cv_secondaryRanking setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_lastmatch_league_rankings_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
        
        if (preselectIndexInLeagues == -1)
            preselectIndexInLeagues = 0;
        
        if (myLeagues && preselectIndexInLeagues < [myLeagues count])
        {
            GCLeagueModel *leagueModel = [myLeagues objectAtIndex:preselectIndexInLeagues];
            if (!leagueModel)
            {
                DLog(@"No league at index : %ld", (long)preselectIndexInLeagues);
                [weak_self.cv_secondaryRanking endRefreshing];
                return ;
            }
            else
            {
                [self.lb_selectedLeagueName setText:leagueModel.name];
                [self.lb_selectedLeagueMembers setText:SWF(@"%ld", (long)leagueModel.gamer)];
                
                [GCLeagueManager getLastMatchRankingsForLeague:leagueModel._id withPage:1 andLimit:50 cb_response:^(NSArray *rankings)
                {
                    [weak_self.cv_secondaryRanking setData:@{@"flux" : rankings}];
                    [weak_self.cv_secondaryRanking endRefreshing];
                }];
            }
        }
    }
}

-(void) loadRanKingForCompetition:(GCCompetitionModel *)competition usingCallback:(void(^)(NSArray *rankings))cbRankings
{
    __weak GCRankingsViewController *weak_self = self;
    if (!self.competitionModel)
    {
        DLog(@"Competition doesn't exist");
        return ;
    }
    
    [self.cv_overallRanking beginRefreshing];
    [GCCompetitionManager getRankingsForCompetition:self.competitionModel._id withPage:1 andLimit:50 cb_response:^(NSArray *rankings)
     {
         [weak_self.cv_overallRanking setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_overall_rankings_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
         
         [weak_self.cv_overallRanking setData:@{@"flux" : rankings}];
         [weak_self.cv_overallRanking endRefreshing];
         if (cbRankings)
             cbRankings(rankings);
     }];
    [GCCompetitionManager getMyRankForCompetition:self.competitionModel._id cb_response:^(GCRankingUserModel *myCompetitionRank)
     {
         if (weak_self.callBackMyRanking)
             weak_self.callBackMyRanking(myCompetitionRank);
     }];
}

-(void)loadDataLeagues:(void(^)(BOOL ok))cb_rep
{
    __weak GCRankingsViewController *weak_self = self;
    [GCLeagueManager getMyLeaguesWithResponse:^(NSArray *leagues)
    {
         if (leagues)
         {
             myLeagues = leagues;

             if ([leagues count] == 0)
             {
                 [weak_self closeLeagueSelection];
                 [weak_self hideLeagueSelectionHeader];
             }
             else
             {
                 [weak_self showLeagueSelectionHeader];
//                 [self clickOnLeagueSelection:nil];
             }

             [weak_self.cv_leaguesSelection setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_leagues_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
             [weak_self.cv_leaguesSelection setData:@{@"flux" : leagues}];
             
             cb_rep(YES);
         }
         else
             cb_rep(NO);
     }];
}

-(void)loadRankingForLeague:(GCLeagueModel *)league usingCallBack:(void(^)(NSArray *rankings))cbRanking
{
    self.leagueModel = league;
    
    if (!self.leagueModel)
    {
        if (self.firstTabRanking == eRankingLeagueOverall)
            [self.cv_overallRanking setData:@{@"flux" : @[]}];
        
        else if (self.secondTabRanking == eRankingMyLeagues)
            [self.cv_secondaryRanking setData:@{@"flux" : @[]}];

        if (cbRanking)
            cbRanking(@[]);
        return;
    }
    
    if (self.firstTabRanking == eRankingLeagueOverall)
        [self.cv_overallRanking beginRefreshing];
    else if (self.secondTabRanking == eRankingMyLeagues)
        [self.cv_secondaryRanking beginRefreshing];

    NSUInteger page = 1;
    NSUInteger limit = 50;
    
    __weak GCRankingsViewController *weak_self = self;
    [GCLeagueManager getRankingsForLeague:league._id withPage:page andLimit:limit cb_response:^(NSArray *rankings)
    {
        if (weak_self.firstTabRanking == eRankingLeagueOverall)
        {
            [weak_self.cv_overallRanking setData:@{@"flux" : rankings}];
            [weak_self.cv_overallRanking endRefreshing];
        }
        else if (weak_self.secondTabRanking == eRankingMyLeagues)
        {
            [weak_self.cv_secondaryRanking setData:@{@"flux" : rankings}];
            [weak_self.cv_secondaryRanking endRefreshing];
        }
        if (cbRanking)
            cbRanking(rankings);
    }];
}

#pragma mark User - Interactions
- (IBAction)changeSegmentedControlValue:(id)sender
{
    [self changeSelectedTabInSegmentedControl];
}

- (IBAction)clickOnLeagueSelection:(id)sender
{
    leagueSelectionIsOpen = !leagueSelectionIsOpen;
    if (leagueSelectionIsOpen)
        [self openLeagueSelection];
    else
        [self closeLeagueSelection];
}

#pragma UICollectionViewGG
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView
{
    if (collectionView == self.cv_overallRanking || collectionView == self.cv_secondaryRanking)
    {
        [[GCProcessRankingManager sharedManager] selectItemInRankingsList:dataElement atIndexPath:indexPath fromViewController:self];
    }
    else
    {
        __block UICollectionViewCell *selectedCell = [collectionView  cellForItemAtIndexPath:indexPath];
        GCLeagueRender *leagueRender = (GCLeagueRender *)selectedCell;
        if ([leagueRender isKindOfClass:[GCLeagueRender class]])
        {
            preselectIndexInLeagues = indexPath.row;
            [leagueRender setSelected:YES andLoad:YES];
            
            if (preselectIndexInLeagues < [myLeagues count])
            {
                GCLeagueModel *leagueModel = [myLeagues objectAtIndex:preselectIndexInLeagues];
                if (!leagueModel)
                {
                    DLog(@"No league at index : %ld", (long)preselectIndexInLeagues);
                    [self.cv_secondaryRanking endRefreshing];
                    return ;
                }
                else
                {
                    __weak GCRankingsViewController *weak_self = self;
                    [self loadRankingForLeague:leagueModel usingCallBack:^(NSArray *rankings)
                    {
                        [leagueRender setSelected:NO andLoad:NO];
                        [weak_self clickOnLeagueSelection:nil];
                    }];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
//    NSLog(@">>>>>>>>>>>> DEALLOC RANKINGS");
}

@end


