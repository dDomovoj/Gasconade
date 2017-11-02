//
//  NSString+NSString_File.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSString+NSString_File.h"
#import "NSObject+NSObject_File.h"

@implementation NSString (NSString_File)


static NSString *toiphonedoc_toiphonecache=nil;
-(NSString*)toiphonecache{
	if (toiphonedoc_toiphonecache == nil){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		toiphonedoc_toiphonecache = paths[0];
	}
	//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = toiphonedoc_toiphonecache;// [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:self];
}


static NSString *toiphonedoc_toiphonetmp=nil;
-(NSString*)toiphonetmp{
	if (toiphonedoc_toiphonetmp == nil){
		/*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		toiphonedoc_toiphonetmp = paths[0];
        toiphonedoc_toiphonetmp = [toiphonedoc_toiphonetmp url]
        documentsDirectory = [toiphonedoc_toiphonetmp stringByAppendingPathComponent:@"tmp"];
         */
        NSString *tmpDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        tmpDir = [[tmpDir stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"tmp"];
        toiphonedoc_toiphonetmp = tmpDir;
	}
	//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = toiphonedoc_toiphonetmp;// [paths objectAtIndex:0];
	
	return [documentsDirectory stringByAppendingPathComponent:self];
}


static NSString *toiphonedoc_toiphonedoc=nil;
-(NSString*)toiphonedoc{
	if (toiphonedoc_toiphonedoc == nil){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		toiphonedoc_toiphonedoc = paths[0];
	}
	//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = toiphonedoc_toiphonedoc;// [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:self];
}

-(void)emptyStringFileNamed:(NSString *)file{
	NSString *dest = [file toiphonedoc];
	[NSKeyedArchiver archiveRootObject:@"" toFile:dest];
}

+(NSString *) getDataFromFile:(NSString *)file temps:(int)temps{
	NSString *dest = [file toiphonedoc];
	NSString *b = [NSKeyedUnarchiver unarchiveObjectWithFile:dest];
	if (b)
		[NSObject dateModifiedSort:dest temps:temps];
	return b;
}
-(void) setDataSave:(NSString*)file {
	NSString *dest = [file toiphonedoc];
	BOOL ret = [NSKeyedArchiver archiveRootObject:self toFile:dest];
	if (!ret){
#if TARGET_IPHONE_SIMULATOR
		NSLog(@"not save");
#endif
	}
}

-(BOOL)isFileExist{
    NSFileManager *FileManager = [NSFileManager defaultManager];
    BOOL file_existe = [FileManager fileExistsAtPath:self];
    return file_existe;
}
@end
