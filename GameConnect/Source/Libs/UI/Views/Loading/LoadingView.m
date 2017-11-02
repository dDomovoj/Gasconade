//
//  LoadingView.m
//  Formul1
//
//  Created by Édouard Richard on 16/04/10.
//  Copyright 2010 Netco Sports. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

#ifndef LOADING_ALPHA
#define LOADING_ALPHA 1
#endif

#ifndef LOADING_TEXT_COLOR_R
#define LOADING_TEXT_COLOR_R 1
#endif

#ifndef LOADING_TEXT_COLOR_G
#define LOADING_TEXT_COLOR_G 1
#endif

#ifndef LOADING_TEXT_COLOR_B
#define LOADING_TEXT_COLOR_B 1
#endif

#ifndef LOADING_VIEW_COLOR_R
#define LOADING_VIEW_COLOR_R 0
#endif

#ifndef LOADING_VIEW_COLOR_G
#define LOADING_VIEW_COLOR_G 0
#endif

#ifndef LOADING_VIEW_COLOR_B
#define LOADING_VIEW_COLOR_B 0
#endif


@implementation LoadingView

@synthesize view;
@synthesize theText;
@synthesize delegateView = _delegateView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        theText = @"";
    }
    return self;
}

-(void)show
{
	view.hidden = NO;
    if (theText && ![theText isEqualToString:@""])
        lb_loading.text = theText;
    if ([lb_loading.text isEqualToString:@""])
        lb_loading.text = NSLocalizedString(@"Chargement", @"");
	if (!added)
    {
        self.frame = _delegateView.frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
		[_delegateView addSubview:self];
		added = FALSE;
	}
}

-(void)hide
{
	view.hidden = YES;
}

-(void)setText:(NSString *)str
{
	theText = str;
}

- (void)drawRect:(CGRect)rect
{
	lb_loading.text = NSLocalizedString(@"Chargement..", @"");
	if ([theText isKindOfClass:[NSString class]] && ![theText isKindOfClass:[NSNull class]] && [theText length] > 0)
		lb_loading.text = theText;
    
	lb_loading.textColor = [[UIColor alloc] initWithRed:LOADING_TEXT_COLOR_R green:LOADING_TEXT_COLOR_G blue:LOADING_TEXT_COLOR_B alpha:1.0];
    
    view.layer.cornerRadius = 5;
	[view setAlpha:LOADING_ALPHA];
    //[view setBackgroundColor:[UIColor blackColor]];

    [view setBackgroundColor:[[UIColor alloc] initWithRed:LOADING_VIEW_COLOR_R green:LOADING_VIEW_COLOR_G blue:LOADING_VIEW_COLOR_B alpha:0.99]];
}

- (void)dealloc
{
//	[theText release];
//	[view release];
//	[lb_loading release];
//    [super dealloc];
}


@end
