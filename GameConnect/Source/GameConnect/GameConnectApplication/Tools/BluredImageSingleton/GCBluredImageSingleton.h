//
//  GCBluredImageSingleton.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 04/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCBluredImageSingleton : NSObject

/*
 ** Singleton Pattern
 */
+(GCBluredImageSingleton *)getInstance;

/*
 ** Blur multiples frames on a same UImage
 ** and store it using a key
 */
-(void)blurMeThisImage:(UIImage *)imageToBlur onFrames:(NSArray *)framesToBlur andStoreItUsingKey:(NSString *)keyString cb_blur_completion:(void(^)(UIImageView* bluredImage, NSString *keyStorage))cb_blur_completion_;

/*
 ** Blur only on frame on an UImage
 ** and store it using a key
 */
-(void)blurMeThisImage:(UIImage *)imageToBlur onlyOnFrame:(CGRect)frameToBlur andStoreItUsingKey:(NSString *)keyString cb_blur_completion:(void(^)(UIImageView* bluredImage, NSString *keyStorage))cb_blur_completion_;

/*
 ** Blur the entire UImage
 ** and store it using a key
 */
-(void)blurMeThisImage:(UIImage *)imageToBlur andStoreItUsingKey:(NSString *)keyString cb_blur_completion:(void(^)(UIImageView* bluredImage, NSString *keyStorage))cb_blur_completion_;

/*
 ** Retrieve blured UImageView from previous UIImage using the Key
 */
-(UIImageView *) getMyBluredImageUsingKey:(NSString *)key;

@end
