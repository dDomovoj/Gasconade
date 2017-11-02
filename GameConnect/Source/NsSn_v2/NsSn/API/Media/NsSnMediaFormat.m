//
//  NsSnMediaFormat.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnMediaFormat.h"
#import "Extends+Libs.h"

@implementation NsSnMediaFormat


-(NSDictionary*)toDictionary{
    return nil;
}
-(id) fromJSON:(NSDictionary*)data{
    self.size = [data getXpathEmptyString:@"size"];
    self.profil_name = [data getXpathEmptyString:@"profil_name"];
    self.ext = [data getXpathEmptyString:@"ext"];
    self.media_base = [data getXpathEmptyString:@"media_base"];
    
    return self;
}
-(id) fromJSONArray:(NSDictionary*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnMediaFormat fromJSON:elt]];
    }];
    return ret;
}
+(id) fromJSON:(NSDictionary*)data{
    return [[NsSnMediaFormat new] fromJSON:data];
}
+(id) fromJSONArray:(NSDictionary*)data{
    return [[NsSnMediaFormat new] fromJSONArray:data];
}
-(BOOL)validate{
    return true;
}
@end
