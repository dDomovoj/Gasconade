//
//  NsSnFeedModel.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnFeedModel.h"
#import "Extends+Libs.h"
#import "NsSnCommentModel.h"
#import "NsSnLikeModel.h"
#import "NsSnMediaModel.h"


@implementation NsSnFeedModel

-(NSDictionary*)toDictionary{
    return nil;
}
-(id) fromJSON:(NSDictionary*)data{
    self._id = [data getXpathEmptyString:@"feed_id"];
    
    self.User = [NsSnUserModel new];
    self.User._id = [data getXpathEmptyString:@"feed_user_id"];
    self.User.user_nickname = [data getXpathEmptyString:@"feed_user_login"];
//    self.User.user_avatar_name = [data getXpathEmptyString:@"feed_user_avatar_name"];
    
    //self.feed_user_id = [data getXpathEmptyString:@"feed_user_id"];
    self.feed_to = [data getXpathEmptyString:@"feed_to"];
    self.feed_text = [data getXpathEmptyString:@"feed_text"];
    //self.feed_user_login = [data getXpathEmptyString:@"feed_user_login"];
    self.feed_to_login = [data getXpathEmptyString:@"feed_to_login"];
    self.feed_private = [data getXpathInteger:@"feed_private"];
    
    self.created_at = 0;
    NSNumber *createLong = [data getXpath:@"created_at" type:[NSNumber class] def:0];
    if (createLong > 0){
        float createInt = [createLong doubleValue] / 1000.0;
        self.created_at = (int)createInt;
    }
    self.feed_last_update = [data getXpathInteger:@"feed_last_update"];
    self.feed_client_id = [data getXpathInteger:@"feed_client_id"];
    self.feed_nblike = [data getXpathInteger:@"feed_nblike"];
    self.feed_nbmedias_videos = [data getXpathInteger:@"feed_nbmedias_videos"];
    self.feed_nbmedias_images = [data getXpathInteger:@"feed_nbmedias_images"];
    self.feed_nbmedias = [data getXpathInteger:@"feed_nbmedias"];
    self.feed_nbcomments = [data getXpathInteger:@"feed_nbcomments"];
    
    self.Likes = [NsSnLikeModel fromJSONArray:[data getXpathNilArray:@"Likes"]];
    self.Comments = [NsSnCommentModel fromJSONArray:[data getXpathNilArray:@"Comments"]];
    self.Medias = [NsSnMediaModel fromJSONArray:[data getXpathNilArray:@"Medias"]];

    
    return self;
}
-(id) fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnFeedModel fromJSON:elt]];
    }];
    return ret;
}
+(id) fromJSON:(NSDictionary*)data{
    return [[NsSnFeedModel new] fromJSON:data];
}
+(id) fromJSONArray:(NSArray*)data{
    return [[NsSnFeedModel new] fromJSONArray:data];
}
-(BOOL)validate{
    return true;
}


@end
