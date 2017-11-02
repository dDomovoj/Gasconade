//
//  GCModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCModel : NSObject <NSCopying>

+(id) fromJSON:(NSDictionary*)data;
+(id) fromJSONArray:(NSArray*)data;

@end
