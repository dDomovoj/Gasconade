//
//  NSString+NSString_File.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_File)

-(NSString*)    toiphonedoc;
-(NSString*)    toiphonecache;
-(NSString*)    toiphonetmp;
+(NSString *)   getDataFromFile:(NSString *)file temps:(int)temps;
-(void)         setDataSave:(NSString*)file;
-(void)         emptyStringFileNamed:(NSString *)file;
-(BOOL)         isFileExist;

@end
