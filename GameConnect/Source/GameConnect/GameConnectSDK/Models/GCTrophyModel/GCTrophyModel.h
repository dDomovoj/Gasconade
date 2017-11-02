//
//  GCTrophiesModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 09/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCModel.h"

@interface GCTrophyModel : GCModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *picture_url;

@end
