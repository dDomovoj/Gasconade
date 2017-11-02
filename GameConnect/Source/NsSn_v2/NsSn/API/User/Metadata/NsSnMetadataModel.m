//
//  NsSnMetadataModel.m
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnMetadataModel.h"
#import "Extends+Libs.h"

@implementation NsSnMetadataModel

-(void) fromJSON:(NSDictionary*)data{
    self.key = [data getXpathEmptyString:@"key"];
    self.value = [data getXpathEmptyString:@"value"];
}

+(NsSnMetadataModel*) fromJSON:(NSDictionary*)data{
    NsSnMetadataModel *meta = [NsSnMetadataModel new];
    [meta fromJSON:data];
    return meta;
}

+(id) fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnMetadataModel fromJSON:elt]];
    }];
    return ret;
}


@end
