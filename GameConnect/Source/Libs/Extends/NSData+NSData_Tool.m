//
//  NSData+NSData_Tool.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSData+NSData_Tool.h"

@implementation NSData (NSData_Tool)


-(BOOL)setDataSaveNSDataFile:(NSString*)fileAbsolu{
    NSFileManager *FileManager = [NSFileManager defaultManager];
	BOOL success = [FileManager createFileAtPath:fileAbsolu  contents:self attributes:nil];
	if(!success) {
		NSLog(@"Failed to copy : %@.",  fileAbsolu);
	}
    return success;
}

@end
