//
//  GCBluredImageSingleton.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 04/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCBluredImageSingleton.h"
#import "FXBlurView.h"
#import "UIImage+ImageEffects.h"

@implementation GCBluredImageSingleton
{
    NSMutableArray *arrayOfBluredImage;
}

+(GCBluredImageSingleton *)getInstance
{
    static GCBluredImageSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[GCBluredImageSingleton alloc] init];
    });
    return sharedMyManager;
}

#pragma mark - Bluring
-(void)blurMeThisImage:(UIImage *)imageToBlur onFrames:(NSArray *)framesToBlur andStoreItUsingKey:(NSString *)keyString cb_blur_completion:(void(^)(UIImageView* bluredImage, NSString *keyStorage))cb_blur_completion_
{
    if (!framesToBlur || [framesToBlur count] == 0)
    {
        DLog(@"Array of frames is empty");
        cb_blur_completion_(nil, keyString);
        return ;
    }
    
    NSMutableArray *arrayOfBlurredImage = [[NSMutableArray alloc] initWithCapacity:[framesToBlur count]];
    for (NSValue *valueRect in framesToBlur)
    {
        CGRect frameToBlur = [valueRect CGRectValue];
        if (!framesToBlur)
        {
            DLog(@"CGRect doesn't exist");
            continue;
        }
        UIImage *subImage = [GCBluredImageSingleton imageFromImage:imageToBlur withFrame:frameToBlur];
        if (!subImage){
            continue;
        }
        subImage = [subImage blurredImageWithRadius:40 iterations:2 tintColor:[UIColor blackColor]];
        [arrayOfBlurredImage addObject:subImage];
    }
    if ([framesToBlur count] != [arrayOfBlurredImage count])
    {
        DLog(@"Bad image array!");
        return ;
    }
    NSUInteger count = 0;
    for (UIImage *blurredImage in arrayOfBlurredImage)
    {
        imageToBlur = [GCBluredImageSingleton addImage:blurredImage toImage:imageToBlur inRect:[[framesToBlur objectAtIndex:count] CGRectValue]];
        count++;
    }
    
    [self storeIt:imageToBlur usingKey:keyString];
    
    if (cb_blur_completion_)
        cb_blur_completion_([[UIImageView alloc] initWithImage:imageToBlur], keyString);
}

-(void)blurMeThisImage:(UIImage *)imageToBlur onlyOnFrame:(CGRect)frameToBlur andStoreItUsingKey:(NSString *)keyString cb_blur_completion:(void(^)(UIImageView* bluredImage, NSString *keyStorage))cb_blur_completion_
{
    [self blurMeThisImage:imageToBlur onFrames:@[[NSValue valueWithCGRect:frameToBlur]] andStoreItUsingKey:keyString cb_blur_completion:cb_blur_completion_];
}

-(void)blurMeThisImage:(UIImage *)imageToBlur andStoreItUsingKey:(NSString *)keyString cb_blur_completion:(void(^)(UIImageView* bluredImage, NSString *keyStorage))cb_blur_completion_
{
    [self blurMeThisImage:imageToBlur onlyOnFrame:CGRectMake(0, 0, imageToBlur.size.width, imageToBlur.size.height) andStoreItUsingKey:keyString cb_blur_completion:cb_blur_completion_];
}

#pragma mark - Screenshot
+(UIImage *)takeScreenShotOfView:(UIView *)viewToShot
{
    CGSize sizeOfViewToShot = CGSizeMake(viewToShot.bounds.size.width, viewToShot.bounds.size.height);
    
    if ([NSObject isRetina])
        UIGraphicsBeginImageContextWithOptions(sizeOfViewToShot, YES, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(sizeOfViewToShot);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, 0);
    [viewToShot.layer renderInContext:context];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)imageFromImage:(UIImage *)originalImage withFrame:(CGRect)frameToCut
{
    CGFloat coef = [UIDevice isRetina] ? 2.0 : 1.0;
    frameToCut = CGRectMake(frameToCut.origin.x * coef, frameToCut.origin.y * coef, frameToCut.size.width * coef, frameToCut.size.height * coef);
    CGImageRef subImage  = CGImageCreateWithImageInRect(originalImage.CGImage, frameToCut);
    UIImage *cutImage = [UIImage imageWithCGImage:subImage];
    return cutImage;
}

+(UIImage *) addImage:(UIImage *)subImage toImage:(UIImage *)originalImage inRect:(CGRect)frame
{
    UIGraphicsBeginImageContext(originalImage.size);
    
    [originalImage drawInRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
    [subImage drawInRect:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) blendMode:kCGBlendModeCopy alpha:1.0];
    
    UIImage* result_img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result_img;
}

#pragma mark - Storage
-(void)storeIt:(UIImage *)image usingKey:(NSString *)key
{
    if (!arrayOfBluredImage)
        arrayOfBluredImage = [[NSMutableArray alloc] init];
    
    [arrayOfBluredImage addObject:@{key : image}];
}

#pragma mark - Extraction
-(UIImageView *) getMyBluredImageUsingKey:(NSString *)keyImage
{
    if (arrayOfBluredImage)
    {
        for (NSDictionary *keyImageViewStored in arrayOfBluredImage)
        {
            for (NSString *key in [keyImageViewStored allKeys])
            {
                if ([key isEqualToString:keyImage])
                {
                    NSData *archievedView = [NSKeyedArchiver archivedDataWithRootObject:[keyImageViewStored objectForKey:keyImage]];
                    UIImage *imgStored = [NSKeyedUnarchiver unarchiveObjectWithData:archievedView];
                    UIImageView *imageViewFromStoredImage = [[UIImageView alloc] initWithImage:imgStored];
                    return imageViewFromStoredImage;
                }
            }
        }
    }
    return  nil;
}

@end
