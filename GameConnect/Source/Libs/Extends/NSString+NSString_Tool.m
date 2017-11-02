//
//  NSString+NSString_Tool.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSString+NSString_Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>
#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>


@implementation NSString (NSString_Tool)

- (NSData *)obfuscatewithKey:(NSString *)key
{
	// Create data object from the string
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	
	// Get pointer to data to obfuscate
	char *dataPtr = (char *) [data bytes];
	
	// Get pointer to key data
	char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
	
	// Points to each char in sequence in the key
	char *keyPtr = keyData;
	int keyIndex = 0;
	
	// For each character in data, xor with current value in key
	for (int x = 0; x < [data length]; x++)
	{
		// Replace current character in data with
		// current character xor'd with current key value.
		// Bump each pointer to the next character
		*dataPtr = *dataPtr ^ *keyPtr;
		dataPtr++;
        keyPtr++;
		// If at end of key data, reset count and
		// set key pointer back to start of key value
		if (++keyIndex == [key length]){
			keyIndex = 0;
			keyPtr = keyData;
		}
        
	}
	
	return [NSData  dataWithData:data];
}

-(NSInteger)nbrOccurenceString:(NSString *)parse{
	int numberOfChar = -1;
	NSString *res = nil;
	NSScanner *mainScanner = [NSScanner scannerWithString:self];
	while (![mainScanner isAtEnd]) {
		[mainScanner scanUpToString:parse intoString:&res];
		numberOfChar++;
		[mainScanner scanString:parse intoString:nil];
	}
	if ([self isEqualToString:[NSString stringWithFormat:@"%@%@", res, parse]])
		numberOfChar++;
	return numberOfChar;
}

-(unsigned long)crc32{
    NSData *data = [self dataUsingEncoding:(NSUTF8StringEncoding)];
    uLong crc = crc32(0, NULL, 0);
    return crc32(crc, [data bytes], (uInt)[data length]);
}
-(NSString *) md5 {
	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	return [NSString
			
			stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			
			result[0], result[1],
			
			result[2], result[3],
			
			result[4], result[5],
			
			result[6], result[7],
			
			result[8], result[9],
			
			result[10], result[11],
			
			result[12], result[13],
			
			result[14], result[15]
			
			];
	
}

-(NSString*) sha1 /*:(NSString*)input*/
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG) data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *)sha1Hmac:(NSString *)key{
    NSString *data = self;
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    return hash;
}

-(NSRange) rangeOfSubString:(NSString *)search withOptions:(NSStringCompareOptions)mask
{
    if (!search)
        return NSMakeRange(NSNotFound, 0);
    else
        return [self rangeOfString:search options:mask];
}

/*
 ** This is not actually making a "isSubstring"
 ** Please use hasSubstring instead. It makes MORE SENSE :)
 */
-(BOOL) isSubString:(NSString*) search
{
    return [self hasSubstring:search];
}

-(BOOL) isSubStringOf:(NSString*) search
{
    return [search hasSubstring:self];
}

-(BOOL) isInsensitiveSubStringOf:(NSString *)search
{
    return [search hasInsensitiveSubString:self];
}

-(BOOL) hasSubstring:(NSString *)search
{
	if (!search)
		return  FALSE;
    else
    {
        NSRange rangeOfSubstring = [self rangeOfSubString:search withOptions:NSLiteralSearch];
        return  rangeOfSubstring.location == NSNotFound  ? FALSE : TRUE;
    }
}

-(BOOL) hasInsensitiveSubString:(NSString *)search
{
    if (!search)
        return FALSE;
    else
    {
        NSRange rangeOfSubstring = [self rangeOfSubString:search withOptions:NSCaseInsensitiveSearch];
        return  rangeOfSubstring.location == NSNotFound  ? FALSE : TRUE;
    }
}

-(NSInteger) indexOfSubString:(NSString*) search
{
	if (!search)
		return -1;
	NSRange r = [self rangeOfSubString:search withOptions:NSLiteralSearch];
	return r.location;
}

- (NSString*)strReplace:(NSString*)r to:(NSString*)t
{
	NSMutableString *str = [NSMutableString stringWithString:self];
	[ str replaceOccurrencesOfString:r
						  withString:t
							 options:0
							   range:NSMakeRange(0, [str length])
	 ];
	return str;
}


