//
//  ExternalContent.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCExternalContent.h"
#import "Extends+Libs.h"

@implementation GCExternalContent

+(id) fromJSON:(NSDictionary*)data
{ return [[GCExternalContent alloc]init]; }

+(id) fromJSONArray:(NSArray *)data
{ return @[]; }

@end
