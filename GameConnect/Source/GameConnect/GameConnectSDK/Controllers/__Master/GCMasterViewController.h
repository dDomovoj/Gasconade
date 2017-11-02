//
//  GCMasterViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCMasterViewController : UIViewController
{
    NSTimeInterval timeOfAppearance;
}
@property (nonatomic, strong) UIImageView *iv_background;

-(NSTimeInterval) getTimeIntervalSinceIAmDisplayed;

- (void)setupNavigationBarAppIconImage;
- (void)setupNavigationBarBackgroundImage;
- (void)setupNavigationBar;
- (void)setupBackButton;

-(void) startLoader;
-(void) startLoaderInView:(UIView *)viewLoading_;
-(void) startLoaderInView:(UIView *)viewLoading_ andHideView:(BOOL)hideView_;

-(void) stopLoader;
-(void) stopLoaderInView:(UIView *)viewLoading_;
-(void) stopLoaderInView:(UIView *)viewLoading andShowView:(BOOL)showView_;

-(void) setFlashMessage:(NSString*)message_;
-(void) setBackgroundImage:(UIImage *)image;

@end
