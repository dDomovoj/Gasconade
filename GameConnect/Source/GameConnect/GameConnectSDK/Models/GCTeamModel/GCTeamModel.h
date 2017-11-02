//
//  GCTeamModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCModel.h"

@interface GCTeamModel : GCModel

@property (nonatomic) NSInteger team_id;
@property (nonatomic, strong) NSString *team_name;
@property (nonatomic, strong) NSString *team_abbreviation;
@property (nonatomic) BOOL team_picture;

@end

@interface GCFavoriteTeamModel : GCModel

@property (nonatomic, strong) NSString  *_id;
@property (nonatomic, strong) NSString  *tag_id;
@property (nonatomic, strong) NSString  *tag_name;
@property (nonatomic, strong) NSString  *tag_xid;

@end
