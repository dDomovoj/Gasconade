//
//  GCAPPMasterViewController.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 28/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCBluredImageSingleton.h"
#import "Extends+Libs.h"
//#import "GCLoggerManager.h"

#warning ADD GC IMAGES
//#import "UIImage+AppImages.h"

#define SCROLL_CONTENT_INSET_AUTO_MODIFIED YES

@interface GCAPPMasterViewController ()
{
    NSInteger indexLevel;
}

@property (nonatomic) UIBarButtonItem *barButtonItem;

@end

@implementation GCAPPMasterViewController

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
    
    [self setBackgroundImage:nil];
    [self setBluredBackground];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self handleAutomaticContentInsetAdjustement];
    [self trackingApp];

    [self setupNavigationBarAppIconImage];
    if (self.navigationController.viewControllers.count > 1) {
      [self setupBackButton];
    } else {
      [self setupNavigationBar];
    }
}


-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

-(void) setBackgroundImage:(UIImage *)image
{
    self.iv_background = [[UIImageView alloc] initWithImage:image];
    [self.view addSubviewToBonce:self.iv_background autoSizing:YES];
    [self.view sendSubviewToBack:self.iv_background];
}

#pragma mark - Tracking
-(void) trackingApp
{
//    [[GCLoggerManager getInstance] GCTagApp:NSStringFromClass(self.class)];
}

#pragma mark - OverWrite of Automatic Adjustement Content Inset on ScrollViews
-(void)handleAutomaticContentInsetAdjustement
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    indexLevel = 0;
    if (SCROLL_CONTENT_INSET_AUTO_MODIFIED)
        [self recursiveCheckView:self.view];
}

-(void)recursiveCheckView:(UIView *)parentView
{
    for (UIView *view in [parentView subviews])
    {
        if ([self checkViewAndModifyContentInset:view])
            return ;
        else
        {
            if (parentView.frame.origin.y == 0)
                [self recursiveCheckView:view];
        }
    }
}

-(BOOL)checkViewAndModifyContentInset:(UIView *)view
{
    if (view && [view isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView *)view;
        UIEdgeInsets contentInsets = scrollView.contentInset;

        [scrollView setContentInset:UIEdgeInsetsMake(64, contentInsets.left, contentInsets.bottom, contentInsets.right)];

        return TRUE;
    }
    return FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
