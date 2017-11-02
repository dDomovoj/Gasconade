//
//  GCView.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCView : UIView

+ (instancetype)instanceFromNib;

-(void) myInit;

-(void) startLoader;
-(void) startLoaderInView:(UIView *)viewLoading_;
-(void) startLoaderInView:(UIView *)viewLoading_ andHideView:(BOOL)hideView_;

-(void) stopLoader;
-(void) stopLoaderInView:(UIView *)viewLoading_;
-(void) stopLoaderInView:(UIView *)viewLoading andShowView:(BOOL)showView_;

-(void) setLoaderStyle:(UIActivityIndicatorViewStyle)indicatorViewStyle;
-(void) setLoaderColor:(UIColor *)colorLoader;

@end
