//
//  NSDictionary+NSDictionary_File.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary_File)
+(NSDictionary *) getDataFromFileCache:(NSString *)file temps:(int)temps del:(BOOL)del;
-(void) setDataSaveNSDictionaryCache:(NSString*)file;

+(NSDictionary *)getDataFromFile:(NSString *)file temps:(int)temps;
-(void)setDataSaveNSDictionary:(NSString*)file;
-(void)emptyFileNamed:(NSString *)file;
- (NSMutableDictionary *)dictionaryByMergingDictionary:(NSDictionary*)d;
@end
