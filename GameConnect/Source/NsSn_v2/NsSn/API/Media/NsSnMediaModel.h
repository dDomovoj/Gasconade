//
//  NsSnMediaModel.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"

@interface NsSnMediaModel : NsSnModel


@property (nonatomic,retain) NSString *media_name;
@property (nonatomic,retain) NSString *media_original_name;
@property (nonatomic,retain) NSString *media_jobid;
@property (nonatomic,retain) NSString *media_title;
@property (nonatomic,retain) NSArray *media_formats;
@property (assign) int media_nblike;
@property (nonatomic,retain) NSArray *Likes;
@property (assign) int media_nbcomments;
@property (nonatomic,retain) NSArray *Comments;
@property (nonatomic,retain) NSString *fk_user_id;
@property (nonatomic,retain) NSString *media_base;
@property (assign) int media_type;
@property (nonatomic,retain) NSString *media_prive;
@property (assign) int media_active;
@property (assign) int created_at;



@end
