//
//  GCRankingsViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "UICollectionViewGG.h"
#import "GCLeagueModel.h"
#import "GCRankingModel.h"
#import "GCCompetitionModel.h"

typedef enum
{
    eRankingoverall,
    eRankingMyLeagues,
    
    eRankingLeagueOverall,
    eRankingLeagueLastMatch,

    eRankingNone,
} eRankingListType;

@interface GCRankingsViewController : GCConnectViewController <UICollectionViewGGDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sc_overallLeague;
@property (weak, nonatomic) IBOutlet UIView *v_containerLeagueRanking;
@property (weak, nonatomic) IBOutlet UIView *v_containerSelectionLeague;

@property (weak, nonatomic) IBOutlet UILabel *lb_selectedLeagueName;
@property (weak, nonatomic) IBOutlet UILabel *lb_selectedLeagueMembers;
@property (weak, nonatomic) IBOutlet UIImageView *iv_arrowSelection;

@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_overallRanking;
@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_secondaryRanking;
@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_leaguesSelection;

@property (nonatomic, copy) void(^callBackMyRanking) (GCRankingUserModel *myCompetitionRank);

@property (strong, nonatomic) GCCompetitionModel *competitionModel;
@property (strong, nonatomic) GCLeagueModel *leagueModel;

@property (assign) eRankingListType firstTabRanking;
@property (assign) eRankingListType secondTabRanking;

-(void)loadRankingForLeague:(GCLeagueModel *)league usingCallBack:(void(^)(NSArray *rankings))cbRanking;

@end
