//
//  GCAPPNavigationViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 04/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPNavigationController.h"
#import "Extends+Libs.h"
//#import "PSGOneApp-Swift.h"
#import "GCAPPDefines.h"

@interface GCAPPNavigationController ()
{
    BOOL isInTransition;
}
@end

@implementation GCAPPNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isInTransition = NO;
    [self setUpCustomNavBar];

    [self disableInteractivePopGesture];
    self.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

-(void) setUpCustomNavBar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    self.view.backgroundColor = GC_BLUE_COLOR;
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)onClose
{
#warning UARENA
//    [[AppDelegate shared] closeGameConnect];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(BOOL)isTransitioningViewController
{
    if (self.visibleViewController && ([self.visibleViewController isBeingDismissed] ||  [self.visibleViewController isBeingPresented]))
    {
        return TRUE;
    }
    else if (self.topViewController && ([self.topViewController isBeingDismissed] ||  [self.topViewController isBeingPresented]))
    {
        return TRUE;
    }
    else
    {
        return isInTransition;
    }
}

#pragma mark - Interactive Navigration Pan Gesture
-(void)disableInteractivePopGesture
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
}

-(void)enableInteractivePopGesture
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Keyboard notifications
- (void)keyboardDidShow: (NSNotification *)notification
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark - Overwrite



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    isInTransition = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    isInTransition = NO;
}


#pragma mark - Rotation Management
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([UIDevice isIPAD])
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([UIDevice isIPAD])
    {
        if ((orientation == UIInterfaceOrientationLandscapeRight) ||
            (orientation == UIInterfaceOrientationLandscapeLeft))
            return YES;
    }
    else
    {
        if (orientation == UIInterfaceOrientationPortrait ||
            orientation == UIInterfaceOrientationPortraitUpsideDown)
            return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotate
{
#warning remove after add iPad version
    if ([UIDevice isIPAD]) {
        return NO;
    }
    
    return YES;
}

@end
