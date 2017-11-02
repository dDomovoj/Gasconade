//
//  NSSharingMenu.m
//  SharingTest
//
//  Created by Mathieu Lanoy on 07/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NSSharingMenu.h"
#import "Extends+Libs.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

static CGFloat const defaultNearRadius = 75.0f;
static CGFloat const defaultEndRadius = 80.0f;
static CGFloat const defaultFarRadius = 85.0f;
static CGFloat const defaultStartPointX = 110.0f;
static CGFloat const defaultStartPointY = 240.0f;
//static CGFloat const defaultExpandPointX = 0.0f;
//static CGFloat const defaultExpandPointY = 0.0f;
static CGFloat const defaultTimeOffset = 0.0f;
static CGFloat const defaultRotateAngle = DEGREES_TO_RADIANS(-50.0f);
static CGFloat const defaultMenuWholeAngle = DEGREES_TO_RADIANS(150.0f);
static CGFloat const defaultExpandRotation = M_PI * 2;
static CGFloat const defaultCloseRotation = M_PI * 2;

static CGPoint rotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);
}

@interface NSSharingMenu ()

@property(strong, nonatomic) NSSharingMenuItem* addButton;

- (void) expand;

- (void) close;

- (void) setMenu;

- (CAAnimationGroup *) blowUpAnimationAtPoint:(CGPoint) point;

- (CAAnimationGroup *) shrinkAnimationAtPoint:(CGPoint) point;

@end

@implementation NSSharingMenu

@synthesize nearRadius = _nearRadius, endRadius = _endRadius, farRadius = _farRadius, timeOffset = _timeOffset, rotateAngle = _rotateAngle, menuWholeAngle = _menuWholeAngle, startPoint = _startPoint, expandRotation = _expandRotation, closeRotation = _closeRotation, addButton = _addButton;
@synthesize expanding = _expanding;
@synthesize delegate = _delegate;
@synthesize items = _items;

