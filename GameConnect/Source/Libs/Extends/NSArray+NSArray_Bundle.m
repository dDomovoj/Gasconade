//
//  NSArray+NSArray_Bundle.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSArray+NSArray_Bundle.h"

@implementation NSArray (NSArray_Bundle)
-(id)getObjectsType:(Class)my_class{
	return [self getObjectsType:my_class recursive:YES];
}
-(id)getObjectsType:(Class)my_class recursive:(BOOL)recursive{
	for (id elt in self) {
		if ([elt isKindOfClass:my_class])
			return elt;
		if (recursive && [elt isKindOfClass:[NSArray class]])
			return [elt getObjectsType:my_class recursive:recursive];
	}
	return nil;
}
@end
