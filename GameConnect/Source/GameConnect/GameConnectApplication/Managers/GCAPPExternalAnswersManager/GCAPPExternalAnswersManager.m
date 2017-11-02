//
//  GCAPPExternalAnswersManager.m
//  TVA Sports Second Screen
//
//  Created by Guillaume on 06/08/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GCAPPExternalAnswersManager.h"
#import "GCQuestionModel.h"
#import "NSObject+NSObject_Xpath.h"
#import "GCGamerManager.h"

@interface GCAPPExternalAnswersManager()
@property (strong, nonatomic) GCAPPExternalAnswersViewController *externalAnswersViewController;
@end

@implementation GCAPPExternalAnswersManager

-(GCAPPExternalAnswersViewController *)initializeExternalPanel
{
    [self subscribeAllQuestionNotifications];
    [self createViewController];
    return self.externalAnswersViewController;
}

-(void)createViewController
{
    if (!self.externalAnswersViewController)
    {
        self.externalAnswersViewController = [[GCAPPExternalAnswersViewController alloc] initWithNibName:@"GCAPPExternalAnswersViewController" bundle:nil];

        CGFloat panelX = self.applicationRootViewController.view.bounds.size.width - self.externalAnswersViewController.view.frame.size.width;

        self.externalAnswersViewController.view.frame = CGRectMake(panelX, self.applicationRootViewController.view.bounds.size.height, 320, 450);

        __weak GCAPPExternalAnswersManager *weak_self = self;
        self.externalAnswersViewController.showPanelWithCallBack = ^(GCAPPExternalAnswersViewController *panelVC, void(^completionBlock)())
        {
            CGFloat panelHeight = [panelVC getHeightOfScrollSubviews] + [panelVC getHeightOfHeader];
            if (panelHeight > weak_self.applicationRootViewController.view.bounds.size.height - 64)
                panelHeight = weak_self.applicationRootViewController.view.bounds.size.height - 64;

            CGFloat panelY = weak_self.applicationRootViewController.view.bounds.size.height - panelHeight;
            CGFloat panelX = weak_self.applicationRootViewController.view.bounds.size.width - panelVC.view.frame.size.width;

            if ([panelVC numberOfElementsInPanel] == 0)
                [panelVC.view setFrame:CGRectMake(panelX, weak_self.applicationRootViewController.view.bounds.size.height, panelVC.view.frame.size.width, panelHeight)];

            if (![weak_self.applicationRootViewController.childViewControllers containsObject:panelVC])
            {
                [weak_self.applicationRootViewController.view addSubview:weak_self.externalAnswersViewController.view];
                [weak_self.applicationRootViewController addChildViewController:weak_self.externalAnswersViewController];
            }

            [UIView animateWithDuration:0.4 animations:^{
                [panelVC.view setFrame:CGRectMake(panelX, panelY, panelVC.view.frame.size.width, panelHeight)];
            } completion:^(BOOL finished)
            {
                if (completionBlock)
                    completionBlock();
            }];
        };

        self.externalAnswersViewController.hidePanelWithCallBack = ^(GCAPPExternalAnswersViewController *panelVC, void(^completionBlock)())
        {
            [UIView animateWithDuration:0.4 animations:^{
                [panelVC.view setFrame:CGRectMake(panelVC.view.frame.origin.x, weak_self.applicationRootViewController.view.bounds.size.height, panelVC.view.frame.size.width, panelVC.view.frame.size.height)];
            } completion:^(BOOL finished)
            {
                if (completionBlock)
                    completionBlock();
            }];
        };
    }
}

-(void) notifyUserAboutGameConnectWithBlockOnceSelected:(void(^)(eGCExternalActions actionType))completion
{
    if ([[GCConfManager getInstance] hasAlreadyShutdownExternalNotifications])
    {
        if ([[GCGamerManager getInstance] isLoggedIn])
        {
            // POP UP Re-enable External panel
            [self.externalAnswersViewController insertCustomPopUpWithData:@{@"title" : NSLocalizedString(@"gc_user_invitation_to_play_title", nil), @"message" : NSLocalizedString(@"gc_enable_external_panel", nil)} andBlockOnceSelected:^{
                if (completion)
                    completion(eGCActivateExternalPanel);
            }];
        }
        else
        {
            // POP UP Game connect Invitation
            [self.externalAnswersViewController insertCustomPopUpWithData:@{@"title" : NSLocalizedString(@"gc_user_invitation_to_play_title", nil), @"message" : NSLocalizedString(@"gc_user_invitation_to_play_message", nil)} andBlockOnceSelected:^{
                if (completion)
                    completion(eGCPlayGameConnect);
            }];
        }
    }
    else
    {
        if ([[GCGamerManager getInstance] isLoggedIn])
        {
            // Nothing in this case. Questions will come up soon
        }
        else
        {
            // POP UP Game connect Invitation
            [self.externalAnswersViewController insertCustomPopUpWithData:@{@"title" : NSLocalizedString(@"gc_user_invitation_to_play_title", nil), @"message" : NSLocalizedString(@"gc_user_invitation_to_play_message", nil)} andBlockOnceSelected:^{
                if (completion)
                    completion(eGCPlayGameConnect);
            }];
        }
    }
}

#pragma mark - Game Connect Notifications Handler
-(void)subscribeAllQuestionNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewQuestion:) name:GCNOTIF_NEW_QUESTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEndQuestion:) name:GCNOTIF_END_QUESTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveResultQuestion:) name:GCNOTIF_NEW_RESULT object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEndEvent:) name:GCNOTIF_END_EVENT object:nil];
}

-(void)didReceiveNewQuestion:(NSNotification *)notification
{
    if (notification && notification.userInfo)
    {
        GCQuestionModel *newQuestion = [notification.userInfo getXpathNil:GCUSERINFONOTIF type:[GCQuestionModel class]];
        if (newQuestion && self.externalAnswersViewController)
        {
            [self.externalAnswersViewController insertNewQuestion:newQuestion];
        }
    }
}

-(void)didReceiveEndQuestion:(NSNotification *)notification
{
    if (notification && notification.userInfo)
    {
        GCQuestionModel *endQuestion = [notification.userInfo getXpathNil:GCUSERINFONOTIF type:[GCQuestionModel class]];
        if (endQuestion && self.externalAnswersViewController)
        {
            [self.externalAnswersViewController removeQuestion:endQuestion];
        }
    }
}

-(void)didReceiveResultQuestion:(NSNotification *)notification
{
    if (notification && notification.userInfo)
    {
        GCQuestionModel *resultQuestion = [notification.userInfo getXpathNil:GCUSERINFONOTIF type:[GCQuestionModel class]];
        if (resultQuestion && self.externalAnswersViewController)
        {
            [self.externalAnswersViewController insertResultQuestion:resultQuestion];
        }
    }
}

-(void)didReceiveEndEvent:(NSNotification *)notification
{
    return ;
    if (notification && notification.userInfo)
    {
        GCEventModel *endEvent = [notification.userInfo getXpathNil:GCUSERINFONOTIF type:[GCEventModel class]];
        if (endEvent && self.externalAnswersViewController)
        {
            [self.externalAnswersViewController removeQuestionsFromEvent:endEvent];
        }
    }
}

@end
