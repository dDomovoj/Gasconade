//
//  UINavigationController+UINavigationController_Tool.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 07/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (UINavigationController_Tool)

-(NSArray *) popToViewControllerClass:(Class)viewControllerClass animated:(BOOL)animated;

@end
