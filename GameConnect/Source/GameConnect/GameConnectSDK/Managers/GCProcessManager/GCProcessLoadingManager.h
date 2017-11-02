//
//  GCProcessLoadingManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 15/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"
#import "GCMasterViewController.h"

@protocol GCProcessLoadingManagerDelegate <GCProcessManagerDelegate>
@optional

/* Loading */
-(void) GCDidStartLoadingWithData:(NSDictionary *)loadingUserInfo fromViewController:(GCMasterViewController *)senderViewController;

-(void) GCRequestCheckFromViewController:(GCMasterViewController *)senderViewController;

-(void) GCDidEndLoadingWithData:(NSDictionary *)loadingUserInfo fromViewController:(GCMasterViewController *)senderViewController;

@end


@interface GCProcessLoadingManager : GCProcessManager
@property (weak, nonatomic) id<GCProcessLoadingManagerDelegate> delegate;

-(void)startLoadingWithData:(NSDictionary *)loadingUserInfo fromViewController:(GCMasterViewController *)senderViewController;

-(void)makePlatformeCheckFromViewController:(GCMasterViewController *)senderViewController;

-(void)stopLoadingWithData:(NSDictionary *)loadingUserInfo  fromViewController:(GCMasterViewController *)senderViewController;

@end
