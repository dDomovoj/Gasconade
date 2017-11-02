//
//  UIItemViewSlide.h
//  traceSport
//
//  Created by bigmac on 16/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIItemViewSlideDelegate <NSObject>

-(void)draw_me:(id)sender;
-(void)click:(id)sender;

@end

@interface UIItemViewSlide : UIView {
    UIView *view;
	__weak id<UIItemViewSlideDelegate> delegate;
	NSInteger pos;
	UIButton *b;
}
@property (nonatomic,assign) NSInteger pos;
@property (nonatomic, weak) id<UIItemViewSlideDelegate> delegate;
@property (nonatomic, strong) UIView *view;

-(void)addMySubview:(UIView*)e;
@end
