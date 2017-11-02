//
//  GCAPPNavigationManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPNavigationManageriPad.h"
#import "GCAPPGameViewController.h"
#import "GCAPPLeaguesViewController.h"
#import "GCAPPRankingsViewController.h"
#import "GCAPPLeaguesViewControlleriPad.h"
#import "GCAPPLeagueEditionViewController.h"
#import "GCAPPProfileViewController.h"
#import "GCAPPAnswersViewController.h"
#import "GCAPPLoginViewControlleriPad.h"
#import "GCAPPSubscribeViewControlleriPad.h"
#import "GCAPPProfileEditionViewController.h"
#import "GCAPPPushInfoViewControlleriPad.h"
#import "GCAPPHomeViewControlleriPad.h"

#import "GCGamerManager.h"
#import "GCCompetitionManager.h"

@interface GCAPPNavigationManageriPad()
@end

@implementation GCAPPNavigationManageriPad

+(instancetype) getInstance
{
    static GCAPPNavigationManageriPad *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[[self class] alloc] init];
    });
    return sharedMyManager;
}

-(void) initProcessDelegate
{
    [GCProcessAuthentificationManager sharedManager].delegate = self;
    [GCProcessEventManager sharedManager].delegate = self;
    [GCProcessLeagueManager sharedManager].delegate = self;
    [GCProcessRankingManager sharedManager].delegate = self;
    [GCProcessQuestionManager sharedManager].delegate = self;
    [GCProcessPushManager sharedManager].delegate = self;
    [GCProcessProfileManager sharedManager].delegate = self;
    [GCProcessNotificationManager sharedManager].delegate = self;
    [GCProcessLoadingManager sharedManager].delegate = self;
}

#pragma mark - Loading
-(void) GCRequestCheckFromViewController:(GCMasterViewController *)senderViewController
{
    if (!loadingViewController)
    {
        loadingViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPLoadingVCIdentifier];
        [self performWithDelay:0.3 block:^{
            
            if (!loadingViewController)
                return ;

            [[self giveMeNavigationViewController].topViewController.view addSubviewToBonce:loadingViewController.view];
            [[self giveMeNavigationViewController].topViewController addChildViewController:loadingViewController];
            [loadingViewController makeCheck];
        }];
    }
}

-(void) GCDidStartLoadingWithData:(NSDictionary *)loadingUserInfo fromViewController:(GCMasterViewController *)senderViewController
{
    if (!loadingViewController)
    {
        loadingViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPLoadingVCIdentifier];
        [self performWithDelay:0.3 block:^{
            
            if (!loadingViewController)
                return ;

            [[self giveMeNavigationViewController].topViewController.view addSubviewToBonce:loadingViewController.view];
            [[self giveMeNavigationViewController].topViewController addChildViewController:loadingViewController];
            [loadingViewController startLoading];
            [loadingViewController setLoadingData:loadingUserInfo];
        }];
    }
    else
    {
        [loadingViewController startLoading];
        [loadingViewController setLoadingData:loadingUserInfo];
    }
    [self.notificationManager closeAllNotifications];
}

-(void) GCDidEndLoadingWithData:(NSDictionary *)loadingUserInfo fromViewController:(GCMasterViewController *)senderViewController
{
    if (loadingViewController)
    {
        [loadingViewController setLoadingData:loadingUserInfo];
        [loadingViewController endLoading];
        [loadingViewController.view removeFromSuperview];
        [loadingViewController removeFromParentViewController];
        loadingViewController = nil;
    }
}

#pragma mark - Authentification
-(void) GCDidRequestAuthentificationFrom:(GCMasterViewController *)GCViewControllerSender
{
    if (!navigationControllerAuthentification)
    {
        GCAPPLoginViewControlleriPad *gameConnectLoginViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPLoginVCIdentifier];
        navigationControllerAuthentification = [[GCAPPNavigationController alloc] initWithRootViewController:gameConnectLoginViewController];

        [self performWithDelay:0.5 block:^{
            [[self giveMeNavigationViewController] presentViewController:navigationControllerAuthentification animated:YES completion:^{
                [[self giveMeNavigationViewController] popToRootViewControllerAnimated:YES];
            }];
        }];
    }
    [self.notificationManager closeAllNotifications];
}

-(void) GCDidRequestSubscribeFrom:(GCConnectViewController *)GCViewControllerSender
{
    if (navigationControllerAuthentification)
    {
        GCAPPSubscribeViewControlleriPad *subscribeViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPSubscribeVCIdentifier];
        [navigationControllerAuthentification pushViewController:subscribeViewController animated:TRUE];
    }
}

