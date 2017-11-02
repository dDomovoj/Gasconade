//
//  GCAPPNavigationPriority.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPNavigationPriorityPushManager.h"
#import "GCAPPAnswersViewController.h"
#import "GCAPPPushInfoViewController.h"
#import "GCAPPGameViewController.h"
#import "GCGamerManager.h"
#import "GCAPPHomeViewController.h"

@implementation GCAPPNavigationPriorityPushManager

-(id)init
{
    self = [super init];
    if (self)
    { }
    return self;
}

-(BOOL) forceUpdateQuestion:(GCQuestionModel *)questionModel
              inNavigationController:(GCAPPNavigationController *)navigationController
{
    for (UIViewController *viewController in [navigationController viewControllers])
    {
        if (viewController && [viewController isKindOfClass:[GCAPPAnswersViewController class]] && ![viewController isBeingDismissed])
        {
            GCAPPAnswersViewController *answersViewController = (GCAPPAnswersViewController *) viewController;
            [answersViewController updateNewQuestion:questionModel];
            [navigationController popToViewController:viewController animated:TRUE];
            return YES;
        }
    }
    return NO;
}

-(BOOL) canIManageNewPendingQuestion:(GCQuestionModel *)questionModel
              inNavigationController:(GCAPPNavigationController *)navigationController
   callBackPushNewViewController:(void(^)())callbackPushNewViewController
   andCallBackIfUserShouldBeNotified:(void(^)())callbackUserNotification
{
    /*
     ** IF the visible view controller is not displaying a pending question (high priority)
     **     Look into the navigation hiearchy if a QuestionViewController is alive.
     **     if YES => PopViewControllers to this one and update new Question ; return YES; (we handled it)
     **     if NO => Push QuestionViewController ; return NO; (we cannot handle it here)
     ** ELSE
     **     Notif USER or Add Question in pager;
     */

    if (!navigationController)
    {
        DLog(@"NavigationController doesn't exist");
        return NO;
    }

    BOOL visibleViewControllerIsAnswersPendingQuestion = NO;
    if ([navigationController.visibleViewController isKindOfClass:[GCAPPAnswersViewController class]])
    {
        GCAPPAnswersViewController *answersViewController = (GCAPPAnswersViewController *)navigationController.visibleViewController;
        if ([answersViewController.questionModelForAnswers isQuestionActive] && [answersViewController.questionModelForAnswers.my_answers count] == 0 && ![answersViewController isBeingDismissed])
        {
            visibleViewControllerIsAnswersPendingQuestion = YES;
            DLog(@"visibleViewController => GCAPPAnswersViewController with question PENDING");
        }
        // Question has been answered. Now consulting stats
        else if ((([answersViewController.questionModelForAnswers isQuestionActive] == YES && [answersViewController.questionModelForAnswers.my_answers count] > 0) ||
                  ([answersViewController.questionModelForAnswers isQuestionActive] == NO)) &&
                 [answersViewController getTimeIntervalSinceIAmDisplayed] < 10 &&
                 ![answersViewController isBeingDismissed])
        {
            visibleViewControllerIsAnswersPendingQuestion = YES;
        }
        else
        {
            visibleViewControllerIsAnswersPendingQuestion = NO;
            DLog(@"visibleViewController => GCAPPAnswersViewController with question NOT PENDING");
        }
    }
    if (visibleViewControllerIsAnswersPendingQuestion == NO)
    {
        for (UIViewController *viewController in [navigationController viewControllers])
        {
            if (viewController && [viewController isKindOfClass:[GCAPPAnswersViewController class]] && ![viewController isBeingDismissed])
            {
                // From Stats to New question
                GCAPPAnswersViewController *answersViewController = (GCAPPAnswersViewController *)viewController;
                if ([answersViewController.questionModelForAnswers isQuestionActive] == NO ||
                    [answersViewController.questionModelForAnswers.my_answers count] > 0)
                {
                    GCAPPAnswersViewController *answersViewController = (GCAPPAnswersViewController *) viewController;
                    [answersViewController updateNewQuestion:questionModel];
                    [navigationController popToViewController:viewController animated:TRUE];
                    return YES;
                }
            }
        }
////        if (![navigationController.visibleViewController isBeingDismissed] &&
////            ![navigationController.visibleViewController isBeingPresented] &&
////            ![navigationController.presentingViewController isBeingPresented])
//        if ([navigationController respondsToSelector:@selector(isTransitioningViewController)] && [navigationController isTransitioningViewController] == NO)
//        {
//            if (callbackPushNewViewController)
//                callbackPushNewViewController();
//        }
//        else
//        {
//            __weak GCAPPNavigationPriorityPushManager *weak_self = self;
//            [self performWithDelay:1 block:^{
//                [weak_self canIManageNewPendingQuestion:questionModel inNavigationController:navigationController callBackPushNewViewController:callbackPushNewViewController andCallBackIfUserShouldBeNotified:callbackUserNotification];
//            }];
//        }

        if (callbackPushNewViewController)
            callbackPushNewViewController();
        return  NO;
    }
    else
    {
            if (callbackUserNotification)
                callbackUserNotification();
        return YES;
    }
}

