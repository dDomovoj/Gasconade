//
//  NsSnPendingTagModel.h
//  Internacional
//
//  Created by Guillaume Derivery on 12/2/13.
//  Copyright (c) 2013 Netcosport. All rights reserved.
//

#import "NsSnModel.h"

@interface NsSnPendingTagModel : NsSnModel

@property (nonatomic,strong) NSString* _id;
@property (nonatomic,strong) NSString* fk_user_id;
@property (nonatomic,strong) NSString* fk_user_login;
@property (nonatomic,strong) NSString* user_avatar_url;

@end
