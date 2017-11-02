//
//  GCCompetitionModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCModel.h"

@interface GCCompetitionModel : GCModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *picture_url;
@property (nonatomic, strong) NSString *channel_to_listen_to;

@property (nonatomic) NSDate *start_date;
@property (nonatomic) NSDate *end_date;

+(NSArray *) sortCompetitionsByStartDate:(NSArray *)competitions;

@end
