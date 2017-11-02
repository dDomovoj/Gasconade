//
//  NsSnSubscribeModel.m
//  Internacional
//
//  Created by adelskott on 26/09/13.
//  Copyright (c) 2013 Netcosport. All rights reserved.
//

#import "NsSnSubscribeModel.h"
#import "Extends+Libs.h"

@implementation NsSnSubscribeModel

-(void) fromJSON:(NSDictionary*)data{
    
    self.fk_tag_id = [data getXpathEmptyString:@"fk_tag_id"];
    self.user_avatar_url = [data getXpathEmptyString:@"user_avatar_url"]; // Not used in _v2
    self.fk_tag_name = [data getXpathEmptyString:@"fk_tag_name"];
    
    self.active = [data getXpathInteger:@"is_active"];
    self.favoris = [data getXpathInteger:@"is_favoris"];
    self.tag_type = [data getXpathInteger:@"tag_type"];
    self.pending = [data getXpathInteger:@"is_pending"];
}

+(NsSnSubscribeModel*) fromJSON:(NSDictionary*)data{
    NsSnSubscribeModel *user = [NsSnSubscribeModel new];
    [user fromJSON:data];
    return user;
}

+(id) fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnSubscribeModel fromJSON:elt]];
    }];
    return ret;
}


@end
