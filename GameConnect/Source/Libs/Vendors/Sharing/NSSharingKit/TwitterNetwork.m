//
//  TwitterNetwork.m
//  FbProto
//
//  Created by Mathieu Lanoy on 05/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "TwitterNetwork.h"

NSString* const TWITTER_ID = @"twitter";

@interface TwitterNetwork(Private)

/**
 *  Method to share with twitter via TWTweet.
 *  TWTweet is used for previous versions
 *  than iOS6.
 */
- (void) shareUsingTWTweet;

/**
 *  Method to share with twitter via SLCompose.
 * SLCompose is used from iOS6.
 */
- (void) shareUsingSLCompose;
@end

@implementation TwitterNetwork

- (void) share
{
     if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending)
     {
         [self shareUsingTWTweet];
     }
    else
    {
        [self shareUsingSLCompose];
    }
}

- (void) shareUsingTWTweet{
    SLComposeViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
//    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    if (self.item.image != nil)
        [tweetViewController addImage:self.item.image];
    if (self.item.desc != nil)
    {
        NSString *format    = @"%@";
        if (self.item.url != nil)
            [tweetViewController addURL:[NSURL URLWithString:self.item.url]];
        NSUInteger idx = self.item.desc.length;
        while([self.item.desc hasPrefix:@" "])
            self.item.desc = [self.item.desc substringFromIndex:1];
        while([self.item.desc hasSuffix:@" "])
        {
            idx = idx - 1;
            self.item.desc = [self.item.desc substringToIndex:idx];
        }
        NSString *message   = [NSString stringWithFormat:format, [NSString stringWithFormat:@"%@...", [self.item.desc substringToIndex:idx]]];
        while (![tweetViewController setInitialText:message])
        {
            idx -= 5;
            if (idx > 5)
            {
                message = [NSString stringWithFormat:format, [NSString stringWithFormat:@"%@...", [self.item.desc substringToIndex:idx]]];
            }
            else
            {
                [tweetViewController setInitialText:self.item.url];
                break;
            }
        }
    }
    else
    {
        [tweetViewController setInitialText:self.item.url];
    }
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            [self completionResult:typeCanceled];
        }
        else if (result == SLComposeViewControllerResultDone) {
            [self completionResult:typeDone];
        }
        else  {
            [self completionResult:typeFailed];
        }
        [self.controller dismissViewControllerAnimated:YES completion:^{
        }];
    };
    tweetViewController.completionHandler = myBlock;
    
    // OLD Deprecated
//    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result){
//        switch (result) {
//            case TWTweetComposeViewControllerResultCancelled:
//                [self completionResult:typeCanceled];
//                
//                break;
//            case TWTweetComposeViewControllerResultDone:
//                [self completionResult:typeDone];
//                
//                break;
//            default:
//                [self completionResult:typeFailed];
//                break;
//        }
//        [self.controller dismissViewControllerAnimated:YES completion:^{
//        }];
//    }];
    [self.controller presentViewController:tweetViewController animated:YES completion:^{
    }];
}

- (void) shareUsingSLCompose
{
    SLComposeViewController *socialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if (self.item.image != nil)
        [socialComposer addImage:self.item.image];
    
    if (self.item.desc != nil)
    {
        NSString *format    = @"%@";
        if (self.item.url != nil)
            [socialComposer addURL:[NSURL URLWithString:self.item.url]];
        
        NSUInteger idx = self.item.desc.length;
        while([self.item.desc hasPrefix:@" "])
        {
            idx = idx - 1;
            self.item.desc = [self.item.desc substringFromIndex:1];
        }
        while([self.item.desc hasSuffix:@" "])
        {
            idx = idx - 1;
            self.item.desc = [self.item.desc substringToIndex:idx];
        }
        NSString *message = [NSString stringWithFormat:format,[self.item.desc substringToIndex:idx]];
        
        while (![socialComposer setInitialText:message])
        {
            idx -= 5;
            if (idx > 5)
            {
                message = [NSString stringWithFormat:format, [NSString stringWithFormat:@"%@…", [self.item.desc substringToIndex:idx]]];
            }
            else
            {
                [socialComposer setInitialText:self.item.url];
                break;
            }
        }
    }
    else
    {
        [socialComposer setInitialText:self.item.url];
    }
    
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
        [self.controller dismissViewControllerAnimated:YES completion:^{
        }];
    }];

    [self.controller presentViewController:socialComposer animated:YES completion:^{
    }];
}

@end
