//
//  FacebookComposeSheetView.h
//  FbProto
//
//  Created by Mathieu Lanoy on 06/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FacebookComposeSheetviewDelegate;

@interface FacebookComposeSheetView : UIView{
    
}

@property (readonly, nonatomic) UIView *attachmentView;
@property (readonly, nonatomic) UIImageView *attachmentImageView;
@property (weak, readwrite, nonatomic) UIViewController <FacebookComposeSheetviewDelegate> *delegate;
@property (readonly, nonatomic) UINavigationItem *navigationItem;
@property (readonly, nonatomic) UINavigationBar *navigationBar;
@property (readonly, nonatomic) UIView *textViewContainer;
@property (readonly, nonatomic) UITextView *textView;

@end

@protocol FacebookComposeSheetviewDelegate <NSObject>

- (void)cancelButtonPressed;
- (void)postButtonPressed;

@end
