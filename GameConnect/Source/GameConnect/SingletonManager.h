//
//  SingletonManager.h
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 4/20/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SingletonManagerInstance <NSObject>

@optional
+ (instancetype)sharedManager;

@end

@interface SingletonManager : NSObject <SingletonManagerInstance>

#define CREATE_INSTANCE                                 \
+ (instancetype)sharedManager {                         \
\
static id singletonManager = nil;                   \
static dispatch_once_t onceToken;                   \
dispatch_once(&onceToken, ^{                        \
singletonManager = [[self alloc] init];         \
});                                                 \
\
return singletonManager;                            \
}

@end
