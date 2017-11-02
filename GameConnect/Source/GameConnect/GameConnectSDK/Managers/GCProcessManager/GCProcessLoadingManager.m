//
//  GCProcessLoadingManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 15/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessLoadingManager.h"
#import "GCMasterViewController.h"

@implementation GCProcessLoadingManager
CREATE_INSTANCE

-(void)startLoadingWithData:(NSDictionary *)loadingUserInfo fromViewController:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
 if ([self.delegate respondsToSelector:@selector(GCDidStartLoadingWithData:fromViewController:)])
     [self.delegate GCDidStartLoadingWithData:loadingUserInfo fromViewController:senderViewController];
}

-(void)makePlatformeCheckFromViewController:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCRequestCheckFromViewController:)])
        [self.delegate GCRequestCheckFromViewController:senderViewController];
}

-(void)stopLoadingWithData:(NSDictionary *)loadingUserInfo  fromViewController:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidEndLoadingWithData:fromViewController:)])
        [self.delegate GCDidEndLoadingWithData:loadingUserInfo fromViewController:senderViewController];
}

@end
