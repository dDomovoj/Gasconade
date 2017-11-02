//
//  GCGCAPPGameViewControlleriPhone.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPGameViewControlleriPhone.h"
#import "GCAPPGameViewControlleriPhone+GCAPPUI.h"
#import "GCAPPGameViewControlleriPhone_Private.h"
#import "GCBluredImageSingleton.h"
#import "GCSponsorsManager.h"
#import "GCAPPNavigationManageriPhone.h"
#import "GCAppSponsorsViewController.h"
//#import "BaseNavigationController_iPhone.h"
//#import "WebViewController_iPhone.h"
//#import "PSGOneApp-Swift.h"

#import <GameConnect/GameConnect-Swift.h>
#import <Masonry/Masonry.h>

@interface GCAPPGameViewControlleriPhone()

@property (nonatomic) BOOL isDynamicsSetup;

@end

@implementation GCAPPGameViewControlleriPhone

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
    self.isDynamicsSetup = NO;

    self.iv_arrowRankingDragging = [UIImageView new];

    [self.v_containerRanking addSubview:self.iv_arrowRankingDragging];
    [self.iv_arrowRankingDragging mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(5));
    }];

    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.v_containerRanking addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@1);
    }];

    self.v_panGesture = [UIView new];
    [self.view addSubview:self.v_panGesture];
    self.v_panGesture.frame = self.v_containerRanking.frame;

    [self.view bringSubviewToFront:self.v_containerRanking];
    [self.view bringSubviewToFront:self.v_panGesture];
    [self.view bringSubviewToFront:self.sponsorsButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.isDynamicsSetup) {
        [self.v_containerRanking setFrame:CGRectMake(0,
                                                     self.view.frame.size.height - 99,
                                                     self.view.frame.size.width,
                                                     self.view.frame.size.height - [self navigationBarOffset] - 50)];

        [self setUpDynamicsForProfileView];
        self.isDynamicsSetup = YES;
    }
}
- (IBAction)onTapSponsors:(id)sender
{
    [[GCSponsorsManager sharedManager] postPixelRequest];

    GCAppSponsorsViewController *sponsorsViewController = [GCAppSponsorsViewController new];
    __weak __typeof(self) weakSelf = self;
    sponsorsViewController.openParnersLink = ^(NSString *URLString) {
        GCWebViewController *webViewController = [GCWebViewController new];
        webViewController.urlString = URLString;
        [weakSelf.navigationController pushViewController:webViewController animated:YES];
    };
    [sponsorsViewController presentOnViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self stopWatchers];
}

@end
