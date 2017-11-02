//
//  GCModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCModel.h"

@implementation GCModel

+(id) fromJSON:(NSDictionary*)data
{
    return nil;
}

+(id) fromJSONArray:(NSArray*)data
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    GCModel *model = [[self class] allocWithZone:zone];
    return model;
}

@end
