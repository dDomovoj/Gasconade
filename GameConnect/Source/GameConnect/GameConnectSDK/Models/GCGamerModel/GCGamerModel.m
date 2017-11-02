//
//  GCUserModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCGamerModel.h"
#import "NsSnAvatarModel.h"

@implementation GCGamerModel

+(id)fromJSON:(NSDictionary *)data
{
    GCGamerModel *gamer = [[GCGamerModel alloc] init];
    if (data)
    {
        gamer._id = [data getXpathEmptyString:@"id"];
        gamer.login = [data getXpathEmptyString:@"nickname"];
        gamer.global_rank = [data getXpathInteger:@"global_rank"];
        gamer.global_score = [data getXpathInteger:@"global_score"];
        gamer.Avatar_formats = [NsSnAvatarModel fromJSONDictionary:[data getXpathNilDictionary:@"avatar_formats"]];
        gamer.date_update = 0;
    }
   return gamer;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCGamerModel fromJSON:elt]];
    }];
    return ret;
}

@end
