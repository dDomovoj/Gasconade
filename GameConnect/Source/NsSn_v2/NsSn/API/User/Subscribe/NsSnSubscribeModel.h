//
//  NsSnSubscribeModel.h
//  Internacional
//
//  Created by adelskott on 26/09/13.
//  Copyright (c) 2013 Netcosport. All rights reserved.
//

#import "NsSnModel.h"

@interface NsSnSubscribeModel : NsSnModel

@property (nonatomic, strong) NSString* fk_tag_id;
@property (nonatomic, strong) NSString* user_avatar_url;
@property (nonatomic, strong) NSString* fk_tag_name;

@property (nonatomic, assign) int active;
@property (nonatomic, assign) int favoris;
@property (nonatomic, assign) int tag_type;
@property (nonatomic, assign) int pending;

@end
