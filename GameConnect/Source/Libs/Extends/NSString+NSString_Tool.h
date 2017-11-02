//
//  NSString+NSString_Tool.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Tool)

-(NSData *) obfuscatewithKey:(NSString *)key;
-(NSInteger) nbrOccurenceString:(NSString *)parse;
-(NSString *) md5;
-(NSString *) sha1;
-(NSString *)sha1Hmac:(NSString *)key;
-(unsigned long)crc32;


/*!
 @abstract
 know if a string have a sub string in parametter
 
 @param search
 substring to search
 
 @discussion
 Non-sense, use hasSubstring instead.
 */
-(BOOL) isSubString:(NSString*) search;

-(BOOL) isSubStringOf:(NSString*) search;
-(BOOL) hasSubstring:(NSString *)search;

-(BOOL) isInsensitiveSubStringOf:(NSString *)search;
-(BOOL) hasInsensitiveSubString:(NSString *)search;
-(NSInteger) indexOfSubString:(NSString*) search;

-(NSString*) strReplace:(NSString*)r to:(NSString*)t;
-(NSString *) urlencode;
-(NSString*) trim;
-(NSArray*) explode:(NSString*)sep;
-(BOOL) isNotEqualToString:(NSString*)str;
-(id) StrTrFromData:(NSString*)from to:(NSString*)to;
-(NSArray*)componentsMatchedByRegex:(NSString*)regex;
-(id)regexMatch:(NSString*)pattern;
/**
 *  Make a string's first character uppercase
 *
 *  @return Result string
 */
-(NSString *)ucfirst;
/**
 *  Make a string's first character uppercase and the rest lowercase
 *
 *  @return Result string
 */
-(NSString *)ucfirstlc;
+(BOOL)validateEmail:(NSString *)candidate;

/**
 *  Compare two version strings with number(.number)? format
 *
 *  @param version Version to compare to
 *
 *  @return Comparison result
 */
- (NSComparisonResult)compareToVersion:(NSString *)version;

/*!
 @abstract
 Used to convert a string to a nsnumber
 
 @discussion
 Better use for big number such as facebook id
 */
-(NSNumber *)toNumber;
@end


@interface NSMutableAttributedString (NSMutableAttributedString_BOLD)


-(void)setBold:(BOOL)bold range:(NSRange)range;

@end
