//
//  Extends+Libs.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#ifndef Extends_Extends_Libs_h
#define Extends_Extends_Libs_h


#import "NSObject+NSObject_Tool.h"
#import "NSObject+NSObject_File.h"
#import "NSObject+NSObject_Xpath.h"

#import "NSString+NSString_File.h"
#import "NSString+NSString_Tool.h"
#import "NSString+NSString_HTML.h"

#import "NSData+NSData_Tool.h"

#import "NSDictionary+NSDictionary_FastEnum.h"
#import "NSDictionary+NSDictionary_File.h"

#import "NSArray+NSArray_FastEnum.h"
#import "NSArray+NSArray_Bundle.h"
#import "NSArray+NSArray_Tool.h"

#import "CLLocation+CLLocation_Tool.h"

#import "UIColor+UIColor_Tool.h"

#import "UIImage+UIImage_Tool.h"

#import "UILabel+UILabel_Xpath.h"

#import "UIView+UIView_Tool.h"

#import "UIDevice+UIDevice_Tool.h"

#import "UILabel+UILabel_Tool.h"

#import "UIViewController+iPhone_iPad_Xib.h"

#import "UIApplication+UIApplication_data.h"

#import "UINavigationController+UINavigationController_Tool.h"

#endif



#ifdef DEBUG
#define DLog(...) NSLog(@"%s [line %d] : %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define ALog(...) NSLog(@"%s [line %d] : %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#endif

/*

 #import <QuartzCore/QuartzCore.h>
 #import <Accelerate/Accelerate.h>
 systemconf
 
*/