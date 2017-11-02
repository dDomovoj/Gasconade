//
//  NSDictionary+NSDictionary_FastEnum.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary_FastEnum)
-(void)each:(void(^)(id key, id elt))call;
@end