-(BOOL) canIManageQuestionStats:(GCQuestionModel *)questionModel inNavigationController:(GCAPPNavigationController *)navigationController
{
    if (!navigationController)
    {
        DLog(@"NavigationController doesn't exist");
        return NO;
    }
    
    for (UIViewController *viewController in [navigationController viewControllers])
    {
        if (viewController && [viewController isKindOfClass:[GCAPPAnswersViewController class]])
        {
            GCAPPAnswersViewController *answersViewController = (GCAPPAnswersViewController *)viewController;
            if ([answersViewController.questionModelForAnswers._id isEqualToString:questionModel._id])
            {
                NSLog(@"STATS for %@", questionModel.question);
                [answersViewController updateStatsQuestion:questionModel];
                return YES;
            }
        }
    }
    return YES;
}

-(BOOL) canIManageQuestionEnd:(GCQuestionModel *)questionModel inNavigationController:(GCAPPNavigationController *)navigationController
{
    if (!navigationController)
    {
        DLog(@"NavigationController doesn't exist");
        return NO;
    }

    if ([navigationController.visibleViewController isKindOfClass:[GCAPPAnswersViewController class]])
    {
        GCAPPAnswersViewController *answersViewController = (GCAPPAnswersViewController *)navigationController.visibleViewController;
        if ([answersViewController.questionModelForAnswers._id isEqualToString:questionModel._id] && ![answersViewController isBeingDismissed])
        {
            if ([answersViewController.questionModelForAnswers isQuestionActive])
                [answersViewController updateEndQuestion:questionModel];
        }
    }
    for (UIViewController *viewController in [navigationController viewControllers])
    {
        if (viewController && [viewController isKindOfClass:[GCAPPGameViewController class]])
        {
            GCAPPGameViewController *appGame = (GCAPPGameViewController *)viewController;
            [appGame updateEndQuestion:questionModel];
        }
    }
    return YES;
}

-(BOOL) canIManageNewEvent:(GCEventModel *)eventMovel inNavigationController:(GCAPPNavigationController *)navigationController
{
    if (!navigationController)
    {
        DLog(@"NavigationController doesn't exist");
        return NO;
    }
    
    if ([navigationController.visibleViewController isKindOfClass:[GCAPPHomeViewController class]])
    {
        GCAPPHomeViewController *homeViewController = (GCAPPHomeViewController *)navigationController.visibleViewController;
        
        if ([homeViewController isBeingDismissed])
            [homeViewController updateNewEvent:eventMovel];
    }
    for (UIViewController *viewController in [navigationController viewControllers])
    {
        if (viewController && [viewController isKindOfClass:[GCAPPHomeViewController class]])
        {
            GCAPPHomeViewController *homeViewController = (GCAPPHomeViewController *)viewController;
            [homeViewController updateNewEvent:eventMovel];
        }
    }
    return YES;
}

