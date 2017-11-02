//
//  NSSharingMenu.h
//  SharingTest
//
//  Created by Mathieu Lanoy on 07/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSSharingMenuItem.h"
#import "NSShareMenuConfiguration.h"

@protocol NSSharingMenuDelegate;

@interface NSSharingMenu : UIView<NSSharingMenuItemDelegate>
{
    BOOL _isAnimating;
    NSInteger _flag;
    NSTimer *_timer;
    NSInteger nbAnim;
}

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, getter = isExpanding) BOOL expanding;

@property (nonatomic, weak) id<NSSharingMenuDelegate> delegate;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *highlightedImage;
@property (nonatomic, retain) UIImage *contentImage;
@property (nonatomic, retain) UIImage *highlightedContentImage;

@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat menuWholeAngle;
@property (nonatomic, assign) CGFloat expandRotation;
@property (nonatomic, assign) CGFloat closeRotation;

@property (nonatomic, assign) CGFloat expandStartScale;
@property (nonatomic, assign) CGFloat expandEndScale;
@property (nonatomic, assign) CGFloat closeStartScale;
@property (nonatomic, assign) CGFloat closeEndScale;
@property (nonatomic, assign) CGFloat animationDuration;

- (id)initWithFrame:(CGRect) frame items:(NSArray *)items;

- (id)initWithFrame:(CGRect)frame AtPoint:(CGPoint) point items:(NSArray *)items withConfig: (NSShareMenuConfiguration *) config;

@end

@protocol NSSharingMenuDelegate <NSObject>

- (void)NSSharingMenu:(NSSharingMenu *) menu didSelectIndex:(NSInteger) index;

@end