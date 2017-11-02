//
//  GCContainerViewController.m
//  GameConnect
//
//  Created by Dmitry Duleba on 11/1/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCContainerViewController.h"
#import "GCConfManager.h"
#import "GCFontManager.h"
#import "GCGamerManager.h"
#import "NsSnConfManager.h"
#import "GCPlatformConnection.h"

@interface GCContainerViewController ()

@property (nonatomic, strong) UIViewController *navigationViewController;

@end

@implementation GCContainerViewController

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor blueColor];
  if (_navigationViewController == nil) {
    return;
  }

  [self addChildViewController:_navigationViewController];
  [self.view addSubview:_navigationViewController.view];
}

- (BOOL)prefersStatusBarHidden { return NO; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation { return  UIStatusBarAnimationSlide; }
- (BOOL)shouldAutorotate { return  YES; }
- (UIInterfaceOrientationMask)supportedInterfaceOrientations { return UIInterfaceOrientationMaskPortrait; }

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  _navigationViewController.view.frame = self.view.bounds;
}

#pragma mark - Private

- (UIViewController *)createNavigationViewController {
  [[GCConfManager getInstance] initialize];
  GCFontManager *fontManager = [GCFontManager getInstance];
  if (fontManager) {
    //      fontManager.mainFont = Fonts.Unica.regular.rawValue
    //      fontManager.mainFontUltraLight = Fonts.Unica.light.rawValue
    //      fontManager.mainFontRegular = Fonts.Unica.regular.rawValue
    //      fontManager.mainFontMedium = fontManager.mainFontRegular
    //      fontManager.mainFontItalic = fontManager.mainFontRegular
    //      fontManager.mainFontBold = Fonts.Unica.bold.rawValue
  }

  [GCGamerManager getInstance];
  [NsSnConfManager getInstance].PREFERED_LANGUAGE = @"en"; // LanguageManager.language.value.code
  GCPlatformConnection *platformConnection = [GCPlatformConnection getInstance];
  if (platformConnection) {
    [platformConnection initialize];
    [platformConnection setGCMINIJAST_HOST:@"https://minijast-integration.netcodev.com"];
    [platformConnection setGCLEJ_URL:@"https://gc-integ.netcosports.com"];
    [platformConnection setNSAPI_URL:@"https://nsapi-integration.netcodev.com"];
    [platformConnection setNSAPI_CLIENT_ID:@"fcbff518-f044-407b-9e8f-c094307cabc2"];
    [platformConnection setNSAPI_CLIENT_SECRET:@"5624831fc0eb225efe3f71f25a7f6cb5402f84d9"];
  }

  //    guard let navigationManager = GCAPPNavigationManageriPhone.getInstance() else {
  //      return nil
  //    }
  //
  //    navigationManager.notificationManager.closeAllNotifications()
  //
  //    let storyboard = UIStoryboard(name: "GCAPP_iPhone", bundle: nil)
  //    guard let navigationController = storyboard.instantiateInitialViewController() as? GCAPPNavigationController else {
  //      return nil
  //    }
  //
  //    navigationManager.gameConnectNavigationController = navigationController
  //    navigationManager.initProcessDelegate()
  //    navigationManager.reset()
  //
  //    return navigationController
  return nil;
}

- (UIViewController *)controllerForPresenting {
  UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  if (!rootVC) {
    return nil;
  }
  return [self controllerForPresentingFrom:rootVC];
}

- (UIViewController *)controllerForPresentingFrom:(UIViewController *)viewController {
  UIViewController *presentedVC = [viewController presentedViewController];
  if (presentedVC) {
    return [self controllerForPresentingFrom:presentedVC];
  }
  UINavigationController *navigationController = (UINavigationController *)viewController;
  if ([navigationController isKindOfClass:[UINavigationController class]] && [navigationController topViewController]) {
    return [self controllerForPresentingFrom:[navigationController topViewController]];
  }
  UITabBarController *tabBarController = (UITabBarController *)viewController;
  if ([tabBarController isKindOfClass:[UITabBarController class]] && [tabBarController selectedViewController]) {
    return [self controllerForPresentingFrom:[tabBarController selectedViewController]];
  }
  return viewController;
}

@end
