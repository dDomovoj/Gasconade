//
//  NSArray+NSArray_FastEnum.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSArray+NSArray_FastEnum.h"

@implementation NSArray (NSArray_FastEnum)
-(void)each:(void(^)(NSInteger index, id elt, BOOL last))call{
    NSInteger index = 0;
    NSInteger l = [self count];
	for (id e in self) {
		call(index, e, index == l-1);
        index++;
	}
}
-(BOOL)eachBreak:(BOOL(^)(NSInteger index, id elt, BOOL last))call{
    NSInteger index = 0;
    NSInteger l = [self count];
    BOOL stop = NO;
	for (id e in self) {
        stop = call(index, e, index == l-1);
        if(stop)
            break;
        index++;
	}
    return stop;
}

@end
