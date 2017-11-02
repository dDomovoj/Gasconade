//
//  NsSnTagModel.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NsSnModel.h"

@interface NsSnTagModel : NsSnModel
@property (nonatomic,retain) NSString *_id;
@property (nonatomic,retain) NSString *fk_user_id;
@property (nonatomic,retain) NSString *tag_name;
@property (nonatomic,retain) NSString *tag_image_url;
@property (nonatomic,retain) NSString *tag_image;
@property (nonatomic,retain) NSString *tag_image_name;
@property (nonatomic,retain) NSString *tag_desc;
@property (nonatomic,retain) NSString *tag_xid;
@property (nonatomic,retain) UIImage *upimg;

@property (assign) int tag_type;
@property (assign) int tag_nbinvites;
@property (assign) int tag_nbfeeds;
@property (assign) int created_at;
@property (assign) int tag_last_update;
@property (assign) int tag_private;
@property (assign) int tag_favorite;

@property (nonatomic,retain) NSArray *Pendings;

@end
