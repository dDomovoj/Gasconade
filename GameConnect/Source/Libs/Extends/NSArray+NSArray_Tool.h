//
//  NSArray+NSArray_Tool.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    NSCategoryDiffCompNotFound,
    NSCategoryDiffCompEqual,
    NSCategoryDiffCompUpdate
} NSCategoryDiffComp;

@interface NSArray (NSArray_Tool)

+(NSArray *) getDataFromFile:(NSString *)file temps:(int)temps;
-(void) setDataSaveNSArray:(NSString*)file ;
-(void)setDataSaveNSArrayEmptyFileNamed:(NSString *)file;


-(BOOL)diffForNewArrayElement:(NSArray*)newArray comp:(NSCategoryDiffComp(^)(id itemOld, id itemNew))comp complete:(void(^)(BOOL changed, NSArray *remove, NSArray *insert, NSArray *update))completed;
-(BOOL)diffForNewArrayItem:(NSArray *)newArray section:(NSInteger)section comp:(NSCategoryDiffComp(^)(id itemOld, id itemNew))comp complete:(void(^)(BOOL changed, NSArray *remove, NSArray *insert, NSArray *update))completed;

-(NSArray *) sortAlphabeticallyArrayOfObjectUsing:(NSString *)key isAsc:(BOOL)asc;

@end



@interface NSArray (Reverse)

- (NSArray *)reversedArray;

@end


@interface NSMutableArray (Save)

+(NSMutableArray *) getDataFromFile:(NSString *)file temps:(int)temps;
-(void) setDataSaveNSArray:(NSString*)file ;
-(void)setDataSaveNSArrayEmptyFileNamed:(NSString *)file;

@end



@interface NSMutableArray (Reverse)

- (void)reverseMutableArray;

@end