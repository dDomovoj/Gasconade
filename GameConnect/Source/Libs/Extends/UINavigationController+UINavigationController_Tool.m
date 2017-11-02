//
//  UINavigationController+UINavigationController_Tool.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 07/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "UINavigationController+UINavigationController_Tool.h"
#import "NSObject+NSObject_Xpath.h"

@implementation UINavigationController (UINavigationController_Tool)

-(NSArray *) popToViewControllerClass:(Class)viewControllerClass animated:(BOOL)animated
{
    NSMutableArray *arrayOfPopViewControllers = [NSMutableArray new];
    
    for (UIViewController *viewController in self.viewControllers)
    {
        if (viewController && [viewController isKindOfClass:viewControllerClass])
        {
            [self popViewControllerAnimated:animated];
            return [arrayOfPopViewControllers ToUnMutable];
        }
        else
        {
            [arrayOfPopViewControllers addObject:viewController];
        }
    }
    return nil;
}

@end
