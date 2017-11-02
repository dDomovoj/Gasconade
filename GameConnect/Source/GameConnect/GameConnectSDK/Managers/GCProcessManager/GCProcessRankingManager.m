//
//  GCProcessRankingManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessRankingManager.h"
#import "Extends+Libs.h"

@implementation GCProcessRankingManager
CREATE_INSTANCE

/* Ranking */
-(void) selectItemInRankingsList:(GCRankingModel *)rankingModel atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCConnectViewController *)rankingsViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!rankingModel || ![rankingModel isKindOfClass:[GCRankingModel class]])
        DLog(@"RankingModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCDidSelectUser:fromViewController:)])
        [self.delegate GCDidSelectUser:rankingModel fromViewController:rankingsViewController];
}

-(void) requestRankingsFromViewController:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;

    if ([self.delegate respondsToSelector:@selector(GCDidRequestRankingsFrom:)])
        [self.delegate GCDidRequestRankingsFrom:senderViewController];
}

@end
