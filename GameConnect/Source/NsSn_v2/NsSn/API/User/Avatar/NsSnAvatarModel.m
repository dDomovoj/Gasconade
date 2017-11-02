//
//  NsSnAvatarModel.m
//  StadeDeFrance
//
//  Created by Guillaume Derivery on 2/24/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "NsSnAvatarModel.h"
#import "Extends+Libs.h"

@implementation NsSnAvatarModel

-(void) fromJSON:(NSDictionary *)data{
    if (data){
        self.media_size = [data getXpathEmptyString:@"media_size"];
        self.mime_type = [data getXpathEmptyString:@"mime_type"];
        self.profile_name = [data getXpathEmptyString:@"profile_name"];
        self.size = [data getXpathInteger:@"size"];
        self.url = [data getXpathEmptyString:@"url"];
    }
}

-(void) fromJSON:(NSDictionary *)data withKey:(NSString *)key{
    if (data){
        self.profile_name = key;
        self.media_size = [data getXpathEmptyString:@"media_size"];
        self.mime_type = [data getXpathEmptyString:@"mime_type"];
        self.size = [data getXpathInteger:@"size"];
        self.url = [data getXpathEmptyString:@"url"];
    }
}

+(NsSnAvatarModel*) fromJSON:(NSDictionary *)data{
    NsSnAvatarModel *meta = [NsSnAvatarModel new];
    [meta fromJSON:data];
    return meta;
}

+(NsSnAvatarModel*) fromJSON:(NSDictionary *)data withKey:(NSString *)key{
    NsSnAvatarModel *meta = [NsSnAvatarModel new];
    [meta fromJSON:data withKey:key];
    return meta;
}

+(id) fromJSONArray:(NSArray *)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnAvatarModel fromJSON:elt]];
    }];
    return ret;
}

+(id) fromJSONDictionary:(NSDictionary *)data{
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[data count]];
    [data each:^(id key, id elt) {
        [ret addObject:[NsSnAvatarModel fromJSON:elt withKey:key]];
    }];
    return ret;
}


@end
