//
//  NSArray+NSArray_FastEnum.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSArray_FastEnum)
-(void)each:(void(^)(NSInteger index, id elt, BOOL last))call;
-(BOOL)eachBreak:(BOOL(^)(NSInteger index, id elt, BOOL last))call;
@end
