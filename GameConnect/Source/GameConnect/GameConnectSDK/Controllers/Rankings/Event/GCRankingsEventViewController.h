//
//  GCRankingsEventViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "UICollectionViewGG.h"
#import "GCEventModel.h"
#import "GCRankingHeaderLargeView.h"

typedef enum
{
    eGCRankingsEventHeaderLarge,
    eGCRankingsEventHeaderSmall,
} eGCRankingsEventHeaderType;

@interface GCRankingsEventViewController : GCConnectViewController <UICollectionViewGGDelegate>
{
    GCRankingHeaderView *rankingHeaderView;
}
@property (weak, nonatomic) IBOutlet UIView *v_headerRankingMe;
@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_rankingsEvent;

@property (strong, nonatomic) GCEventModel *eventModel;

-(void)initWithRankingsEventHeaderType:(eGCRankingsEventHeaderType)rankingsEventHeaderType;

-(void) updateHeaderRankingWithRankingModel:(GCRankingModel *)rankingModel;

@end
