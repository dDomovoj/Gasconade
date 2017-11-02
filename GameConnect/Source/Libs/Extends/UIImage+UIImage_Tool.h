//
//  UIImage+UIImage_Tool.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Tool)

-(UIImage *)crop:(CGRect)rect;
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur; // 0.0 < 1.0
- (UIImage *) normalize ;
+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius;

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)width;
+ (UIImage *)imageWithImage:(UIImage *)image withSize:(CGSize)newSize;
+ (UIImage *)resizableImage:(NSString *)imageName withCapInsets:(UIEdgeInsets)capInsets;
+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor;
+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor verticalOffSet:(int)verticalOffSet;
+ (UIImage *)resizableUIImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage*)loadImageFromFile:(NSString *)fileName inTime:(int)time;
- (void)saveImageInFile:(NSString *)fileName;

@end
