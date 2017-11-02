//
//  NsSnLikeModel.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"
#import "NsSnUserModel.h"


@interface NsSnLikeModel : NsSnModel

@property (nonatomic,retain) NsSnUserModel * User;
//@property (nonatomic,retain) NSString *fk_user_id;
//@property (nonatomic,retain) NSString *fk_user_login;
//@property (nonatomic,retain) NSString *user_avatar_url;


@end