-(void) GCDidEndAuthentificationFrom:(GCMasterViewController *)GCViewControllerSender
{
    if (navigationControllerAuthentification && ![navigationControllerAuthentification isBeingDismissed])
    {
        [navigationControllerAuthentification dismissViewControllerAnimated:YES completion:^{
        }];
    }
    navigationControllerAuthentification = nil;
}

#pragma mark - Events
-(void) GCDidSelectEvent:(GCEventModel *)eventModel atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController
{
    if (indexPath.section == 0)
    {
        GCAPPGameViewController *appInGameViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPGameVCIdentifier];
        appInGameViewController.eventModel = eventModel;
        
        [[self giveMeNavigationViewController] pushViewController:appInGameViewController animated:TRUE];
    }
}

-(void) GCDidSelecElement:(id)dataElement atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController
{
    // Custom Elements in Events List
}

#pragma mark - Profile
-(void) GCDidSelectPlayedEvent:(GCEventModel *)playedEvent atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
    GCAPPGameViewController *appInGameViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPGameVCIdentifier];
    appInGameViewController.eventModel = playedEvent;
    
    [[self giveMeNavigationViewController] pushViewController:appInGameViewController animated:TRUE];
}

-(void) GCDidSelectElement:(id)dataElement atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
    // Custom Elements in Played Event List
}

-(void) GCDidSelectTrophie:(GCTrophyModel *)trophie atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
    GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
    [[self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
    [pushInfoViewController addPushInfos:[[profileViewController.cv_trophies.data getXpathNilArray:@"flux"] reversedArray]];
    [pushInfoViewController preselectItemAtIndex:indexPath.row];
}

-(void) GCDidRequestProfileEdition:(GCGamerModel *)gamerModel fromViewController:(UIViewController *)viewController
{
    GCAPPProfileEditionViewController *appProfileEditionViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPProfileEditionVCIdentifier];
    appProfileEditionViewController.gamerModel = gamerModel;
    
    [[self giveMeNavigationViewController] pushViewController:appProfileEditionViewController animated:TRUE];
}

-(void) GCShareTrophy:(GCTrophyModel *)trophyModel fromViewController:(GCPushInfoViewController *)pushInfoViewController
{
    NSArray *arrayOfActivityItems = @[NSLocalizedString(@"gc_text_sharing_trophy", nil), trophyModel.name, @"\n", APPLE_STORE_SHARING_URL];
    
    GCPushInfoView *viewInCarousel = (GCPushInfoView *)[pushInfoViewController.ic_view currentItemView];
    if (viewInCarousel && [viewInCarousel isKindOfClass:[GCPushInfoView class]])
        [self shareWithItems:arrayOfActivityItems fromSourceView:viewInCarousel.bt_sharing];
}

-(void) GCDidSaveProfileModicationFromViewController:(GCProfileEditionViewController *)profileEditionViewController
{
    [[self giveMeNavigationViewController] popViewControllerAnimated:YES];
}

#pragma mark - League
-(void) GCDidRequestLeaguesFrom:(GCMasterViewController *)senderViewController
{
    GCAPPLeaguesViewController *leaguesViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPLeaguesVCIdentifier];
    [[self giveMeNavigationViewController] pushViewController:leaguesViewController animated:TRUE];
}

-(void) GCDidSelectLeague:(GCLeagueModel *)leagueModel fromViewController:(GCLeaguesViewController *)leaguesViewController
{
    UINavigationController *navigationController = (UINavigationController *)[self giveMeNavigationViewController];

    if (navigationController && [navigationController isKindOfClass:[UINavigationController class]])
    {
        GCAPPLeaguesViewControlleriPad *leaguesViewControlleriPad = (GCAPPLeaguesViewControlleriPad *)navigationController.topViewController;
        
        if (leaguesViewControlleriPad && [leaguesViewControlleriPad isKindOfClass:[GCAPPLeaguesViewControlleriPad class]])
            [leaguesViewControlleriPad setSelectedLeague:leagueModel];
    }
}

#pragma mark - League Edition
-(void) GCDidRequestLeagueInvitation:(GCLeagueModel *)leagueModel fromViewController:(GCMasterViewController *)senderViewController
{
    GCAPPLeagueEditionViewController *leagueEditionViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPLeagueEditionVCIdentifier];
    leagueEditionViewController.leagueToEdit = leagueModel;
    [[self giveMeNavigationViewController] pushViewController:leagueEditionViewController animated:TRUE];
    
    [leagueEditionViewController goToLeagueInvitation];
}

