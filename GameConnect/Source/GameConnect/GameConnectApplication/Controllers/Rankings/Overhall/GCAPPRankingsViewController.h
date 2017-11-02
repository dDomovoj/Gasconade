//
//  GCAPPRankingsViewControlleriPhone.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCRankingsViewController.h"
#import "GCRankingHeaderView.h"

@interface GCAPPRankingsViewController : GCAPPMasterViewController<GCRankingHeaderViewDelegate>
{
    GCRankingsViewController *rankings;
    GCRankingHeaderView *rankingHeaderView;
}
@property (weak, nonatomic) IBOutlet UIImageView *iv_brandLogo;
@property (weak, nonatomic) IBOutlet UIView *v_containerHeaderProfileRank;
@property (weak, nonatomic) IBOutlet UIView *v_containerRankingsList;

@property (strong, nonatomic) GCCompetitionModel *competitionModel;

@end
