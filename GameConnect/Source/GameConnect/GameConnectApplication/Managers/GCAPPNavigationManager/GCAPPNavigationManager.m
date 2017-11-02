//
//  GCAPPNavigationManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPNavigationManager.h"
#import "GCAPPGameViewController.h"
#import "GCAPPPushInfoViewController.h"
#import "Extends+Libs.h"
//#import "PSGOneApp-Swift.h"

@implementation GCAPPNavigationManager

+(instancetype) getInstance
{
    static GCAPPNavigationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[[self class] alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.notificationManager = [[GCNotificationManager alloc] init];
        [self.notificationManager setMinimumY:64];
        
        priorityPushManager = [GCAPPNavigationPriorityPushManager new];
    }
    return self;
}

- (void)openGameConnect
{
    if (self.isWatchingGameConnect && self.isWatchingGameConnect()) {
        return;
    }
    [[AppDelegate shared] openGameConnect];
}

-(GCAPPNavigationController *) giveMeNavigationViewController
{
    return self.gameConnectNavigationController;
}

#pragma mark - Image Picker
-(void) GCDidRequestImagePickerFromViewController:(GCProfileEditionViewController *)profileEditionViewController
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO))
        return;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    
    temporaryProfileEdition = profileEditionViewController;
    
    if ([UIDevice isIPAD])
    {
        popover = nil;
        popover = [[UIPopoverController alloc] initWithContentViewController:mediaUI];
        popover.delegate = nil;
        [popover presentPopoverFromRect:[profileEditionViewController.bt_imageAvatarModification convertRect:profileEditionViewController.bt_imageAvatarModification.bounds toView:profileEditionViewController.view] inView:profileEditionViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [[self giveMeNavigationViewController] presentViewController:mediaUI animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice isIPAD]){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void) imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage)
            imageToUse = editedImage;
        else
            imageToUse = originalImage;
        
        if (temporaryProfileEdition)
            [temporaryProfileEdition setSelectedImageByUserAndUploadIt:imageToUse];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([UIDevice isIPAD]){
        [popover dismissPopoverAnimated:YES];
    }
    else{
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIPopoverControllerDelegate - iPad Image picker
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Sharing
-(void)shareWithItems:(NSArray *)itemsToShare fromSourceView:(UIView *)sourceView
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = sourceView;
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypeAddToReadingList,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypePrint,
                                                     UIActivityTypePostToWeibo];
    
    [[self giveMeNavigationViewController] presentViewController:activityViewController animated:YES completion:^{
    }];
}

- (void)pushWebViewControllerWithURLString:(NSString *)URLString pinToTopLayoutGuide:(BOOL)pinToTopLayoutGuide
{
    GCWebViewController *webViewController = [GCWebViewController new];
    webViewController.urlString = URLString;
    [[self giveMeNavigationViewController] pushViewController:webViewController animated:YES];
}

- (void)reset
{
    navigationControllerAuthentification = nil;
    loadingViewController = nil;
}

@end