-(void) GCDidRequestLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCConnectViewController *)senderViewController
{
    GCAPPLeagueEditionViewController *leagueEditionViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPLeagueEditionVCIdentifier];
    leagueEditionViewController.leagueToEdit = leagueModel;
    [[self giveMeNavigationViewController] pushViewController:leagueEditionViewController animated:TRUE];
    
    if (leagueModel)
        [leagueEditionViewController goToLeagueNameModification];
    else
        [leagueEditionViewController goToLeagueCreation];
}

-(void) GCDidSaveLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCLeagueEditionViewController *)leagueEditionViewController
{
    [[self giveMeNavigationViewController] popViewControllerAnimated:YES];
}

-(void) GCDidDeleteLeague:(GCLeagueModel *)leagueModel fromViewController:(GCMasterViewController *)senderViewController
{
}

-(void) GCDidQuitLeague:(GCLeagueModel *)leagueModel fromViewController:(GCMasterViewController *)senderViewController
{
}

#pragma mark - Ranking
-(void) GCDidRequestRankingsFrom:(GCMasterViewController *)senderViewController
{
    GCAPPRankingsViewController *rangkinsViewControlleriPad = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPRankingsCVIdentifier];
    rangkinsViewControlleriPad.competitionModel = [GCCompetitionManager getInstance].competitionDefault;
    [[self giveMeNavigationViewController] pushViewController:rangkinsViewControlleriPad animated:TRUE];
}

-(void) GCDidSelectUser:(GCRankingModel *)rankingModel fromViewController:(GCConnectViewController *)rankingsViewController
{
    GCAPPProfileViewController *profileViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPProfileVCIdentifier];
    
    if (rankingModel && [rankingModel isKindOfClass:[GCRankingModel class]])
        profileViewController.gamerModel = rankingModel.gamer;
    
    [[self giveMeNavigationViewController] pushViewController:profileViewController animated:TRUE];
}

#pragma mark - Questions
-(void) GCDidSelectQuestion:(GCQuestionModel *)questionModel fromViewController:(GCInGameViewController *)inGameViewController
{
    GCAPPAnswersViewController *answersViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPAnswersVCIdentifier];

    if ([questionModel isQuestionActive] && [questionModel.my_answers count] == 0)
        [answersViewController updateNewQuestion:questionModel];
    else
        [answersViewController updateStatsQuestion:questionModel];
    
    [[self giveMeNavigationViewController] pushViewController:answersViewController animated:TRUE];
}

-(void) GCDidAnswerQuestion:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)inGameViewController
{
}

-(void) GCShareQuestion:(GCQuestionModel *)questionModel fromViewController:(GCMasterViewController *)senderViewController
{
    NSArray *arrayOfActivityItems = @[NSLocalizedString(@"gc_text_sharing_question", nil), questionModel.question, @"\n", APPLE_STORE_SHARING_URL];
    
    if ([senderViewController isKindOfClass:[GCAnswersViewController class]])
    {
        GCAnswersViewController *answersViewController = (GCAnswersViewController *)senderViewController;
        [self shareWithItems:arrayOfActivityItems fromSourceView:answersViewController.bt_sharing];
    }
    else if ([senderViewController isKindOfClass:[GCPushInfoViewController class]])
    {
        GCPushInfoViewController *pushInfoViewController = (GCPushInfoViewController *)senderViewController;
        GCPushInfoView *viewInCarousel = (GCPushInfoView *)[pushInfoViewController.ic_view currentItemView];
        if (viewInCarousel && [viewInCarousel isKindOfClass:[GCPushInfoView class]])
            [self shareWithItems:arrayOfActivityItems fromSourceView:viewInCarousel.bt_sharing];
    }
}

-(void)GCDidEndQuestionCountdown:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)answersViewController
{
}

#pragma mark - Push - Faye
-(void) GCDidReceiveNewQuestionNotification:(GCQuestionModel *)questionModel
{
    if (FORCE_NOTIFICATIONS || (self.isWatchingGameConnect && self.isWatchingGameConnect() == NO))
    {
        [self.notificationManager notifyUserForNewQuestion:questionModel];
        return ;
    }

    __weak GCAPPNavigationManageriPad *weak_self = self;
    [priorityPushManager canIManageNewPendingQuestion:questionModel inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{
        
        GCAPPAnswersViewController *answersViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPAnswersVCIdentifier];
        [answersViewController updateNewQuestion:questionModel];
        [[weak_self giveMeNavigationViewController] pushViewController:answersViewController animated:TRUE];

    } andCallBackIfUserShouldBeNotified:^{
        [weak_self.notificationManager notifyUserForNewQuestion:questionModel];
    }];
}

