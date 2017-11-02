//
//  GCAppSponsorsViewController.m
//  PSG_Stadium
//
//  Created by Sergey Dikovitsky on 10/18/16.
//  Copyright © 2016 Netcosports. All rights reserved.
//

#import "GCAppSponsorsViewController.h"
//#import "AppConstantsAndImports.h"

//#import "ConfigManager.h"
//#import "NetworkManager.h"
#import "GCFontManager.h"
#import "Extends+Libs.h"

#import <Masonry/Masonry.h>
//#import "PSGOneApp-Swift.h"

@interface GCAppSponsorsViewController ()

@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UIImageView *sponsorsImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) UIButton *openPartnersLinkButton;

@property (nonatomic) UIView *dimmingView;

@end

@implementation GCAppSponsorsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    self.scrollView = [UIScrollView new];

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    self.sponsorsImageView = [UIImageView new];
    self.sponsorsImageView.image = [UIImage imageNamed:@"gc_popup_sponsors"];
    [self.scrollView addSubview:self.sponsorsImageView];

    [self.sponsorsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@10);
    }];

    self.titleLabel = [UILabel new];

    self.titleLabel.font = [[GCFontManager getInstance] getFontBoldWithSize:18];
    self.titleLabel.text = NSLocalizedString(@"gc_popup_partner_title", nil);
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.scrollView addSubview:self.titleLabel];

    CGFloat xOffset = 10;
    CGFloat yOffset = 8;

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(xOffset));
        make.right.equalTo(@(-xOffset));
        make.width.equalTo(self.view).offset(-2 * xOffset);
        make.top.equalTo(self.sponsorsImageView.mas_bottom).offset(yOffset);
    }];

    self.contentLabel = [UILabel new];

    self.contentLabel.font = [[GCFontManager getInstance] getFontRegularWithSize:18];
    self.contentLabel.text = NSLocalizedString(@"gc_popup_partner_msg", nil);
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;

    [self.scrollView addSubview:self.contentLabel];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(yOffset);
        make.bottom.equalTo(@0);
    }];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"gc_close_popup"]forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:closeButton];

    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-8));
        make.size.equalTo(@40);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(8);
    }];
    
    self.openPartnersLinkButton = [UIButton new];
    [self.openPartnersLinkButton addTarget:self
                                    action:@selector(openParnersLink:)
                          forControlEvents:UIControlEventTouchUpInside];
    self.openPartnersLinkButton.titleLabel.font = [[GCFontManager getInstance] getFontRegularWithSize:20];
    [self.openPartnersLinkButton setTitle:NSLocalizedString(@"gc_text_btn_pmu_partnership", nil)
                                 forState:UIControlStateNormal];
    [self.openPartnersLinkButton setTitleColor:GC_BLUE_COLOR
                                      forState:UIControlStateNormal];
    self.openPartnersLinkButton.layer.borderWidth = 2.0f;
    self.openPartnersLinkButton.layer.borderColor = [GC_BLUE_COLOR CGColor];
    [self.view addSubview:self.openPartnersLinkButton];
    [self.openPartnersLinkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(30.0f);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.9);
        make.height.mas_equalTo(50.0f);
    }];
}

- (void)openParnersLink:(id)sender
{
    if (self.openParnersLink) {
        GCConfigModel *configModel = [ConfigManager instance].config.gameConnect;
        NSString *linkURLString;
        if ([WifiManager isInPSGStadium]) {
            linkURLString = configModel.pmuPSGWiFiWebsiteURLString;
        } else {
            linkURLString = configModel.pmuPartnershipURLString;
        }
        self.openParnersLink(linkURLString);
        [self close];
    }
}

- (void)presentOnViewController:(UIViewController *)viewController
{
    self.dimmingView = [UIView new];
    self.dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [viewController.view addSubview:self.dimmingView];
    [self.dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [viewController.view addSubview:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(viewController.view).multipliedBy(0.9);
        make.height.equalTo(viewController.view).multipliedBy(0.6);
        make.center.offset(0);
    }];
    [viewController addChildViewController:self];

    [self setHiddenState];
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setShownState];
                     } completion:nil];
}

- (void)close
{
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setHiddenState];
                     } completion:^(BOOL finished) {
                         [self.dimmingView removeFromSuperview];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

- (void)setHiddenState
{
    self.view.alpha = 0;
    self.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.dimmingView.alpha = 0;
}

- (void)setShownState
{
    self.view.alpha = 1;
    self.view.transform = CGAffineTransformIdentity;
    self.dimmingView.alpha = 1;
}

@end
