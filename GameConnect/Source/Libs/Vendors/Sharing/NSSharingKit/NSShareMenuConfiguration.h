//
//  NSShareMenuConfiguration.h
//  RenderSharingKit
//
//  Created by Céline Cheung on 06/01/13.
//  Copyright (c) 2013 Céline Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSShareMenuConfiguration : NSObject

@property (nonatomic) CGFloat nearRadius;
@property (nonatomic) CGFloat endRadius;
@property (nonatomic) CGFloat farRadius;
@property (nonatomic) CGFloat rotateAngle;
@property (nonatomic) CGFloat menuWholeAngle;
@property (nonatomic) CGFloat expandStartScale;
@property (nonatomic) CGFloat expandEndScale;
@property (nonatomic) CGFloat closeStartScale;
@property (nonatomic) CGFloat closeEndScale;
@property (nonatomic) CGFloat animationDuration;

@end
