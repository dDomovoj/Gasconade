//
//  GCAPPRankingsViewControlleriPhone.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPRankingsViewController.h"
#import "GCRankingHeaderLargeView.h"
#import "GCGamerManager.h"
#import "GCBluredImageSingleton.h"
#import "GCCompetitionManager.h"
#import "GCProcessProfileManager.h"

@interface GCAPPRankingsViewController ()
@end

@implementation GCAPPRankingsViewController

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
    self.title = nil;//NSLocalizedString(@"gc_rankings", nil);
    
    [self setUpHeaderRanking];
    [self setUpRankingsList];
}

-(void)setUpRankingsList
{
    rankings = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCRankingsVCIdentifier];
    
    rankings.firstTabRanking = eRankingoverall;
    rankings.secondTabRanking = eRankingNone;
    rankings.competitionModel = self.competitionModel;
    
    [self.v_containerRankingsList addSubviewToBonce:rankings.view autoSizing:YES];
    [self addChildViewController:rankings];

    [rankings.cv_overallRanking setDynamicFlowLayoutEnable:NO];
    [rankings.cv_secondaryRanking setDynamicFlowLayoutEnable:NO];
    [rankings.cv_leaguesSelection setDynamicFlowLayoutEnable:NO];
    
    __weak GCRankingHeaderView *weak_rankingHeaderView = rankingHeaderView;
    [rankings setCallBackMyRanking:^(GCRankingUserModel *myCompetitionRank) {
        [weak_rankingHeaderView updateWithRankingModel:myCompetitionRank.competition_ranking];
    }];
}

-(void)setUpHeaderRanking
{
    rankingHeaderView = [GCRankingHeaderLargeView instanceFromNib];
    rankingHeaderView.delegate = self;
    [self.v_containerHeaderProfileRank addSubviewToBonce:rankingHeaderView autoSizing:YES];
}

- (void)didRequestEditProfiel:(GCGamerModel *)gamerModel fromView:(GCRankingHeaderView *)headerView
{
    [[GCProcessProfileManager sharedManager] requestProfileEdition:gamerModel fromViewController:self];
}

- (BOOL)isProfileEditEnabled
{
    return YES;
}
@end
