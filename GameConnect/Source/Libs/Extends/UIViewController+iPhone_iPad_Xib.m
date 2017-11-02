//
//  UIViewController+UIViewController_iPhone_iPad_Xib.m
//  CAN 2013
//
//  Created by Jean-François GRANG on 31/10/12.
//  Copyright (c) 2012 Netco Sports. All rights reserved.
//

#import "UIViewController+iPhone_iPad_Xib.h"

@implementation UIViewController (iPhone_iPad_Xib)

/**
 * This method is used to add the _iPhone or _iPad to the Nib name depending on the targeted device.
 * Use this method only if you have both XIBs, otherwise, use initWithNibName:bundle:
 * @param nibNameOrNil, the nibName root if different from the class name
 * @param nibBundle, the bundle in which the nib name is, nil by defaut
 * @return the inited view controller with the appropriate XIB
 */

- (id)initWithNibNameForDevice:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    NSString *nibName = nibNameOrNil;
    NSString *deviceTypeNibName = nil;
    
    if (nibName == nil) {
        nibName = NSStringFromClass([self class]);
    }

    
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPhone:
            deviceTypeNibName = [NSString stringWithFormat:@"%@_%@", nibName, @"iPhone"];
            break;
        case UIUserInterfaceIdiomPad:
            deviceTypeNibName = [NSString stringWithFormat:@"%@_%@", nibName, @"iPad"];
            break;
        default:
            deviceTypeNibName = nibName;
            break;
    }

    return [self initWithNibName:deviceTypeNibName bundle:nibBundleOrNil];
}



@end
