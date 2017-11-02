//
//  LoadingView.h
//  Formul1
//
//  Created by Édouard Richard on 16/04/10.
//  Copyright 2010 Netco Sports. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
{
	IBOutlet UIView *view;
	IBOutlet UILabel *lb_loading;
	IBOutlet UIView *delegateView;
	BOOL added;
	NSString *theText;
}

@property (nonatomic, strong) NSString *theText;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, weak) UIView *delegateView;

-(void)show;
-(void)hide;
-(void)setText:(NSString *)str;

@end
