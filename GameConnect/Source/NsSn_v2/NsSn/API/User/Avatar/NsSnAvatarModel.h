//
//  NsSnAvatarModel.h
//  StadeDeFrance
//
//  Created by Guillaume Derivery on 2/24/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "NsSnModel.h"

@interface NsSnAvatarModel : NsSnModel

@property (nonatomic, strong) NSString *media_size;
@property (nonatomic, strong) NSString *mime_type;
@property (nonatomic, strong) NSString *profile_name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) int size;

+(id) fromJSONDictionary:(NSDictionary *)data;

@end
