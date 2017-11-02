//
//  NsSnMessageModel.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"
#import "NsSnUserModel.h"

typedef enum {
    NsSnMessageContentUnknow,
    NsSnMessageContentImage,
    NsSnMessageContentIcal,
    NsSnMessageContentMessage
    
} NsSnMessageContentType;

@interface NsSnMessageContentModel : NsSnModel<NSCoding>
@property (assign, nonatomic) NsSnMessageContentType    type;
@property (strong, nonatomic) NSString                  *message;
@property (strong, nonatomic) UIImage                   *img_image;
@property (strong, nonatomic) NSString                  *image;
@property (strong, nonatomic) NSString                  *image_big_url;
@property (strong, nonatomic) NSString                  *image_original_url;
@property (strong, nonatomic) NSString                  *ical;
@property (strong, nonatomic) NSString                  *ical_id;
@end

@interface NsSnMessageModel : NsSnModel<NSCoding>
@property (strong, nonatomic) NSString                  *_id;
@property (strong, nonatomic) NSString                  *thread_id;
@property (strong, nonatomic) NsSnMessageContentModel   *content;
@property (strong, nonatomic) NSArray                   *to;
@property (strong, nonatomic) NsSnUserModel             *from;

-(NSDictionary*)toDictionaryPost;
-(BOOL)isOneOfDest:(NSString *)userId;
@end




