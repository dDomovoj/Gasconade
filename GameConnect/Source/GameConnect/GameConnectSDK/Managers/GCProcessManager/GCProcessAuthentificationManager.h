//
//  GCProcessAuthentificationManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"
#import "GCConnectViewController.h"
#import "GCMasterViewController.h"

/*
 ** GCProcessAuthentificationManager
 */
@protocol GCProcessAuthentificationManagerDelegate <GCProcessManagerDelegate>
@optional
/* Connect */
-(void) GCDidRequestAuthentificationFrom:(GCConnectViewController *)GCViewControllerSender;
-(void) GCDidRequestSubscribeFrom:(GCMasterViewController *)GCViewControllerSender;

-(void) GCDidEndAuthentificationFrom:(GCMasterViewController *)GCViewControllerSender;
@end

@interface GCProcessAuthentificationManager : GCProcessManager

@property (weak, nonatomic) id<GCProcessAuthentificationManagerDelegate> delegate;
/* Connect */
-(void) requestAuthentificationFrom:(GCConnectViewController *)connectViewController;
-(void) requestSubscribeFrom:(GCMasterViewController *)senderViewController;
-(void) endAuthentificationFrom:(GCMasterViewController *)senderViewController;

@end
