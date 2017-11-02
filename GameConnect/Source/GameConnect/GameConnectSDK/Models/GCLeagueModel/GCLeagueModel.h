//
//  GCLeagueModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCModel.h"
#import "GCGamerModel.h"

@interface GCLeagueModel : GCModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (assign) NSUInteger count;
@property (strong, nonatomic) GCGamerModel *gamer;

+(BOOL)validateLeagueName:(NSString *)leagueName;

@end
