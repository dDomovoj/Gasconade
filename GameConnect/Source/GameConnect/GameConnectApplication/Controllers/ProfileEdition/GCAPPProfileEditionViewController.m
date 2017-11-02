//
//  GCAPPProfileEditionViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPProfileEditionViewController.h"
#import "Extends+Libs.h"
//#import "PSGOneApp-Swift.h"
@import Masonry;

@interface GCAPPProfileEditionViewController ()
@end

@implementation GCAPPProfileEditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GCLoginViewController *loginViewController = [GCLoginViewController new];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
    [loginViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(70);
    }];

    [loginViewController.gcLogoImageView setHidden:YES];
    [loginViewController.gcTitleLabel setHidden:YES];
    [loginViewController.gcSubtitleLabel setHidden:YES];

    __weak typeof(self) weakSelf = self;
    loginViewController.logoutSuccessAction = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
}

@end
