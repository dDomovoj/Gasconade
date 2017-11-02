//
//  GCMasterViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCMasterViewController.h"
#import "OLGhostAlertView.h"
#import "Extends+Libs.h"
//#import "GCLoggerManager.h"
//#import "PSGOneApp-Swift.h"
#import "GCAPPDefines.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

#warning ADD GC IMAGES
#warning ADD GC MENU HANDLING
//#import "UIImage+AppImages.h"

//#import <LDSlideOverViewController/LDSlideOverViewController.h>
//#import <LDSlideOverViewController/UIViewController+LDSlideOverViewController.h>
//
//#import "SlideMenuViewController.h"

@interface GCMasterViewController ()
{
    UIActivityIndicatorView *myLoader;
}

@end

@implementation GCMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GC_BLUE_COLOR;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    timeOfAppearance = [[NSDate date] timeIntervalSince1970];
    [self trakingSDK];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationBarBackgroundImage];
    [self setupNavigationBar];
}

-(void)trakingSDK
{
//    [[GCLoggerManager getInstance] GCTag:NSStringFromClass(self.class)];
}

-(NSTimeInterval) getTimeIntervalSinceIAmDisplayed
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return now - timeOfAppearance;
}

-(void) setBackgroundImage:(UIImage *)image
{
    self.iv_background = [[UIImageView alloc] initWithImage:image];
    [self.view addSubviewToBonce:self.iv_background autoSizing:YES];
    [self.view sendSubviewToBack:self.iv_background];
}

-(void) startLoader
{
    [self startLoaderInView:self.view];
}

-(void)startLoaderInView:(UIView *)viewLoading_
{
    [self startLoaderInView:viewLoading_ andHideView:NO];
}

-(void) startLoaderInView:(UIView *)viewLoading_ andHideView:(BOOL)hideView_
{
    if (!myLoader)
    {
        myLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [myLoader setColor:CONFCOLORFORKEY(@"activity_loaders")];
    }
    else
        [myLoader removeFromSuperview];
    
    [myLoader setFrame:CGRectMake(viewLoading_.frame.origin.x + viewLoading_.frame.size.width/2 - myLoader.frame.size.width/2,
                                  viewLoading_.frame.origin.y + viewLoading_.frame.size.height/2 - myLoader.frame.size.height/2,
                                  myLoader.frame.size.width,
                                  myLoader.frame.size.height)];
    [myLoader startAnimating];
    [myLoader setAlpha:0.0f];
    if (viewLoading_.superview)
        [viewLoading_.superview addSubview:myLoader];
    else
        [self.view addSubview:myLoader];

    [UIView animateWithDuration:0.1 animations:^{
        [self->myLoader setAlpha:1.0f];
        if (hideView_)
            [viewLoading_ setAlpha:0.0f];
    } completion:^(BOOL finished) {
    }];
}

-(void) stopLoader
{
    [self stopLoaderInView:self.view];
}

-(void) stopLoaderInView:(UIView *)viewLoading_
{
    [self stopLoaderInView:viewLoading_ andShowView:NO];
}

-(void) stopLoaderInView:(UIView *)viewLoading andShowView:(BOOL)showView_
{
    [UIView animateWithDuration:0.2 animations:^{
        if (myLoader)
            [self->myLoader setAlpha:0.0f];
        if (showView_)
        {
            [viewLoading setHidden:NO];
            [viewLoading setAlpha:1.0f];
        }
    } completion:^(BOOL finished) {
        if (myLoader)
        {
            [self->myLoader stopAnimating];
            [self->myLoader removeFromSuperview];
        }
    }];
}

-(void)setFlashMessage:(NSString*)message_
{
	[NSObject mainThreadBlock:^{
		[[[OLGhostAlertView alloc] initWithTitle:message_] show];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Setup methods


- (void)setupNavigationBarAppIconImage
{
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:
//                                      [[UIImageView alloc] initWithImage:[UIImage navigationBarAppIconImage]]];
//    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)setupNavigationBarBackgroundImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:blank
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)setupNavigationBar
{
  UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [closeButton setImage:[UIImage imageNamed:@"close_button_icon_large"] forState:UIControlStateNormal];
  [closeButton addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
  closeButton.frame = CGRectMake(0, 0, 32, 32);
  UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
  self.navigationItem.rightBarButtonItems = @[closeBarButtonItem];
}

- (void)onClose
{
#warning should add callback?
//    [[AppDelegate shared] closeGameConnect];
}

- (void)actionMenu
{
//    [[self slideOverViewController] slideOpen];
}

#pragma mark -
#pragma mark Back button

- (void)setupBackButton
{
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage backButtonImage]
//                                                                           style:UIBarButtonItemStylePlain
//                                                                          target:self
//                                                                          action:@selector(backButonTap)];
}

- (void)backButonTap
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
