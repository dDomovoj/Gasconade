//
//  FacebookComposeBackgroundView.m
//  FbProto
//
//  Created by Mathieu Lanoy on 06/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import "FacebookComposeBackgroundView.h"

@implementation FacebookComposeBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    if (CGSizeEqualToSize(self.centerOffset, CGSizeZero) == NO) {
        center.x += self.centerOffset.width;
        center.y += self.centerOffset.height;
    }
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 0.0, 0.0, 0.7,
        0.0, 0.0, 0.0, 0.85 };
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
    CGFloat endRadius = [UIApplication sharedApplication].keyWindow.bounds.size.height / 2;
    CGContextDrawRadialGradient(currentContext, gradient, center, 20.0f, center, endRadius, options);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)setCenterOffset:(CGSize)offset
{
    if (CGSizeEqualToSize(_centerOffset, offset) == NO) {
        _centerOffset = offset;
        [self setNeedsDisplay];
    }
}


@end
