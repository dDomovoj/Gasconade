//
//  GCProcessRankingManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"

/*
 ** GCProcessRankingManager
 */
@protocol GCProcessRankingManagerDelegate <GCProcessManagerDelegate>
@optional
/* Ranking */
-(void) GCDidSelectUser:(GCRankingModel *)rankingModel fromViewController:(GCConnectViewController *)rankingsViewController;
-(void) GCDidRequestRankingsFrom:(GCMasterViewController *)senderViewController;
@end

@interface GCProcessRankingManager : GCProcessManager

@property (weak, nonatomic) id<GCProcessRankingManagerDelegate> delegate;
/* Ranking */
-(void) selectItemInRankingsList:(GCRankingModel *)rankingModel atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCConnectViewController *)rankingsViewController;

-(void) requestRankingsFromViewController:(GCMasterViewController *)senderViewController;

@end