-(BOOL) canIManageEndEvent:(GCEventModel *)eventMovel inNavigationController:(GCAPPNavigationController *)navigationController
{
    if (!navigationController)
    {
        DLog(@"NavigationController doesn't exist");
        return NO;
    }
    
    if ([navigationController.visibleViewController isKindOfClass:[GCAPPHomeViewController class]])
    {
        GCAPPHomeViewController *homeViewController = (GCAPPHomeViewController *)navigationController.visibleViewController;
        
        [homeViewController updateEndEvent:eventMovel];
    }
    if ([navigationController.visibleViewController isKindOfClass:[GCAPPGameViewController class]])
    {
        GCAPPGameViewController *gameViewController = (GCAPPGameViewController *)navigationController.visibleViewController;
        
        [gameViewController updateEndEvent:eventMovel];
    }
    for (UIViewController *viewController in [navigationController viewControllers])
    {
        if (viewController && [viewController isKindOfClass:[GCAPPHomeViewController class]])
        {
            GCAPPHomeViewController *homeViewController = (GCAPPHomeViewController *)viewController;
            [homeViewController updateEndEvent:eventMovel];
        }
    }
    return YES;

}

-(BOOL) canIManageEventRanking:(GCPushRankingEventModel *)pushRankingEventModel inNavigationController:(GCAPPNavigationController *)navigationController
{
    if (!navigationController)
    {
        DLog(@"NavigationController doesn't exist");
        return YES;
    }
    for (UIViewController *viewController in [navigationController viewControllers])
    {
        if (viewController && [viewController isKindOfClass:[GCAPPGameViewController class]])
        {
            // Update my rankings. The push is sent when my rankings are calculated. The rankings of the other players are supposed to be generated at the samed time.
            // Update mine, et get the others.
            GCAPPGameViewController *gameViewController = (GCAPPGameViewController *)viewController;
            
            if ([pushRankingEventModel.event_id isEqualToString:gameViewController.eventModel._id])
            {
                GCRankingModel *rankingModel = [GCRankingModel new];
                rankingModel.gamer = [GCGamerManager getInstance].gamer;
                rankingModel.score = pushRankingEventModel.score;
                rankingModel.rank = pushRankingEventModel.rank;
                [gameViewController updateMyRanking:rankingModel];
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL) canIManageNewTrophy:(GCTrophyModel *)trophyModel
     inNavigationController:(GCAPPNavigationController *)navigationController
   callBackPushNewViewController:(void(^)())callbackPushNewViewController
    andCallBackIfUserShouldBeNotified:(void(^)())callbackUserNotification
{
    return [self canIManagePushInfos:@[trophyModel] inNavigationController:navigationController callBackPushNewViewController:callbackPushNewViewController andCallBackIfUserShouldBeNotified:callbackUserNotification];
}

-(BOOL) canIManageQuestionResult:(GCQuestionModel *)questionModel
          inNavigationController:(GCAPPNavigationController *)navigationController
   callBackPushNewViewController:(void(^)())callbackPushNewViewController
andCallBackIfUserShouldBeNotified:(void(^)())callbackUserNotification
{
    return [self canIManagePushInfos:@[questionModel] inNavigationController:navigationController callBackPushNewViewController:callbackPushNewViewController andCallBackIfUserShouldBeNotified:callbackUserNotification];
}

-(BOOL) canIManagePushInfos:(NSArray *)pushInfos
          inNavigationController:(GCAPPNavigationController *)navigationController
   callBackPushNewViewController:(void(^)())callbackPushNewViewController
andCallBackIfUserShouldBeNotified:(void(^)())callbackUserNotification
{
    /*
     ** IF the visible view controller is not displaying a pending question (high priority)
     **   Look into the hiearchy if a PushInfoViewController is alive
     **   If YES => PopViewControllers to this one and addNewPushInfo ; return YES; (we handled it)
     **   If NO => Push PushInfoViewController ; return NO; (we cannot handle it here)
     ** ELSE
     **   Notifications to User for an available PushInfo content.
     */
    
    if (!pushInfos || [pushInfos count] == 0)
    {
        DLog(@"PushInfos doesn't exist");
        return NO;
    }
    
    if (!navigationController)
    {
        DLog(@"NavigationController doesn't exist");
        return NO;
    }
    
    BOOL visibleViewControllerIsAnswersPendingQuestion = NO;
    if ([navigationController.visibleViewController isKindOfClass:[GCAPPAnswersViewController class]])
    {
        GCAPPAnswersViewController *answersViewController = (GCAPPAnswersViewController *)navigationController.visibleViewController;
        
        // Question is still active and the user didn't answer
        if ([answersViewController.questionModelForAnswers isQuestionActive] && [answersViewController.questionModelForAnswers.my_answers count] == 0 &&
            ![answersViewController isBeingDismissed])
        {
            visibleViewControllerIsAnswersPendingQuestion = YES;
            DLog(@"visibleViewController => GCAPPAnswersViewController with question PENDING");
        }
        // Question has been answered. Now consulting stats
        else if ((([answersViewController.questionModelForAnswers isQuestionActive] == YES && [answersViewController.questionModelForAnswers.my_answers count] > 0) ||
                 ([answersViewController.questionModelForAnswers isQuestionActive] == NO)) &&
                 [answersViewController getTimeIntervalSinceIAmDisplayed] < 10 &&
                 ![answersViewController isBeingDismissed])
        {
// BUBBLE

// Timer & relaunch
//            __weak GCAPPNavigationPriorityPushManager *weak_self = self;
//            [self performWithDelay:(1) block:^{
//                [weak_self canIManagePushInfos:pushInfos inNavigationController:navigationController callBackPushNewViewController:callbackPushNewViewController andCallBackIfUserShouldBeNotified:callbackUserNotification];
//            }];
// Make the notification appearing.
            
            visibleViewControllerIsAnswersPendingQuestion = YES;
        }
        else
        {
            DLog(@"visibleViewController => GCAPPAnswersViewController with question NOT PENDING, timeBeingDisplayed : %f", [answersViewController getTimeIntervalSinceIAmDisplayed]);
            visibleViewControllerIsAnswersPendingQuestion = NO;
        }
    }
    if (visibleViewControllerIsAnswersPendingQuestion == NO)
    {
        for (UIViewController *viewController in [navigationController viewControllers])
        {
            if (viewController && [viewController isKindOfClass:[GCAPPPushInfoViewController class]] && ![viewController isBeingDismissed])
            {
                GCAPPPushInfoViewController *pushInfoViewController = (GCAPPPushInfoViewController *) viewController;
                [pushInfoViewController addPushInfos:pushInfos];
                [navigationController popToViewController:viewController animated:YES];
                return YES;
            }
        }
////        if (![navigationController.visibleViewController isBeingDismissed] && ![navigationController.visibleViewController  isBeingPresented])
//        if ([navigationController respondsToSelector:@selector(isTransitioningViewController)] && [navigationController isTransitioningViewController] == NO)
//        {
//            if (callbackPushNewViewController)
//                callbackPushNewViewController();
//        }
//        else
//        {
//            __weak GCAPPNavigationPriorityPushManager *weak_self = self;
//            [self performWithDelay:1 block:^{
//                [weak_self canIManagePushInfos:pushInfos inNavigationController:navigationController callBackPushNewViewController:callbackPushNewViewController andCallBackIfUserShouldBeNotified:callbackUserNotification];
//            }];
//        }
        if (callbackPushNewViewController)
            callbackPushNewViewController();

        return NO;
    }
    else
    {
        if (callbackUserNotification)
            callbackUserNotification();
        return YES;
    }
}


-(BOOL) forceUpdatePushInfos:(NSArray *)pushInfos
     inNavigationController:(UINavigationController *)navigationController
{
    for (UIViewController *viewController in [navigationController viewControllers])
    {
        if (viewController && [viewController isKindOfClass:[GCAPPPushInfoViewController class]] && ![viewController isBeingDismissed])
        {
            GCAPPPushInfoViewController *pushInfoViewController = (GCAPPPushInfoViewController *) viewController;
            [pushInfoViewController addPushInfos:pushInfos];
            [navigationController popToViewController:viewController animated:YES];
            return YES;
        }
    }
    return NO;
}

@end
