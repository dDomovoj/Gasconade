//
//  NSShareMenuItem.m
//  SharingTest
//
//  Created by Mathieu Lanoy on 07/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import "NSSharingMenuItem.h"

@implementation NSSharingMenuItem

@synthesize contentImageView = _contentImageView, startPoint = _startPoint, endPoint = _endPoint, nearPoint = _nearPoint, farPoint = _farPoint, delegate = _delegate;

#pragma mark - initialization & cleaning up
- (id)initWithImage:(UIImage *) image
   highlightedImage:(UIImage *) highlightedImage
       ContentImage:(UIImage *) contentImage
highlightedContentImage:(UIImage *) highlightedContentImage
forNetwork:(NSString *)networkId
{
    if (self = [super init])
    {
        self.image = image;
        self.highlightedImage = highlightedImage;
        self.networkId = networkId;
        self.userInteractionEnabled = YES;
        _contentImageView = [[UIImageView alloc] initWithImage:nil];
        _contentImageView.highlightedImage = highlightedContentImage;
        [self addSubview:_contentImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    float width = _contentImageView.image.size.width;
    float height = _contentImageView.image.size.height;
    _contentImageView.frame = CGRectMake(self.bounds.size.width / 2 - width / 2, self.bounds.size.height / 2 - height / 2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if ([_delegate respondsToSelector:@selector(NSSharingMenuItemTouchesBegan:)])
    {
        [_delegate NSSharingMenuItemTouchesBegan:self];
    }
    
}

- (CGRect) scaleRect:(CGRect) rect ratio:(float) n {
    return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint([self scaleRect:self.bounds ratio:2.0f], location))
    {
        self.highlighted = NO;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint([self scaleRect:self.bounds ratio:2.0f], location))
    {
        if ([_delegate respondsToSelector:@selector(NSSharingMenuItemTouchesEnd:)])
        {
            [_delegate NSSharingMenuItemTouchesEnd:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}

#pragma mark - instant methods
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [_contentImageView setHighlighted:highlighted];
}


@end
