//
//  NsSnFriendModel.h
//  NsSn
//
//  Created by adelskott on 06/09/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnModel.h"
#import "NsSnUserModel.h"


@interface NsSnFriendModel : NsSnModel

@property (nonatomic,retain) NSString *_id;
@property (assign) int friend_valide;
@property (assign) int friend_level;


@property (nonatomic,retain) NsSnUserModel *User;

@end
