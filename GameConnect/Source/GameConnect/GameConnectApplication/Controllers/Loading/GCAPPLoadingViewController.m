//
//  GCAPPLoadingViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 15/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPLoadingViewController.h"
#import "GCBluredImageSingleton.h"
#warning ADD GC IMAGES
//#import "UIImage+AppImages.h"

@interface GCAPPLoadingViewController ()
{
    NSDictionary *userInfoForLoading;
    BOOL isLoading;
}
@end

@implementation GCAPPLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isLoading = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpLoading];
}

-(void)setBluredBackground
{
//    [self setBackgroundImage:[UIImage gameConnectMainBackgroundImage]];
}

-(void)makeCheck
{
    if (loading)
        [loading checkUpPlatform];
}

-(void)startLoading
{
    isLoading = YES;
    if (loading && loading.isViewLoaded)
        [loading startLoading];
}

-(void)endLoading
{
    isLoading = YES;
    if (loading && loading.isViewLoaded)
        [loading endLoading];
}

-(void)setUpLoading
{
    loading = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCLoadingVCIdentifier];
    [self.v_containerLoading addSubviewToBonce:loading.view autoSizing:YES];
    [self addChildViewController:loading];
    
    if (userInfoForLoading)
        [loading setLoadingData:userInfoForLoading];

    if (isLoading)
        [loading startLoading];
    else
        [loading stopLoader];
}

-(void)setLoadingData:(NSDictionary *)userInfo
{
    userInfoForLoading = userInfo;
    
    if (loading && loading.isViewLoaded)
        [loading setLoadingData:userInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
