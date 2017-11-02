//
//  GCAPPNavigationManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GCProcessAuthentificationManager.h"
#import "GCProcessEventManager.h"
#import "GCProcessLeagueManager.h"
#import "GCProcessRankingManager.h"
#import "GCProcessQuestionManager.h"
#import "GCProcessPushManager.h"
#import "GCProcessProfileManager.h"
#import "GCAPPNavigationPriorityPushManager.h"
#import "GCProcessNotificationManager.h"
#import "GCProcessLoadingManager.h"

#import "GCAPPNavigationController.h"
#import "GCAPPLoadingViewController.h"

@interface GCAPPNavigationManager : NSObject <GCProcessAuthentificationManagerDelegate,
GCProcessPushManagerDelegate,
GCProcessQuestionManagerDelegate,
GCProcessRankingManagerDelegate,
GCProcessLeagueManagerDelegate,
GCProcessEventManagerDelegate,
GCProcessProfileManagerDelegate,
GCProcessNotificationManagerDelegate,
GCProcessLoadingManagerDelegate,
UIImagePickerControllerDelegate,
UIPopoverControllerDelegate,
UINavigationControllerDelegate>
{
    __weak GCProfileEditionViewController *temporaryProfileEdition;
    
    GCAPPLoadingViewController *loadingViewController;
    GCAPPNavigationController *navigationControllerAuthentification;
    
    GCAPPNavigationPriorityPushManager *priorityPushManager;
    
    UIPopoverController *popover;
}

@property (nonatomic) GCNotificationManager *notificationManager;
@property (nonatomic, weak) GCAPPNavigationController *gameConnectNavigationController;
@property (copy, nonatomic) BOOL(^isWatchingGameConnect)(void);

+(instancetype)getInstance;

-(GCAPPNavigationController *) giveMeNavigationViewController;
-(void)shareWithItems:(NSArray *)itemsToShare fromSourceView:(UIView *)sourceView;

- (void)openGameConnect;

- (void)reset;

- (void)pushWebViewControllerWithURLString:(NSString *)URLString pinToTopLayoutGuide:(BOOL)pinToTopLayoutGuide;

@end
