//
//  UIColor+UIColor_Tool.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UIColor+UIColor_Tool.h"
#import "NSString+NSString_Tool.h"

@implementation UIColor (UIColor_Tool)

// Made by tamara nice one ;)
+(UIColor*)colorWithRGBString:(NSString*)rgbValue alpha:(float)alpha
{
    NSString *colorStr;
    if ([rgbValue isSubString:@"#"])
        colorStr = [rgbValue stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    else if (![rgbValue isSubString:@"0x"])
        colorStr = [NSString stringWithFormat:@"0x%@", rgbValue];
    else
        colorStr = rgbValue;
    NSScanner *scanner = [NSScanner scannerWithString:colorStr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]];
    unsigned int baseColor;
    [scanner scanHexInt:&baseColor];
    CGFloat red   = ((baseColor & 0xFF0000) >> 16) / 255.0f;
    CGFloat green = ((baseColor & 0x00FF00) >>  8) / 255.0f;
    CGFloat blue  =  (baseColor & 0x0000FF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(UIColor*)colorWithARGBString:(NSString *)strARGB{
    if (!strARGB || [strARGB length] != 8){
        return [UIColor blackColor];
    }
    NSString *strAlpha = [strARGB substringToIndex:2];
    NSString *strColor = [strARGB substringFromIndex:2];

    unsigned int outVal;
    NSScanner *scanner = [NSScanner scannerWithString:strAlpha];
    [scanner scanHexInt:&outVal];
    float alpha = (outVal * 1.0) / 255.0;
    return [UIColor colorWithRGBString:strColor alpha:alpha];
}

+(UIColor*)colorWithRGB:(int)rgbValue alpha:(float)alpha{
	return [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

+(UIColor*)colorWithRGB:(int)rgbValue {
	return [UIColor colorWithRGB:rgbValue alpha:1.0];
}

- (UIColor *)colorByDarkeningColor
{
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	CGFloat newComponents[4];
	
	size_t numComponents = CGColorGetNumberOfComponents([self CGColor]);
	
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0]*0.7;
			newComponents[1] = oldComponents[0]*0.7;
			newComponents[2] = oldComponents[0]*0.7;
			newComponents[3] = oldComponents[1];
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0]*0.7;
			newComponents[1] = oldComponents[1]*0.7;
			newComponents[2] = oldComponents[2]*0.7;
			newComponents[3] = oldComponents[3];
			break;
		}
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
	
	return retColor;
}

- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;
{
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	size_t numComponents = CGColorGetNumberOfComponents([self CGColor]);
	CGFloat newComponents[4];
	
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[0];
			newComponents[2] = oldComponents[0];
			newComponents[3] = newAlpha;
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[1];
			newComponents[2] = oldComponents[2];
			newComponents[3] = newAlpha;
			break;
		}
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
	
	return retColor;
}



@end
