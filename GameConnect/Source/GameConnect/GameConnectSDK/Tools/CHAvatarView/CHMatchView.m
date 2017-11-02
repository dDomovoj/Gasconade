//
//  CHMatchView.m
//
//  Created by Édouard RICHARD on 18.12.13
//  Copyright (c) 2013 Édouard RICHARD. All rights reserved.
//

#import "CHMatchView.h"
#import "Extends+Libs.h"
#import <QuartzCore/QuartzCore.h>

@implementation CHMatchView

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.7f;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect b = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);

    CGPathRef circlePath = CGPathCreateWithEllipseInRect(b, 0);
    CGMutablePathRef inverseCirclePath = CGPathCreateMutableCopy(circlePath);
    CGPathAddRect(inverseCirclePath, nil, CGRectInfinite);
    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
//        [_image drawInRect:b];
    } CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
        
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3.0f, [UIColor colorWithRed:0.994 green:0.989 blue:1.000 alpha:1.0f].CGColor);
        
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, inverseCirclePath);
        CGContextEOFillPath(ctx);
    } CGContextRestoreGState(ctx);
    
    CGPathRelease(circlePath);
    CGPathRelease(inverseCirclePath);
    
    CGContextRestoreGState(ctx);
}

-(void)setMyMatch:(NSDictionary *)match{
    self.match = match;
    [self.im_t1 getClubById:[self.match getXpathEmptyString:@"t1"]];
    [self.im_t2 getClubById:[self.match getXpathEmptyString:@"t2"]];
}

@end
