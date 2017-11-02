//
//  GCAPPNavigationPriority.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCQuestionModel.h"
#import "GCTrophyModel.h"
#import "GCNotificationManager.h"
#import "GCPushModels.h"
#import "GCAPPNavigationController.h"

@interface GCAPPNavigationPriorityPushManager : NSObject

-(BOOL) canIManageNewPendingQuestion:(GCQuestionModel *)questionModel
              inNavigationController:(GCAPPNavigationController *)navigationController
       callBackPushNewViewController:(void(^)(void))callbackPushNewViewController
   andCallBackIfUserShouldBeNotified:(void(^)(void))callbackUserNotification;

-(BOOL) canIManageQuestionStats:(GCQuestionModel *)questionModel
         inNavigationController:(GCAPPNavigationController *)navigationController;

-(BOOL) canIManageQuestionEnd:(GCQuestionModel *)questionModel
       inNavigationController:(GCAPPNavigationController *)navigationController;

-(BOOL) canIManageEventRanking:(GCPushRankingEventModel *)pushRankingEventModel
        inNavigationController:(UINavigationController *)navigationController;

-(BOOL) canIManageNewTrophy:(GCTrophyModel *)badgeModel
     inNavigationController:(GCAPPNavigationController *)navigationController
callBackPushNewViewController:(void(^)(void))callbackPushNewViewController
andCallBackIfUserShouldBeNotified:(void(^)(void))callbackUserNotification;

-(BOOL) canIManagePushInfos:(NSArray *)pushInfos
     inNavigationController:(GCAPPNavigationController *)navigationController
callBackPushNewViewController:(void(^)(void))callbackPushNewViewController
andCallBackIfUserShouldBeNotified:(void(^)(void))callbackUserNotification;

-(BOOL) canIManageQuestionResult:(GCQuestionModel *)questionModel
          inNavigationController:(GCAPPNavigationController *)navigationController
   callBackPushNewViewController:(void(^)(void))callbackPushNewViewController
andCallBackIfUserShouldBeNotified:(void(^)(void))callbackUserNotification;

-(BOOL) canIManageNewEvent:(GCEventModel *)eventMovel
    inNavigationController:(GCAPPNavigationController *)navigationController;

-(BOOL) canIManageEndEvent:(GCEventModel *)eventMovel
    inNavigationController:(GCAPPNavigationController *)navigationController;

-(BOOL) forceUpdateQuestion:(GCQuestionModel *)questionModel
     inNavigationController:(GCAPPNavigationController *)navigationController;

-(BOOL) forceUpdatePushInfos:(NSArray *)pushInfos
      inNavigationController:(GCAPPNavigationController *)navigationController;

@end
