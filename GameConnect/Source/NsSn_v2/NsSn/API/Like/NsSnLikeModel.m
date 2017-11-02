//
//  NsSnLikeModel.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnLikeModel.h"
#import "Extends+Libs.h"

@implementation NsSnLikeModel

-(NSDictionary*)toDictionary{
    return nil;
}
-(id) fromJSON:(NSDictionary*)data{
    /*self.fk_user_id = [data getXpathEmptyString:@"fk_user_id"];
    self.fk_user_login = [data getXpathEmptyString:@"fk_user_login"];
    self.user_avatar_url = [data getXpathEmptyString:@"user_avatar_url"];
    */
    self.User = [NsSnUserModel new];
    self.User._id = [data getXpathEmptyString:@"fk_user_id"];
    self.User.user_nickname = [data getXpathEmptyString:@"fk_user_login"];
//    self.User.user_avatar_name = [data getXpathEmptyString:@"user_avatar_name"];
    
    return self;
}
-(id) fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnLikeModel fromJSON:elt]];
    }];
    return ret;
}
+(id) fromJSON:(NSDictionary*)data{
    return [[NsSnLikeModel new] fromJSON:data];
}
+(id) fromJSONArray:(NSArray*)data{
    return [[NsSnLikeModel new] fromJSONArray:data];
}
-(BOOL)validate{
    return true;
}

@end
