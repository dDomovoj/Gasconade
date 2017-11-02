//
//  GCColorManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef DEFAULT_COLOR
#define DEFAULT_COLOR @"ffffffff"
#endif

@interface GCColorManager : NSObject

+ (GCColorManager *) getInstance;
- (UIColor *) getColorForKey:(NSString *)key;
- (void)setColorForKey:(NSString *)key toObject:(id)obj;

@end
