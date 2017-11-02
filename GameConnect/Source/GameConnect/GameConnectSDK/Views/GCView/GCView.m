//
//  GCView.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCView.h"
#import "NSArray+NSArray_Bundle.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCView
{
    UIActivityIndicatorView *myLoader;
    UIActivityIndicatorViewStyle activityIndicatorViewStyle;
    UIColor *loaderColor;
}

+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] getObjectsType:self];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    loaderColor = nil;
}

-(void)layoutSubviews
{
    [self myInit];
}

-(void) myInit
{ }

-(void) startLoader
{
    [self startLoaderInView:self];
}

-(void)startLoaderInView:(UIView *)viewLoading_
{
    [self startLoaderInView:viewLoading_ andHideView:NO];
}

-(void) startLoaderInView:(UIView *)viewLoading_ andHideView:(BOOL)hideView_
{
    if (!myLoader)
    {
        myLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorViewStyle];
        if (loaderColor)
            [myLoader setColor:loaderColor];
        else
            [myLoader setColor:CONFCOLORFORKEY(@"activity_loaders")];
    }
    else
    {
        [myLoader removeFromSuperview];
        [myLoader setActivityIndicatorViewStyle:activityIndicatorViewStyle];
        if (loaderColor)
            [myLoader setColor:loaderColor];
        else
            [myLoader setColor:CONFCOLORFORKEY(@"activity_loaders")];
    }
    
    [myLoader setFrame:CGRectMake(viewLoading_.frame.origin.x + viewLoading_.frame.size.width/2 - myLoader.frame.size.width/2,
                                  viewLoading_.frame.origin.y + viewLoading_.frame.size.height/2 - myLoader.frame.size.height/2,
                                  myLoader.frame.size.width,
                                  myLoader.frame.size.height)];
    [myLoader startAnimating];
    [myLoader setAlpha:0.0f];
    [myLoader setHidden:NO];
    if (viewLoading_.superview)
    {
        [viewLoading_.superview addSubview:myLoader];
        [viewLoading_.superview bringSubviewToFront:myLoader];
    }
    else
    {
        [self addSubview:myLoader];
        [self bringSubviewToFront:myLoader];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [myLoader setAlpha:1.0f];
        if (hideView_)
            [viewLoading_ setAlpha:0.0f];
    } completion:^(BOOL finished) {
    }];
}

-(void) setLoaderStyle:(UIActivityIndicatorViewStyle)indicatorViewStyle
{
    if (myLoader)
    {
        [myLoader setActivityIndicatorViewStyle:indicatorViewStyle];
        if (loaderColor)
            [myLoader setColor:loaderColor];
        else
            [myLoader setColor:CONFCOLORFORKEY(@"activity_loaders")];
    }
    else
        activityIndicatorViewStyle = indicatorViewStyle;
}

-(void) setLoaderColor:(UIColor *)colorLoader
{
    if (myLoader)
        [myLoader setColor:colorLoader];
    else
        loaderColor = colorLoader;
}

-(void) stopLoader
{
    [self stopLoaderInView:self];
}

-(void) stopLoaderInView:(UIView *)viewLoading_
{
    [self stopLoaderInView:viewLoading_ andShowView:NO];
}

-(void) stopLoaderInView:(UIView *)viewLoading andShowView:(BOOL)showView_
{
    if (!myLoader)
        return ;
    
    [UIView animateWithDuration:0.2 animations:^{
        [myLoader setAlpha:0.0f];
        if (showView_)
            [viewLoading setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [myLoader stopAnimating];
        [myLoader removeFromSuperview];
        myLoader = nil;
    }];
}

@end
