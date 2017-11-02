//
//  GCFontManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 ** Default Fonts for GCFontManager
 */
#ifndef FONTULTRALIGHT
#define FONTULTRALIGHT @"HelveticaNeue-UltraLight"
#endif

#ifndef FONT
#define FONT @"HelveticaNeue-Light"
#endif

#ifndef FONTREGULAR
#define FONTREGULAR @"HelveticaNeue"
#endif

#ifndef FONTMEDIUM
#define FONTMEDIUM @"HelveticaNeue-Medium"
#endif

#ifndef FONTBOLD
#define FONTBOLD @"HelveticaNeue-Bold"
#endif

#ifndef FONTITALIC
#define FONTITALIC @"HelveticaNeue-Italic"
#endif

@interface GCFontManager : NSObject

@property (strong, nonatomic) NSString *mainFontUltraLight;
@property (strong, nonatomic) NSString *mainFont;
@property (strong, nonatomic) NSString *mainFontRegular;
@property (strong, nonatomic) NSString *mainFontMedium;
@property (strong, nonatomic) NSString *mainFontBold;
@property (strong, nonatomic) NSString *mainFontItalic;

+(GCFontManager *) getInstance;
-(UIFont *) getFontUltraLightWithSize:(CGFloat)size;
-(UIFont *) getFontWithSize:(CGFloat)size;
-(UIFont *) getFontRegularWithSize:(CGFloat)size;
-(UIFont *) getFontMediumWithSize:(CGFloat)size;
-(UIFont *) getFontBoldWithSize:(CGFloat)size;
-(UIFont *) getFontItalicWithSize:(CGFloat)size;

- (UIFont *)alternateFontWithSize:(CGFloat)size;

@end
