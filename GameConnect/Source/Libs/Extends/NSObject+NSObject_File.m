//
//  NSObject+NSObject_File.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSObject+NSObject_File.h"
#import "NSString+NSString_File.h"


@implementation NSObject (NSObject_File)

+(void)removeFileCache:(NSString*)filename{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:[filename toiphonecache] error:nil];
}

+(void)removeFileDoc:(NSString*)filename{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:[filename toiphonedoc] error:nil];
}

+(NSInteger) dateModifiedSort:(NSString *) file1 temps:(int)temps{
//    NSLog(@"dateModifiedSort => %@", file1);
    NSDictionary *attrs1 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:file1
                            error:nil];
	NSDate *a = attrs1[NSFileModificationDate];
	NSDate *b = [NSDate dateWithTimeIntervalSinceNow:-(temps)];
	if ([a compare:b]  == NSOrderedDescending || a == nil)
		return 0;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:file1 error:nil];
	return 1;
}



+(void)removeFileTmp:(NSString*)filename{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:[filename toiphonetmp] error:nil];
}

+(void)saveDataInTmp:(NSString*)filename data:(NSData*)data{
    NSString *file = [filename toiphonetmp];
	[NSKeyedArchiver archiveRootObject:data toFile:file];
}
+(NSData*)getDataInTmp:(NSString*)filename{
    NSString *file = [filename toiphonetmp];
	return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}


@end
