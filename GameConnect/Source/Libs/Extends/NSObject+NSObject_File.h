//
//  NSObject+NSObject_File.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_File)


+(void)removeFileTmp:(NSString*)filename;
+(void)saveDataInTmp:(NSString*)filename data:(NSData*)data;
+(NSData*)getDataInTmp:(NSString*)filename;



+(void)removeFileCache:(NSString*)filename; // delete cache
+(void)removeFileDoc:(NSString*)filename; // delete cache
+(NSInteger) dateModifiedSort:(NSString *) file1 temps:(int)temps;

@end
