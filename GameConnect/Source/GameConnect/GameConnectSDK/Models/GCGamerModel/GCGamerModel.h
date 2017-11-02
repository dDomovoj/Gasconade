//
//  GCUserModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCModel.h"
#import "GCTeamModel.h"

@interface GCGamerModel : GCModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *login;

@property (assign) NSInteger global_score;
@property (assign) NSInteger global_rank;

@property (nonatomic, retain) NSArray *Avatar_formats;

// Made to handle manual changes event if there is some cache between GC and NSAPI
@property (nonatomic) NSTimeInterval date_update;

@end
