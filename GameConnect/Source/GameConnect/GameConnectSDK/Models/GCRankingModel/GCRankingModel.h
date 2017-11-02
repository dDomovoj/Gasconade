//
//  GCRankUserModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGamerModel.h"
#import "GCModel.h"

@interface GCRankingModel : GCModel
@property (assign) NSUInteger score;
@property (assign) NSUInteger rank;
@property (nonatomic, strong) GCGamerModel *gamer;
@end

@interface GCRankingUserModel : GCModel
@property (nonatomic, strong) GCGamerModel *gamer;
@property (nonatomic, strong) GCRankingModel *event_ranking;
@property (nonatomic, strong) GCRankingModel *competition_ranking;
@property (nonatomic, strong) GCRankingModel *global_ranking;
@end