-(void) GCDidReceiveStatsQuestionNotification:(GCQuestionModel *)questionModel
{
    if ([priorityPushManager canIManageQuestionStats:questionModel inNavigationController:[self giveMeNavigationViewController]] == NO)
    {
        // Nothing Todo
    }
}

-(void) GCDidReceiveEndQuestionNotification:(GCQuestionModel *)questionModel
{
    [priorityPushManager canIManageQuestionEnd:questionModel inNavigationController:[self giveMeNavigationViewController]];
    [self.notificationManager notifyUserEndQuestion:questionModel];
}

-(void) GCDidReceiveResultQuestionNotification:(GCQuestionModel *)questionModel
{
    if (FORCE_NOTIFICATIONS || (self.isWatchingGameConnect && self.isWatchingGameConnect() == NO))
    {
        [self.notificationManager notifyUserForNewResult:questionModel];
        return ;
    }
    
    __weak GCAPPNavigationManageriPad *weak_self = self;
    [priorityPushManager canIManageQuestionResult:questionModel inNavigationController:[weak_self giveMeNavigationViewController] callBackPushNewViewController:^{

        GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
        [[weak_self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
        [pushInfoViewController addPushInfos:@[questionModel]];

    } andCallBackIfUserShouldBeNotified:^{
        [self.notificationManager notifyUserForNewResult:questionModel];
    }];
}

-(void) GCDidReceiveTrophyNotification:(GCTrophyModel *)trophyModel
{
    if (FORCE_NOTIFICATIONS || (self.isWatchingGameConnect && self.isWatchingGameConnect() == NO))
    {
        [self.notificationManager notifyUserForNewTrophy:trophyModel];
        return ;
    }
    
    __weak GCAPPNavigationManageriPad *weak_self = self;
    [priorityPushManager canIManageNewTrophy:trophyModel inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{

        GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
        [[weak_self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
        [pushInfoViewController addPushInfos:@[trophyModel]];

    } andCallBackIfUserShouldBeNotified:^{
        [self.notificationManager notifyUserForNewTrophy:trophyModel];
    }];
}

-(void) GCDidReceiveRankUpdateForEvent:(GCPushRankingEventModel *)pushRankEventModel
{
    if ([priorityPushManager canIManageEventRanking:pushRankEventModel inNavigationController:[self giveMeNavigationViewController]] == NO)
    {
        // Nothing to do
    }
}

-(void) GCDidReceiveNewEventNotification:(GCEventModel *)eventModel
{
    if ([priorityPushManager canIManageNewEvent:eventModel inNavigationController:[self giveMeNavigationViewController]] == NO)
    {
        // Notification for New event ?
    }
}

-(void) GCDidReceiveEndEventNotification:(GCEventModel *)eventModel
{
    [priorityPushManager canIManageEndEvent:eventModel inNavigationController:[self giveMeNavigationViewController]];
    [self.notificationManager notifyUserEndEvent:eventModel];
}

#pragma mark - NOTIFICATIONS
-(void) GCDidSelectQuestion:(GCQuestionModel *)questionModel fromNotification:(GCNotificationView *)notificationView
{
    __weak GCAPPNavigationManageriPad *weak_self = self;
    [priorityPushManager canIManageNewPendingQuestion:questionModel inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{

        GCAPPAnswersViewController *answersViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPAnswersVCIdentifier];
        [[weak_self giveMeNavigationViewController] pushViewController:answersViewController animated:TRUE];
        [answersViewController updateNewQuestion:questionModel];

    } andCallBackIfUserShouldBeNotified:^{
        [priorityPushManager forceUpdateQuestion:questionModel inNavigationController:[weak_self giveMeNavigationViewController]];
    }];
}

-(void) GCDidRequestPushInfoFromNotification:(GCNotificationView *)notificationView forPushInfos:(NSArray *)arrayOfPushInfos
{
    __weak GCAPPNavigationManageriPad *weak_self = self;
    [priorityPushManager canIManagePushInfos:arrayOfPushInfos inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{
        
        GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
        [[weak_self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
        [pushInfoViewController addPushInfos:arrayOfPushInfos];
        
    } andCallBackIfUserShouldBeNotified:^{

        // Take control anymay
        if ([priorityPushManager forceUpdatePushInfos:arrayOfPushInfos inNavigationController:[weak_self giveMeNavigationViewController]] == NO)
        {
            GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPAD instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
            [[self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
            [pushInfoViewController addPushInfos:arrayOfPushInfos];
        }
    }];
}


@end
