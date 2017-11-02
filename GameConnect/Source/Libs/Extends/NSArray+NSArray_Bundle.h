//
//  NSArray+NSArray_Bundle.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSArray_Bundle)
-(id)getObjectsType:(Class)my_class;
-(id)getObjectsType:(Class)my_class recursive:(BOOL)recursive;
@end