- (id)initWithFrame:(CGRect)frame items:(NSArray *) items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		nbAnim = 0;
		self.nearRadius = defaultNearRadius;
		self.endRadius = defaultEndRadius;
		self.farRadius = defaultFarRadius;
		self.timeOffset = defaultTimeOffset;
		self.rotateAngle = defaultRotateAngle;
		self.menuWholeAngle = defaultMenuWholeAngle;
		self.startPoint = CGPointMake(defaultStartPointX, defaultStartPointY);
        self.expandRotation = defaultExpandRotation;
        self.closeRotation = defaultCloseRotation;
        
        self.items = items;
        
        // add the "Add" Button.
        _addButton = [[NSSharingMenuItem alloc] initWithImage:nil
                                             highlightedImage:nil
                                                 ContentImage:nil
                                      highlightedContentImage:nil
                                                   forNetwork:nil];
        _addButton.delegate = self;
        _addButton.center = self.startPoint;
        [self addSubview:_addButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AtPoint:(CGPoint) point items:(NSArray *)items withConfig:(NSShareMenuConfiguration *)config
{
    self = [self initWithFrame:frame items:items];
    if (!config)
    {
        config = [[NSShareMenuConfiguration alloc] init];
    }
    self.nearRadius = config.nearRadius;
    self.endRadius = config.endRadius;
    self.farRadius = config.farRadius;
    self.rotateAngle = config.rotateAngle;
    self.menuWholeAngle = config.menuWholeAngle;
    self.expandStartScale = config.expandStartScale;
    self.expandEndScale = config.expandEndScale;
    self.closeStartScale = config.closeStartScale;
    self.closeEndScale = config.closeEndScale;
    self.animationDuration = config.animationDuration;
    
    if (self) {
        self.startPoint = point;
        self.expanding = YES;
    }
    return self;
}

- (void)setStartPoint:(CGPoint) point
{
    _startPoint = point;
    _addButton.center = point;
}

- (void)setImage:(UIImage *)image
{
	_addButton.image = image;
}

- (UIImage*)image
{
	return _addButton.image;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
	_addButton.highlightedImage = highlightedImage;
}

- (UIImage*)highlightedImage
{
	return _addButton.highlightedImage;
}


- (void)setContentImage:(UIImage *)contentImage
{
	_addButton.contentImageView.image = contentImage;
}

- (UIImage*)contentImage
{
	return _addButton.contentImageView.image;
}

- (void)setHighlightedContentImage:(UIImage *)highlightedContentImage
{
	_addButton.contentImageView.highlightedImage = highlightedContentImage;
}

- (UIImage*)highlightedContentImage
{
	return _addButton.contentImageView.highlightedImage;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_isAnimating)
    {
        return NO;
    }
    if (YES == _expanding)
    {
        return YES;
    }
    else
    {
        return CGRectContainsPoint(_addButton.frame, point);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.expanding = !self.isExpanding;
}

- (void) NSSharingMenuItemTouchesBegan:(NSSharingMenuItem *)item
{
    if (item == _addButton)
    {
        self.expanding = !self.isExpanding;
    }
}

- (void) NSSharingMenuItemTouchesEnd:(NSSharingMenuItem *)item
{
    if (item == _addButton)
    {
        return;
    }
    CAAnimationGroup *blowup = [self blowUpAnimationAtPoint:item.center];
    [item.layer addAnimation:blowup forKey:@"blowup"];
    item.center = item.startPoint;
    
    for (int i = 0; i < [self.items count]; i++)
    {
        NSSharingMenuItem *currentItem = [self.items objectAtIndex:i];
        CAAnimationGroup *shrink = [self shrinkAnimationAtPoint:currentItem.center];
        if (currentItem.tag == item.tag) {
            continue;
        }
        [currentItem.layer addAnimation:shrink forKey:@"shrink"];
        
        currentItem.center = currentItem.startPoint;
    }
    _expanding = NO;
    
    if ([_delegate respondsToSelector:@selector(NSSharingMenu:didSelectIndex:)])
    {
        [_delegate NSSharingMenu:self didSelectIndex:item.tag - 1000];
    }
}

- (void)setItems:(NSArray *) items
{
    if (items == self.items)
    {
        return;
    }
    _items = items;
    
    for (UIView *view in self.subviews)
    {
        if (view.tag >= 1000)
        {
            [view removeFromSuperview];
        }
    }
}


- (void) setMenu {
	NSInteger count = [self.items count];
    for (NSInteger i = 0; i < count; i ++)
    {
        //int offset = count;
        NSInteger offset = count == 1 ? count : count - 1;
        NSSharingMenuItem *item = [self.items objectAtIndex:i];
        item.tag = 1000 + i;
        item.startPoint = self.startPoint;
        CGPoint endPoint = CGPointMake(self.startPoint.x + self.endRadius * sinf(i * self.menuWholeAngle / offset), self.startPoint.y - self.endRadius * cosf(i * self.menuWholeAngle / offset));
        item.endPoint = rotateCGPointAroundCenter(endPoint, self.startPoint, self.rotateAngle);
        CGPoint nearPoint = CGPointMake(self.startPoint.x + self.nearRadius * sinf(i * self.menuWholeAngle / offset), self.startPoint.y - self.nearRadius * cosf(i * self.menuWholeAngle / offset));
        item.nearPoint = rotateCGPointAroundCenter(nearPoint, self.startPoint, self.rotateAngle);
        CGPoint farPoint = CGPointMake(self.startPoint.x + self.farRadius * sinf(i * self.menuWholeAngle / offset), self.startPoint.y - self.farRadius * cosf(i * self.menuWholeAngle / offset));
        item.farPoint = rotateCGPointAroundCenter(farPoint, self.startPoint, self.rotateAngle);
        item.center = item.startPoint;
        item.delegate = self;
		[self insertSubview:item belowSubview:_addButton];
    }
}

- (BOOL) isExpanding
{
    return _expanding;
}

- (void)setExpanding:(BOOL)expanding
{
	if (expanding) {
		[self setMenu];
	}
	
    _expanding = expanding;
    
    if (!_timer)
    {
        _flag = self.isExpanding ? 0 : ([self.items count] - 1);
        SEL selector = self.isExpanding ? @selector(expand) : @selector(close);
        
        
        _timer = [NSTimer timerWithTimeInterval:self.timeOffset target:self selector:selector userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _isAnimating = YES;
    }
}

- (void) expand
{
	
    if (_flag == [self.items count])
    {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSInteger tag = 1000 + _flag;
    NSSharingMenuItem *item = (NSSharingMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.expandStartScale, self.expandStartScale, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.expandEndScale, self.expandEndScale, 1)];
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:scaleAnimation, positionAnimation, nil];
    animationgroup.duration = self.animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Expand"];

    item.center = item.endPoint;
    _flag++;
}

- (void) close
{
    if (_flag == -1)
    {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSInteger tag = 1000 + _flag;
    NSSharingMenuItem *item = (NSSharingMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:self.closeRotation],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.closeStartScale, self.closeStartScale, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.closeEndScale, self.closeEndScale, 1)];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, rotateAnimation, nil];
    animationgroup.duration = self.animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    [UIView animateWithDuration:0.70f animations:^{
        item.alpha = 0.0f;
    }];
    _flag--;
}

- (CAAnimationGroup *) blowUpAnimationAtPoint:(CGPoint) point
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.delegate = self;
    animationgroup.fillMode = kCAFillModeForwards;
    
    for (NSSharingMenuItem *item in self.items)
    {
        [UIView animateWithDuration:0.3 animations:^{
            item.alpha = 0.0f;
        }];
    }
    return animationgroup;
}

- (CAAnimationGroup *) shrinkAnimationAtPoint:(CGPoint) point
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSSharingMenuItem *first = [self.items objectAtIndex:0];
    if (theAnimation == [first.layer animationForKey:@"Close"])
    {
        [first removeFromSuperview];
        NSMutableArray *mut_items = [self.items ToUnMutable];
        [mut_items removeObjectAtIndex:0];
        self.items = [mut_items ToUnMutable];
        nbAnim++;
        if (nbAnim == [self.items count])
        {
            [self removeFromSuperview];
        }
    } else {
        [self removeFromSuperview];
    }
}

@end
