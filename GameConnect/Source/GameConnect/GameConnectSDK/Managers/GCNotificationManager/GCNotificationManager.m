//
//  GCNotificationManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "CHDraggableView.h"
#import "CHDraggableView+Match.h"

#import "GCNotificationManager.h"
#import "OLGhostAlertView.h"
#import "NSObject+NSObject_Tool.h"
#import "GCNotificationView.h"
#import "GCInGameViewController.h"
#import "GCProcessNotificationManager.h"
//#import "PSGOneApp-Swift.h"
#warning ADD GC USER DEFAULTS
//#import "UserDefaultsStorageManager.h"

@interface GCNotificationManager()
{
    // Limitation on Y for bubbles
    CGFloat minY;
    CGFloat maxY;
    
    // Coordinator for Bubbles
    CHDraggingCoordinator* draggingCoordinator;
    
    // Views for Bubbles
    GCNotificationView *notificationViewQuestions;
    GCNotificationView *notificationPushInfo;
    
    __weak GCInGameViewController *inGameViewController;
}
@end

@implementation GCNotificationManager

-(id)init
{
    self = [super init];
    if (self)
    {
        minY = 0;
        maxY = 0;
    }
    return self;
}

- (BOOL)bubbleEnabled
{
  return YES;//[UserDefaultsStorageManager isGCNotificationsEnabled];
}

-(void) setFlashMessage:(NSString *)strToDisplayInNotification
{
	[NSObject mainThreadBlock:^{
        [[[OLGhostAlertView alloc] initWithTitle:strToDisplayInNotification] show];
    }];
}

-(void)createNotificationsViewAndHide
{
    if (!notificationPushInfo && !notificationViewQuestions)
    {
        notificationPushInfo = [self createNotificationView];
        notificationPushInfo.bubbleType = eCHDraggableViewSimple;
        notificationViewQuestions = [self createNotificationView];
        notificationViewQuestions.bubbleType = eCHDraggableViewOpenPanel;

        notificationPushInfo.alpha = 0;
        notificationViewQuestions.alpha = 0;
    }
    else
    {
        DLog(@"Notifications already exist!");
    }
}

-(void) notifyUserForNewResult:(GCQuestionModel*)questionModel
{
    if (self.bubbleEnabled)
    {
        if (!notificationPushInfo)
        {
            notificationPushInfo = [self createNotificationView];
            notificationPushInfo.bubbleType = eCHDraggableViewSimple;
        }
        
        if ([self adjustPrimaryPositionOf:notificationPushInfo reguardingOtherBubble:notificationViewQuestions] == NO)
        {
        }
        
        [notificationPushInfo updateWithQuestionResult:questionModel];
        [notificationPushInfo setAlpha:1];
        [notificationPushInfo.superview bringSubviewToFront:notificationPushInfo];
        [notificationPushInfo bouingAppear:YES oncomplete:^{
        }];
    }
    else
    {
        if ([[GCConfManager getInstance] shouldBroadcastExternalNotifications])
            [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_NEW_RESULT object:nil userInfo:@{GCUSERINFONOTIF : questionModel}];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_NEW_NOTIFICATION object:nil userInfo:@{GCUSERINFONOTIF : questionModel}];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [NOTIFICATION 2x] => New result question");
}

-(void) notifyUserForNewTrophy:(GCTrophyModel *)trophyModel
{
    if (self.bubbleEnabled)
    {
        if (!notificationPushInfo)
        {
            notificationPushInfo = [self createNotificationView];
            notificationPushInfo.bubbleType = eCHDraggableViewSimple;
        }
        
        if ([self adjustPrimaryPositionOf:notificationPushInfo reguardingOtherBubble:notificationViewQuestions] == NO)
        { }
        
        [notificationPushInfo updateWithTrophy:trophyModel];
        [notificationPushInfo setAlpha:1];
        [notificationPushInfo.superview bringSubviewToFront:notificationPushInfo];
        [notificationPushInfo bouingAppear:YES oncomplete:^{
        }];
    }
    else
    {
        if ([[GCConfManager getInstance] shouldBroadcastExternalNotifications])
            [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_NEW_TROPHY object:nil userInfo:@{GCUSERINFONOTIF : trophyModel}];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_NEW_NOTIFICATION object:nil userInfo:@{GCUSERINFONOTIF : trophyModel}];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [NOTIFICATION 2x] => New trophy");
}