-(NSString *) urlencode{
    return [[NSString stringWithString:self] stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
}
-(NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(BOOL)isNotEqualToString:(NSString*)str{
	return ![self isEqualToString:str];
}

-(NSArray*)explode:(NSString*)sep{
	NSArray *words = [self componentsSeparatedByString:sep];
	return words;
}


-(id)StrTrFromData:(NSString*)from to:(NSString*)to{
	if ([self isKindOfClass:[NSString class]]){
		NSMutableString * s = [[NSMutableString alloc] init];
		[s appendString:[(NSString*)self strReplace:from to:to]];
		return s;
	}
	if ([self isKindOfClass:[NSArray class]]){
		NSArray *a = (NSArray *)self;
		NSMutableArray *ar = [[NSMutableArray alloc] init];
		for (id e in a) {
			id ee = [e StrTrFromData:from to:to];
			[ar addObject:ee];
		}
		return ar;
	}
	if ([self isKindOfClass:[NSDictionary class]]){
		NSDictionary *a = (NSDictionary *)self;
		NSMutableDictionary *ar = [[NSMutableDictionary alloc] init];
		for (id k in [a allKeys]) {
			id e = a[k];
			id ee = [e StrTrFromData:from to:to];
			id kk = [k StrTrFromData:from to:to];
			ar[kk] = ee;
		}
		return ar;
	}
	return self;
}

-(NSArray*)componentsMatchedByRegex:(NSString*)regex{
	NSRegularExpression* reg = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
	NSArray* imgBalises = [reg matchesInString:self options:0 range:NSMakeRange(0, [self length])];
	NSString* contentCopy = [self copy];
	NSMutableArray *ar = [NSMutableArray array];
	if ([imgBalises count])
		[ar addObject:[self copy]];
	for (NSTextCheckingResult* b in imgBalises){
		NSString* substr = [contentCopy substringWithRange:b.range];
		[ar addObject:substr];
	}
	return ar;
}

-(id)regexMatch:(NSString*)pattern{
	NSArray *links = [self componentsMatchedByRegex:pattern];
	if ([links count] <= 0)
		return nil;
	return links;
}

-(NSString *)ucfirst{
    if (!self || ![self isKindOfClass:[NSString class]] || [self length] < 1){
        return @"";
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[self substringToIndex:1] uppercaseString]];
}

-(NSString *)ucfirstlc{
    if (!self || ![self isKindOfClass:[NSString class]] || [self length] < 1){
        return @"";
    }
    NSString *str = [self lowercaseString];
    return [str stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[str substringToIndex:1] uppercaseString]];
}

+(BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (NSComparisonResult)compareToVersion:(NSString *)version
{
    NSArray *version1 = [self componentsSeparatedByString:@"."];
    NSArray *version2 = [version componentsSeparatedByString:@"."];
    
    for (int i = 0; i < MIN([version1 count], [version2 count]); i++)
    {
        NSInteger index1 = ([(NSString *)[version1 objectAtIndex:i] integerValue]);
        NSInteger index2 = ([(NSString *)[version2 objectAtIndex:i] integerValue]);
        if (index1 != index2)
        {
            if (index1 > index2)
                return NSOrderedDescending;
            else
                return NSOrderedAscending;
        }
    }
    
    if ([version1 count] == [version2 count])
        return NSOrderedSame;
    else if ([version1 count] > [version2 count])
        return NSOrderedDescending;
    else
        return NSOrderedAscending;
}

-(NSNumber *)toNumber{
    NSNumberFormatter *numberFormater = [[NSNumberFormatter alloc] init];
    [numberFormater setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [numberFormater numberFromString:self];
    return myNumber;
}
@end



@implementation NSMutableAttributedString (NSMutableAttributedString_BOLD)

-(void)setBold:(BOOL)bold range:(NSRange)range{
    return;
    NSAttributedString *sub = [self attributedSubstringFromRange:range];
    NSDictionary *attrs = [sub attributesAtIndex:0 effectiveRange:&range];
    UIFont *font = attrs[NSFontAttributeName];
    if (font){
        if ([font.fontName isSubString:@"-Bold"])
            return;
        NSString *fontName = [NSString stringWithFormat:@"%@-Bold", font.fontName];
        UIFont *fontBold = [UIFont fontWithName:fontName size:font.pointSize];
        [self setAttributes:@{NSFontAttributeName:fontBold} range:range];
    }
}

@end
