//
//  NsSnFeedModel.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"
#import "NsSnUserModel.h"

@interface NsSnFeedModel : NsSnModel

@property (nonatomic,retain) NSString *_id;
/*@property (nonatomic,retain) NSString *feed_user_id;
@property (nonatomic,retain) NSString *feed_user_login;*/
@property (nonatomic,retain) NSString *feed_to;
@property (nonatomic,retain) NSString *feed_to_login;
@property (assign) int feed_private;
@property (assign) int created_at;
@property (assign) int feed_last_update;
@property (assign) int feed_client_id;
@property (nonatomic,retain) NSString *feed_text;
@property (assign) int feed_nblike;
@property (nonatomic,retain) NSArray *Likes;
@property (assign) int feed_nbcomments;
@property (nonatomic,retain) NSArray *Comments;
@property (assign) int feed_nbmedias_videos;
@property (assign) int feed_nbmedias_images;
@property (assign) int feed_nbmedias;
@property (nonatomic,retain) NSArray *Medias;

@property (nonatomic,retain) NsSnUserModel * User;

@end