-(void) notifyUserForNewQuestion:(GCQuestionModel *)questionModel
{
    if (self.bubbleEnabled)
    {
        if (!notificationViewQuestions)
        {
            notificationViewQuestions = [self createNotificationView];
            notificationViewQuestions.bubbleType = eCHDraggableViewOpenPanel;
        }
        
        if ([self adjustPrimaryPositionOf:notificationPushInfo reguardingOtherBubble:notificationViewQuestions] == NO)
        {
        }
        
        [notificationViewQuestions updateWithNewQuestion:questionModel];
        [notificationViewQuestions setAlpha:1];
        [notificationViewQuestions.superview bringSubviewToFront:notificationViewQuestions];
        [notificationViewQuestions bouingAppear:YES oncomplete:^{
        }];
    }
    else
    {
        if ([[GCConfManager getInstance] shouldBroadcastExternalNotifications])
            [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_NEW_QUESTION object:nil userInfo:@{GCUSERINFONOTIF : questionModel}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_NEW_NOTIFICATION object:nil userInfo:@{GCUSERINFONOTIF : questionModel}];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [NOTIFICATION 2x] => New question");
}

-(void) notifyUserEndQuestion:(GCQuestionModel *)questionModel
{
    for (GCQuestionModel *question in [[notificationViewQuestions getAllQuestions] copy])
    {
        if ([questionModel._id isEqualToString:question._id] &&
            [questionModel.event_id isEqualToString:question.event_id])
        {
            [notificationViewQuestions removeAQuestion:questionModel];
            if (inGameViewController)
            {
                inGameViewController.preloadedQuestions = [[notificationViewQuestions getAvailableQuestions]copy];
                [inGameViewController loadData];
            }
            if ([[notificationViewQuestions getAllQuestions]count] == 0)
            {
                [self closeNotification:notificationViewQuestions];
            }
        }
    }
    
    if ([[GCConfManager getInstance] shouldBroadcastExternalNotifications])
        [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_END_QUESTION object:nil userInfo:@{GCUSERINFONOTIF : questionModel}];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [NOTIFICATION] => End question");
}

-(void) notifyUserEndEvent:(GCEventModel *)eventModel
{
    for (GCQuestionModel *question in [[notificationViewQuestions getAllQuestions] copy])
    {
        if ([question.event_id isEqualToString:eventModel._id])
        {
            [notificationViewQuestions removeAQuestion:question];
            if (inGameViewController)
            {
                inGameViewController.preloadedQuestions = [[notificationViewQuestions getAvailableQuestions]copy];
                [inGameViewController loadData];
            }
            if ([[notificationViewQuestions getAllQuestions]count] == 0)
            {
                [self closeNotification:notificationViewQuestions];
            }
        }
    }
    
    if ([[GCConfManager getInstance] shouldBroadcastExternalNotifications])
        [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_END_EVENT object:nil userInfo:@{GCUSERINFONOTIF : eventModel}];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [NOTIFICATION] => End event");
}

- (void)onAnswerQuestion:(GCQuestionModel *)questionModel
{
    [notificationViewQuestions removeAQuestion:questionModel];
    if ([notificationViewQuestions getAllQuestions].count == 0) {
        [self closeNotification:notificationViewQuestions];
    }
}

-(GCNotificationView *)createNotificationView
{
    UIView *viewContainingBubbles = nil;
    if (self.viewPanelBubble)
        viewContainingBubbles = self.viewPanelBubble;
    else
        viewContainingBubbles = [UIApplication sharedApplication].keyWindow;
    
    if (maxY == 0)
        maxY = viewContainingBubbles.bounds.size.height;
    
    GCNotificationView *notificationView = [[[NSBundle mainBundle ] loadNibNamed:@"GCNotificationView" owner:nil options:nil] getObjectsType:[GCNotificationView class]];
    
    [notificationView setFrame:CGRectMake((viewContainingBubbles.frame.origin.x + viewContainingBubbles.bounds.size.width) - (notificationView.bounds.size.width),
                                          minY,
                                          notificationView.frame.size.width,
                                          notificationView.frame.size.height)];

    if (!draggingCoordinator)
    {
        draggingCoordinator = [[CHDraggingCoordinator alloc] initWithContainer:viewContainingBubbles draggableViewBounds:notificationView.bounds];
        draggingCoordinator.delegate = self;
        draggingCoordinator.snappingEdge =  CHSnappingEdgeBoth;
    }
    notificationView.delegate = draggingCoordinator;
    [viewContainingBubbles addSubview:notificationView];
    [viewContainingBubbles bringSubviewToFront:notificationView];
    [notificationView myInit];
    [viewContainingBubbles setNeedsDisplay];
    return notificationView;
}

-(BOOL) adjustPrimaryPositionOf:(CHDraggableView *)notificationView reguardingOtherBubble:(CHDraggableView *)otherBubble
{
    CGFloat YwhereToDisplayNotifFirstTime = notificationView.frame.origin.y;
    BOOL supperposition = NO;
    
    if (otherBubble && otherBubble.alpha != 0.0 &&
        otherBubble.frame.origin.x == notificationView.frame.origin.x)
    {
        if (notificationView.frame.origin.y + notificationView.frame.size.height > otherBubble.frame.origin.y &&
            notificationView.frame.origin.y + notificationView.frame.size.height < otherBubble.frame.origin.y + otherBubble.bounds.size.height)
        {
            supperposition = YES;
            YwhereToDisplayNotifFirstTime = (otherBubble.frame.origin.y - notificationView.frame.size.height) - 10;

            if (YwhereToDisplayNotifFirstTime < minY)
                YwhereToDisplayNotifFirstTime = otherBubble.frame.origin.y + otherBubble.frame.size.height - 10;
        }
        else if (otherBubble.frame.origin.y + otherBubble.frame.size.height > notificationView.frame.origin.y &&
                 otherBubble.frame.origin.y + otherBubble.frame.size.height < notificationView.frame.origin.y + notificationView.bounds.size.height)
        {
            supperposition = YES;
            YwhereToDisplayNotifFirstTime = otherBubble.frame.origin.y + otherBubble.frame.size.height + 10;

            if (YwhereToDisplayNotifFirstTime > maxY)
                YwhereToDisplayNotifFirstTime = otherBubble.frame.origin.y - notificationView.frame.size.height - 10;
        }
        else if (notificationView.frame.origin.y == otherBubble.frame.origin.y)
        {
            supperposition = YES;
            YwhereToDisplayNotifFirstTime = notificationView.frame.origin.y + notificationView.frame.size.height + 10;

            if (YwhereToDisplayNotifFirstTime > maxY)
                YwhereToDisplayNotifFirstTime = otherBubble.frame.origin.y - 10 - notificationView.frame.size.height;
        }
        [notificationView setFrame:CGRectMake(notificationView.frame.origin.x,
                                              YwhereToDisplayNotifFirstTime,
                                              notificationView.frame.size.width,
                                              notificationView.frame.size.height)];
    }
    return supperposition;
}

-(void) setMinimumY:(CGFloat)minimumY
{
    minY = minimumY;
}

-(void) setMaximumY:(CGFloat)maximumY
{
    maxY = maximumY;
}

#pragma CHDRaggingCoordinatorDelegate
-(UIViewController *) didAskForViewControllerToPresent:(CHDraggingCoordinator *)coordinator fromBubble:(CHDraggableView *)draggableView
{
    if (draggableView == notificationViewQuestions)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_SELECT_BUBBBLE_QUESTION object:nil];

        inGameViewController = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCInGameVCIdentifier];
        inGameViewController.preloadedQuestions = [[notificationViewQuestions getAvailableQuestions]copy];

        // Make the tabs hidden => Only One list is displayed!
        [inGameViewController.view setNeedsDisplay];
        [inGameViewController.cv_questionsGame setFrame:CGRectMake(inGameViewController.cv_questionsGame.frame.origin.x, 0, inGameViewController.cv_questionsGame.frame.size.width, inGameViewController.cv_questionsGame.frame.size.height + inGameViewController.v_containerSegmentedControl.frame.size.height)];
        inGameViewController.v_containerSegmentedControl.alpha = 0.0;
        inGameViewController.cv_resultsGame.alpha = 0.0;
        //

        __weak GCNotificationManager *weak_self = self;
        [inGameViewController setCallBackQuestionSelected:^(GCQuestionModel *question)
         {
             [notificationViewQuestions removeAQuestion:question];
             [coordinator draggableViewTouched:notificationViewQuestions];
             [[GCProcessNotificationManager sharedManager] selectQuestion:question fromNotification:notificationViewQuestions];
             
             if ([[notificationViewQuestions getAvailableQuestions] count] == 0)
                 [weak_self closeNotification:notificationViewQuestions];
             
         }];
        return inGameViewController;
    }
    return nil;
}

