//
//  FacebookComposeViewController.h
//  FbProto
//
//  Created by Mathieu Lanoy on 06/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookComposeSheetView.h"
#import "FacebookComposeBackgroundView.h"

enum FacebookComposeResult {
    FacebookComposeCancelled,
    FacebookComposeResultPosted
};

typedef enum FacebookComposeResult FacebookComposeResult;

typedef void (^FacebookComposeViewControllerCompletionHandler)(FacebookComposeResult result);

@protocol FacebookComposeViewControllerDelegate;

@interface FacebookComposeViewController : UIViewController<FacebookComposeSheetviewDelegate>{
    
}

@property (copy, nonatomic) FacebookComposeViewControllerCompletionHandler completionHandler;
@property (weak, nonatomic) id <FacebookComposeViewControllerDelegate> delegate;
@property (assign, readwrite, nonatomic) NSInteger cornerRadius;

- (UINavigationItem *)navigationItem;
- (UINavigationBar *)navigationBar;
- (NSString *)text;
- (void)setText:(NSString *)text;

- (BOOL)hasAttachment;
- (void)setHasAttachment:(BOOL)hasAttachment;

- (UIImage *)attachmentImage;
- (void)setAttachmentImage:(UIImage *)attachmentImage;

@end

@protocol FacebookComposeViewControllerDelegate <NSObject>

- (void)composeViewController:(FacebookComposeViewController *)composeViewController didFinishWithResult:(FacebookComposeResult) result;

@end
