//
//  UIItemViewSlide.m
//  traceSport
//
//  Created by bigmac on 16/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIItemViewSlide.h"
#import "Extends+Libs.h"


@implementation UIItemViewSlide
@synthesize view,delegate,pos;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	[super drawRect:rect];
    [delegate performSelector:@selector(draw_me:) withObject:self];
	NSLog(@"get view");
	if (!b){
		NSLog(@"create B");
		b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
	}
	[self addSubview:b];
	b.frame = self.bounds;
	[self sendSubviewToBack:b];
}

-(void)click:(id)sender{
	[delegate click:self];
}

- (void)dealloc
{
}


-(void)addMySubview:(UIView*)e{
	if ([e isKindOfClass:[UITableViewCell class]]){
		UIView *cv = [e.subviews objectAtIndex:1];
		
		[cv  addSubview:b];
		[cv  sendSubviewToBack:b];
 

	}
	[self addSubviewToBonce:e autoSizing:YES];
}
@end
