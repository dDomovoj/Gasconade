//
//  NSShareMenuItem.h
//  SharingTest
//
//  Created by Mathieu Lanoy on 07/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NSSharingMenuItemDelegate;

@interface NSSharingMenuItem : UIImageView

@property (nonatomic, retain, readonly) UIImageView *contentImageView;

@property (nonatomic) CGPoint startPoint;

@property (nonatomic) CGPoint endPoint;

@property (nonatomic) CGPoint nearPoint;

@property (nonatomic) CGPoint farPoint;

@property (strong, nonatomic) NSString *networkId;

@property (nonatomic, weak) id<NSSharingMenuItemDelegate> delegate;

- (id) initWithImage:(UIImage *) image
   highlightedImage:(UIImage *) highlightedImage
       ContentImage:(UIImage *) contentImage
highlightedContentImage:(UIImage *) highlightedContentImage
forNetwork: (NSString *) networkId;


@end

@protocol NSSharingMenuItemDelegate <NSObject>

- (void) NSSharingMenuItemTouchesBegan:(NSSharingMenuItem *) item;

- (void) NSSharingMenuItemTouchesEnd:(NSSharingMenuItem *) item;

@end
