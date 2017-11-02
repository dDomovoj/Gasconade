//
//  NsSnCommentModel.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnCommentModel.h"
#import "Extends+Libs.h"
#import "NsSnLikeModel.h"

@implementation NsSnCommentModel


-(NSDictionary*)toDictionary{
    return nil;
}
-(id) fromJSON:(NSDictionary*)data{
    self.User = [NsSnUserModel new];
    self.User._id = [data getXpathEmptyString:@"fk_user_id"];
    self.User.user_nickname = [data getXpathEmptyString:@"fk_user_login"];
//    self.User.user_avatar_name = [data getXpathEmptyString:@"user_avatar_name"];

    
    self.comment_text = [data getXpathEmptyString:@"comment_text"];
    self.comment_xid = [data getXpathEmptyString:@"comment_xid"];
    
    self.comment_nblike = [data getXpathInteger:@"comment_nblike"];
    self.created_at = 0;
    NSNumber *createLong = [data getXpath:@"created_at" type:[NSNumber class] def:0];
    if (createLong > 0){
        float createInt = [createLong doubleValue] / 1000.0;
        self.created_at = (int)createInt;
    }

    self.Likes = [NsSnLikeModel fromJSONArray:[data getXpathNilArray:@"Likes"]];
    
    return self;
}
-(id) fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnCommentModel fromJSON:elt]];
    }];
    return ret;
}
+(id) fromJSON:(NSDictionary*)data{
    return [[NsSnCommentModel new] fromJSON:data];
}
+(id) fromJSONArray:(NSArray*)data{
    return [[NsSnCommentModel new] fromJSONArray:data];
}
-(BOOL)validate{
    return true;
}

@end
