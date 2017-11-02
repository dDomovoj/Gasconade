//
//  FacebookNetwork.m
//  FbProto
//
//  Created by Mathieu Lanoy on 05/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//
#import <Social/Social.h>
#import "FacebookNetwork.h"
#import "FacebookComposeViewController.h"

NSString* const FACEBOOK_ID = @"facebook";
NSString *const FBSessionStateChangedNotification =
@"com.netcosports:FBSessionStateChangedNotification";

@interface FacebookNetwork ()

@property (strong, nonatomic) FBSession *session;

/**
 *  Method to share with Facebook via FBSession.
 *  TWTweet is used for previous versions
 *  than iOS6.
 */
- (void) shareUsingFBSession;

/**
 *  Method to share with Facebook via SLCompose.
 * SLCompose is used from iOS6.
 */
- (void) shareUsingSLCompose;
@end

@implementation FacebookNetwork

- (void) share
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending)
    {
        [self shareUsingFBSession];
    }
    else
    {
        [self shareUsingSLCompose];
    }
}
// ios 6
- (void) shareUsingSLCompose
{
    SLComposeViewController *socialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    if (self.item.title != nil)
        [socialComposer setTitle:self.item.title];
    if (self.item.desc != nil)
        [socialComposer setInitialText:self.item.desc];
    if (self.item.url != nil)
        [socialComposer addURL:[NSURL URLWithString:self.item.url]];
    if (self.item.image != nil)
        [socialComposer addImage:self.item.image];
	if (self.item.image_url != nil && [self.item.image_url length] != 0)
        [socialComposer addURL:[NSURL URLWithString:self.item.image_url]];
    [socialComposer setCompletionHandler:^(SLComposeViewControllerResult result){
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                [self completionResult:typeCanceled];
                break;
            case SLComposeViewControllerResultDone:
                [self completionResult:typeDone];
                break;
            default:
                [self completionResult:typeFailed];
                break;
        }
        //[self.controller dismissModalViewControllerAnimated:YES];
    }];
    [self.controller presentViewController:socialComposer animated:YES completion:nil];
}

- (void) shareUsingFBSession
{
    [self openSessionWithAllowLoginUI:YES];
}


// ios < 6
- (void) postOnFacebook
{
/*    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.controller
                                                                    initialText:self.item.desc
                                                                          image:self.item.image
                                                                            url:[NSURL URLWithString:self.item.url]
                                                                        handler:nil];
 */
     BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self.controller initialText:self.item.desc image:self.item.image url:[NSURL URLWithString:self.item.url] handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
        
    }];
    if (!displayedNativeDialog)
    {
        FacebookComposeViewController *composeViewController = [[FacebookComposeViewController alloc] init];
        composeViewController.hasAttachment = NO;
        composeViewController.text = self.item.desc;
        NSString *graphPath = @"me/feed";
        if (self.item.image)
        {
            composeViewController.hasAttachment = YES;
            composeViewController.attachmentImage = self.item.image;
            graphPath = @"me/photos";
        }
        // Service name
        UILabel *titleView          = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        titleView.font              = [UIFont boldSystemFontOfSize:17.0];
        titleView.textAlignment     = NSTextAlignmentCenter;
        titleView.backgroundColor   = [UIColor clearColor];
        titleView.textColor         = [UIColor whiteColor];
        titleView.text              = @"Facebook";
        composeViewController.navigationItem.titleView = titleView;
        composeViewController.navigationBar.tintColor = [UIColor colorWithRed:44.0/255.0 green:67.0/255.0 blue:136.0/255.0 alpha:1.0];
        composeViewController.completionHandler = ^(FacebookComposeResult result)
        {
            switch (result)
            {
                case FacebookComposeCancelled:
                {
                    [self completionResult:typeCanceled];
                    break;
                }
                case FacebookComposeResultPosted:
                {
                    [self performPublishAction:^{
                        NSMutableArray *keys = [[NSMutableArray alloc] init];
                        NSMutableArray *objects = [[NSMutableArray alloc] init];
                        if (self.item.image)
                        {
                            if (self.item.desc)
                            {
                                [keys addObject:@"name"];
                                [objects addObject:self.item.desc];
                            }
                            if (self.item.url)
                            {
                                [keys addObject:@"link"];
                                [objects addObject:self.item.url];
                            }
                            [keys addObject:@"source"];
                            [objects addObject:UIImagePNGRepresentation(self.item.image)];
                        }
                        else
                        {
                            if (self.item.app)
                            {
                                [keys addObject:@"name"];
                                [objects addObject:self.item.app];
                            }
                            if (self.item.url)
                            {
                                [keys addObject:@"link"];
                                [objects addObject:self.item.url];
                            }
                            if (self.item.desc)
                            {
                                [keys addObject:@"message"];
                                [objects addObject:self.item.desc];
                            }
                            if (self.item.title)
                            {
                                [keys addObject:@"title"];
                                [objects addObject:self.item.title];
                            }
							if (self.item.image_url)
                            {
                                [keys addObject:@"picture"];
                                [objects addObject:self.item.image_url];
                            }
                        }
                        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
                        [FBRequestConnection startWithGraphPath:graphPath
                                                     parameters:params
                                                     HTTPMethod:@"POST"
                                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                  if (!error)
                                                  {
                                                      [self completionResult:typeDone];
                                                  }
                                                  else
                                                  {
                                                      NSLog(@"error: domain = %@, code = %ld",
                                                                   error.domain, (long)error.code);
                                                      NSLog(@"error: %@", error);
                                                      [self completionResult:typeCanceled];
                                                  }
                                              }];
                    }];
                    break;
                }
                default:
                    break;
            }
        };
        [self.controller presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void) performPublishAction:(void (^)(void)) action {
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
/*        [FBSession.FBSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceEveryone
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                 }];*/
        
        [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:(FBSessionDefaultAudienceEveryone) completionHandler:^(FBSession *session, NSError *error) {
            if (!error) {
                action();
            }
        }];
    } else {
        action();
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                [self postOnFacebook];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            [self completionResult:typeFailed];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceEveryone
                                                 allowLoginUI:allowLoginUI
                                            completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

@end

