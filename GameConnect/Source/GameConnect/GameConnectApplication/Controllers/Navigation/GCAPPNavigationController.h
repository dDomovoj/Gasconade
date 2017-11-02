//
//  GCAPPNavigationViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 04/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAPPNavigationController : UINavigationController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

-(BOOL)isTransitioningViewController;

@end
