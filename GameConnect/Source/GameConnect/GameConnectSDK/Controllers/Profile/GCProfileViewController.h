//
//  GCProfileViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "UICollectionViewGG.h"
#import "GCEventModel.h"
#import "GCGamerModel.h"
#import "GCProfileHeader.h"
#import "GCCompetitionModel.h"
#import "GCRankingHeaderLargeView.h"

@interface GCProfileViewController : GCConnectViewController <UICollectionViewGGDelegate, GCRankingHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *v_containerHeaderProfile;
@property (weak, nonatomic) IBOutlet UIView *v_containerSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sc_playedTrophies;
@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_playedEvents;
@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_trophies;
//@property (strong, nonatomic) GCProfileHeader *profileHeader;
@property (strong, nonatomic) GCRankingHeaderView *profileHeader;

@property (strong, nonatomic, readonly) GCGamerModel *gamerModel;
@property (strong, nonatomic) GCCompetitionModel *competitionModel;

@property (copy, nonatomic) void(^loadGameEvents)(NSArray *events, void(^)(void));

-(void)initPlayedEventListWithDefaultRender;
-(void)initPlayedEventListWithSpecificRender:(Class<IRenderGG>)render;
-(void)initPlayedEventListWithSpecificLinker:(id<ILinkerGG>)linker;
-(void)updateWithGamer:(GCGamerModel *)gamerModel;

@end
