//
//  NSDictionary+NSDictionary_FastEnum.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSDictionary+NSDictionary_FastEnum.h"

@implementation NSDictionary (NSDictionary_FastEnum)
-(void)each:(void(^)(id key, id elt))call{
	for (id key in self) {
		id elt = self[key];
		call(key,elt);
	}
}
@end
