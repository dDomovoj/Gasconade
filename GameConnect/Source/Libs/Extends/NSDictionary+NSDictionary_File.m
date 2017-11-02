//
//  NSDictionary+NSDictionary_File.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSDictionary+NSDictionary_File.h"
#import "NSObject+NSObject_File.h"
#import "NSObject+NSObject_Tool.h"
#import "NSString+NSString_File.h"

//static NSMutableDictionary *NSDictionary_File = nil;
@implementation NSDictionary (NSDictionary_File)


+(NSDictionary *) getDataFromFileCache:(NSString *)file temps:(int)temps del:(BOOL)del{
	NSString *dest = [file toiphonecache];
	if(del)
		[NSObject dateModifiedSort:dest temps:temps];
	NSDictionary *b = [NSKeyedUnarchiver unarchiveObjectWithFile:dest] ;
	return b;
}
-(void) setDataSaveNSDictionaryCache:(NSString*)file {
	NSString *dest = [file toiphonecache];
	if ([[self allKeys] count])
		[NSKeyedArchiver archiveRootObject:self toFile:dest];
}

+(NSDictionary *) getDataFromFile:(NSString *)file temps:(int)temps {
	NSString *dest = [file toiphonedoc];
	[NSObject dateModifiedSort:dest temps:temps];
	NSDictionary *b = [NSKeyedUnarchiver unarchiveObjectWithFile:dest] ;
	return b;
}

-(void) setDataSaveNSDictionary:(NSString*)file {
	NSString *dest = [file toiphonedoc];
	if ([[self allKeys] count]){
		[NSKeyedArchiver archiveRootObject:self toFile:dest];
	}
}

-(void)emptyFileNamed:(NSString *)file{
	NSString *dest = [file toiphonedoc];
	[NSKeyedArchiver archiveRootObject:nil toFile:dest];
}



- (NSMutableDictionary *)dictionaryByMergingDictionary:(NSDictionary*)d {
	NSMutableDictionary *mutDict = [self mutableCopy];
	[mutDict addEntriesFromDictionary:d];
	return mutDict;
}



@end
