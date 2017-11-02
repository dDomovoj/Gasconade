//
//  UINotificationView.m
//  CANALProject
//
//  Created by bigmac on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UINotificationView.h"
#import "Extends+Libs.h"
@implementation UINotificationView
@synthesize lb_nb;
@synthesize v_view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		last = 0;
        self.hidden = YES;
        if (!v_view){
            [[NSBundle mainBundle] loadNibNamed:@"UINotificationView" owner:self options:nil];		 
        }
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		 self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect{
 // Drawing code
	 [super drawRect:rect];
//	 self.hidden = YES;
	 if (!v_view){
		 [[NSBundle mainBundle] loadNibNamed:@"UINotificationView" owner:self options:nil];		 
	 }

	 [self addSubviewToBonce:v_view];
	
	// [self setNb:4];
}

-(void)clear{
    last = -1;
    self.hidden = YES;
}

-(void)setNb:(int)nb{
	if (nb < 0){
		last = 0;
		[lb_nb bouingAppear:NO oncomplete:^{
			self.hidden = YES;
		}];
	}
	else if (nb == 0){
		last = 0;
        self.hidden = YES;
	}
    else {
		if (last > 0){
			last = last + nb;
			nb = last;
		}else {
			last = nb;
		}
		self.hidden = NO;
		lb_nb.text = [NSString stringWithFormat:@"%d",nb];
		[lb_nb bouingAppear:YES oncomplete:^{
		}];
	}
}

@end
