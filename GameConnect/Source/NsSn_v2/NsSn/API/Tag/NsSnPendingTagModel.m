//
//  NsSnPendingTagModel.m
//  Internacional
//
//  Created by Guillaume Derivery on 12/2/13.
//  Copyright (c) 2013 Netcosport. All rights reserved.
//

#import "NsSnPendingTagModel.h"
#import "Extends+Libs.h"

@implementation NsSnPendingTagModel

-(void) fromJSON:(NSDictionary*)data
{
    if (data)
    {
        self._id = [data getXpathEmptyString:@"_id"];
        self.fk_user_id = [data getXpathEmptyString:@"fk_user_id"];
        self.fk_user_login = [data getXpathEmptyString:@"fk_user_login"];
        self.user_avatar_url = [data getXpathEmptyString:@"user_avatar_url"];
    }
}

+(NsSnPendingTagModel*) fromJSON:(NSDictionary*)data
{
    NsSnPendingTagModel *pending = [NsSnPendingTagModel new];
    [pending fromJSON:data];
    return pending;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last)
    {
        [ret addObject:[NsSnPendingTagModel fromJSON:elt]];
    }];
    return ret;
}

@end