-(void) didClosePresentedViewController:(UIViewController *)viewController
                          inCoordinator:(CHDraggingCoordinator *)coordinator
                             fromBubble:(CHDraggableView *)draggableView
{ }

-(void) didClickOnBubble:(CHDraggableView *)draggableView
{
    if (draggableView && draggableView == notificationPushInfo)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:GCNOTIF_SELECT_BUBBBLE_PUSHINFO object:nil];

        [[GCProcessNotificationManager sharedManager] requestPushInfoFromNotification:notificationPushInfo forPushInfos:[notificationPushInfo getAvailablePushInfo]];
        [self closeNotification:notificationPushInfo];
        [notificationPushInfo removeAllPuhsInfo];
    }
}

-(void) closeNotification:(GCNotificationView *)notificationToClose
{
    if (!notificationToClose)
        return ;
    
    if (notificationToClose.bubbleType == eCHDraggableViewOpenPanel &&
        draggingCoordinator.state == CHInteractionStateConversation)
    {
        [draggingCoordinator draggableViewTouched:notificationToClose];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [notificationToClose setAlpha:0];
    } completion:^(BOOL finished) {
    }];
}

-(void)closeAllNotifications
{
    [self closeNotification:notificationViewQuestions];
    [self closeNotification:notificationPushInfo];
    
    if (notificationViewQuestions)
    {
        [notificationViewQuestions removeFromSuperview];
        notificationViewQuestions = nil;
    }
    if (notificationPushInfo)
    {
        [notificationPushInfo removeFromSuperview];
        notificationPushInfo = nil;
    }
}

@end
