//
//  NSArray+NSArray_Tool.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSArray+NSArray_Tool.h"
#import "NSObject+NSObject_File.h"
#import "NSString+NSString_File.h"
#import "NSArray+NSArray_FastEnum.h"
#import <UIKit/UIKit.h>

@implementation NSArray (NSArray_Tool)

+(NSArray *) getDataFromFile:(NSString *)file temps:(int)temps{
	NSString *dest = [file toiphonedoc];
	[NSObject dateModifiedSort:dest temps:temps];
	NSArray *b = [NSKeyedUnarchiver unarchiveObjectWithFile:dest] ;
	return b;
}

-(void) setDataSaveNSArray:(NSString*)file {
	NSString *dest = [file toiphonedoc];
	if ([self count]){
		[NSKeyedArchiver archiveRootObject:self toFile:dest];
	}
}

-(void)setDataSaveNSArrayEmptyFileNamed:(NSString *)file{
	NSString *dest = [file toiphonedoc];
	[NSKeyedArchiver archiveRootObject:self toFile:dest];
}


-(BOOL)diffForNewArrayElement:(NSArray *)newArray comp:(NSCategoryDiffComp(^)(id itemOld, id itemNew))comp complete:(void(^)(BOOL changed, NSArray *remove, NSArray *insert, NSArray *update))completed{
    __block BOOL hasChange = NO;
    NSMutableArray  *remove = [NSMutableArray new];
    NSMutableArray  *update = [NSMutableArray new];
    NSMutableArray  *insert = [NSMutableArray new];
    
    [newArray each:^(NSInteger index, id elt, BOOL last) {
        BOOL stop = [self eachBreak:^BOOL(NSInteger index2, id elt2, BOOL last2) {
            NSCategoryDiffComp res = comp(self[index2], newArray[index]);
            if (res == NSCategoryDiffCompUpdate){
                [update addObject:elt];
                return YES;
            }
            if (res == NSCategoryDiffCompEqual) {
                return YES;
            }
            return NO;
        }];
        if (!stop)
            [insert addObject:elt];
    }];
    
    [self each:^void(NSInteger index, id elt, BOOL last) {
        BOOL stop = [newArray eachBreak:^BOOL(NSInteger index2, id elt2, BOOL last2) {
            NSCategoryDiffComp res = comp(self[index], newArray[index2]);
            if (res == NSCategoryDiffCompEqual || res == NSCategoryDiffCompUpdate){
                return YES;
            }
            return NO;
        }];
        if(!stop)
            [remove addObject:elt];
    }];
    hasChange = [remove count] > 0 || [insert count] > 0 || [remove count] > 0;
    completed(hasChange, remove, insert, update);
    return hasChange;
}


-(BOOL)diffForNewArrayItem:(NSArray *)newArray section:(NSInteger)section comp:(NSCategoryDiffComp(^)(id itemOld, id itemNew))comp complete:(void(^)(BOOL changed, NSArray *remove, NSArray *insert, NSArray *update))completed{
    __block BOOL hasChange = NO;
    NSMutableArray  *remove = [NSMutableArray new];
    NSMutableArray  *update = [NSMutableArray new];
    NSMutableArray  *insert = [NSMutableArray new];
    
    [newArray each:^(NSInteger index, id elt, BOOL last) {
        BOOL stop = [self eachBreak:^BOOL(NSInteger index2, id elt2, BOOL last2) {
            NSCategoryDiffComp res = comp(self[index], newArray[index2]);
            if (res == NSCategoryDiffCompUpdate){
                [update addObject:[NSIndexPath indexPathForItem:index inSection:section]];
                return YES;
            }
            if (res == NSCategoryDiffCompEqual) {
                return YES;
            }
            return NO;
        }];
        if (!stop)
            [insert addObject:[NSIndexPath indexPathForItem:index inSection:section]];
    }];
    
    [self each:^void(NSInteger index, id elt, BOOL last) {
        BOOL stop = [newArray eachBreak:^BOOL(NSInteger index2, id elt2, BOOL last2) {
            NSCategoryDiffComp res = comp(self[index2], newArray[index]);
            if (res == NSCategoryDiffCompEqual || res == NSCategoryDiffCompUpdate){
                return YES;
            }
            return NO;
        }];
        if(!stop)
            [remove addObject:[NSIndexPath indexPathForItem:index inSection:section]];
    }];
    hasChange = [remove count] > 0 || [insert count] > 0 || [remove count] > 0;
    completed(hasChange, remove, insert, update);
    return hasChange;
}

-(NSArray *) sortAlphabeticallyArrayOfObjectUsing:(NSString *)key isAsc:(BOOL)asc
{
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
    return [self sortedArrayUsingDescriptors:@[brandDescriptor]];
}

@end


@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end



@implementation NSMutableArray (Save)

+(NSMutableArray *) getDataFromFile:(NSString *)file temps:(int)temps{
	NSString *dest = [file toiphonedoc];
	[NSObject dateModifiedSort:dest temps:temps];
	NSMutableArray *b = [NSKeyedUnarchiver unarchiveObjectWithFile:dest] ;
	return b;
}

-(void) setDataSaveNSArray:(NSString*)file {
	NSString *dest = [file toiphonedoc];
	if ([self  count]){
		[NSKeyedArchiver archiveRootObject:self toFile:dest];
	}
}

-(void)setDataSaveNSArrayEmptyFileNamed:(NSString *)file{
	NSString *dest = [file toiphonedoc];
	[NSKeyedArchiver archiveRootObject:self toFile:dest];
}

@end




@implementation NSMutableArray (Reverse)

- (void)reverseMutableArray {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end