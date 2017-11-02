//
//  GCLeaguesViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCLeaguesViewController.h"
#import "GCProcessLeagueManager.h"
#import "GCLeagueRender.h"
#import "GCLeagueManager.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCLeaguesViewController ()
{
    NSIndexPath *selectedLeagueIndexPath;
}
@end

@implementation GCLeaguesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectedLeagueIndexPath = nil;
        self.leagueSelectionActive = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLeaguesList];
}

-(void)initLeaguesList
{
    [self.cv_leagues setDelegateGG:self];
    [self.cv_leagues setParentViewController:self];
    [self.cv_leagues setRender:[GCLeagueRender class]];
    [self.cv_leagues setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_leagues setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_leagues_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
    [self.cv_leagues setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_leagues loadConfiguration];
    
    __weak GCLeaguesViewController *weak_self = self;
    [self.cv_leagues setCallRefresh:^{
        [weak_self loadData];
    }];
}

-(void)loadData
{
    __weak GCLeaguesViewController *weak_self = self;
    [self.cv_leagues beginRefreshing];
    [GCLeagueManager getMyLeaguesWithResponse:^(NSArray *leagues)
    {
        [weak_self.cv_leagues setData:@{@"flux" : leagues}];
        [weak_self.cv_leagues endRefreshing];

        NSIndexPath *previousSelectedLeague = self->selectedLeagueIndexPath;
        NSIndexPath *newSelectedLeague = previousSelectedLeague;

        if (self.leagueSelectionActive && !previousSelectedLeague)
            newSelectedLeague = [NSIndexPath indexPathForItem:0 inSection:0];
        else
            newSelectedLeague = previousSelectedLeague;

        [self performWithDelay:0.1 block:^{
            [weak_self unselectAllLeagues];
            if ([leagues count] > 0 && self.leagueSelectionActive)
                [weak_self selectLeagueAtIndexPath:newSelectedLeague];
        }];
    }];
}

-(void)unselectAllLeagues
{
    selectedLeagueIndexPath = nil;
    for (GCLeagueRender *selectedCell in [self.cv_leagues visibleCells])
    {
        if (selectedCell && [selectedCell isKindOfClass:[GCLeagueRender class]])
            [selectedCell setSelected:NO andLoad:NO];
    }
}

-(void)selectLeagueAtIndexPath:(NSIndexPath *)indexPathOfSelectedLeague
{
    if ([self.cv_leagues numberOfItemsInSection:indexPathOfSelectedLeague.section] > indexPathOfSelectedLeague.row)
    {
        selectedLeagueIndexPath = indexPathOfSelectedLeague;

        GCLeagueRender *selectedCell = (GCLeagueRender *)[self.cv_leagues cellForItemAtIndexPath:indexPathOfSelectedLeague];
        if (selectedCell && [selectedCell isKindOfClass:[GCLeagueRender class]])
        {
            [selectedCell setSelected:YES andLoad:NO];
            [[GCProcessLeagueManager sharedManager] selectItemInLeaguesList:[[self.cv_leagues.data getXpathNilArray:@"flux"] objectAtIndex:indexPathOfSelectedLeague.row] atIndexPath:indexPathOfSelectedLeague fromViewController:self];
        }
    }
}


#pragma UICollectionViewGGDelegate
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView
{
    if (self.leagueSelectionActive)
    {
        [self unselectAllLeagues];
        [self selectLeagueAtIndexPath:indexPath];
    }
    else
        [[GCProcessLeagueManager sharedManager] selectItemInLeaguesList:dataElement atIndexPath:indexPath fromViewController:self];
}

-(void)willDisplayCell:(UICollectionViewCell *)cell withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView atIndexPath:(NSIndexPath *)indexPath
{
    return ;
    if ([UIDevice isIPAD])
    {
        if (selectedLeagueIndexPath && [selectedLeagueIndexPath isEqual:indexPath])
        {
            if (cell && [cell isKindOfClass:[GCLeagueRender class]])
            {
                [[GCProcessLeagueManager sharedManager] selectItemInLeaguesList:dataElement atIndexPath:indexPath fromViewController:self];
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
//    NSLog(@">>>>>>> DEALLOC Leagues");
}

@end
