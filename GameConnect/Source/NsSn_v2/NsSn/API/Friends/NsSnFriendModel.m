//
//  NsSnFriendModel.m
//  NsSn
//
//  Created by adelskott on 06/09/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnFriendModel.h"
#import "Extends+Libs.h"

@implementation NsSnFriendModel



-(NSDictionary*)toDictionary{
    return nil;
}


-(BOOL)validate{
    return NO;
}
-(void) fromJSON:(NSDictionary*)data{
    
    self._id = [data getXpathEmptyString:@"_id"];
    self.friend_level = [data getXpathInteger:@"friend_level"];
    self.friend_valide = [data getXpathInteger:@"friend_valide"];
         
    self.User = [NsSnUserModel fromJSON:[data getXpathNilDictionary:@"User"]];
}

+(NsSnFriendModel*) fromJSON:(NSDictionary*)data{
    NsSnFriendModel *friend = [NsSnFriendModel new];
    [friend fromJSON:data];
    return friend;
}


+(id) fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnFriendModel fromJSON:elt]];
    }];
    return ret;
}

 

@end
