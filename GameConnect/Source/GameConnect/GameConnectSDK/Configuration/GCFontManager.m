//
//  GCFontManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "GCFontManager.h"

@implementation GCFontManager

#pragma Singleton
+(GCFontManager *) getInstance
{
    static GCFontManager *fontManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontManager = [[self alloc] init];
    });
    return fontManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.mainFontUltraLight = FONTULTRALIGHT;
        self.mainFont = FONT;
        self.mainFontRegular = FONTREGULAR;
        self.mainFontMedium = FONTMEDIUM;
        self.mainFontBold = FONTBOLD;
        self.mainFontItalic = FONTITALIC;
    }
    return self;
}

#pragma FONTS
-(UIFont *) getFontUltraLightWithSize:(CGFloat)size
{
    return [UIFont fontWithName:self.mainFontUltraLight size:size];
}

-(UIFont *) getFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:self.mainFont size:size];
}

-(UIFont *) getFontRegularWithSize:(CGFloat)size
{
    return [UIFont fontWithName:self.mainFontRegular size:size];
}

-(UIFont *) getFontMediumWithSize:(CGFloat)size
{
    return [UIFont fontWithName:self.mainFontMedium size:size];
}

-(UIFont *) getFontBoldWithSize:(CGFloat)size
{
    return [UIFont fontWithName:self.mainFontBold size:size];
}

-(UIFont *) getFontItalicWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:self.mainFontItalic size:size];
    if (font == nil && ([UIFontDescriptor class] != nil) && [self.mainFontItalic isEqualToString:@"HelveticaNeue-Italic"]) {
        font = (__bridge_transfer UIFont*)CTFontCreateWithName(CFSTR("HelveticaNeue-Italic"), size, NULL);
    }
    return font;
}

- (UIFont *)alternateFontWithSize:(CGFloat)size
{
  return [UIFont fontWithName:@"AlternateGothicFS-morespace-No3" size:size];
}


@end
