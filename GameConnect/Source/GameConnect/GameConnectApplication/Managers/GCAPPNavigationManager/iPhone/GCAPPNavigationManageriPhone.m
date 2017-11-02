//
//  GCAPPNavigationManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPNavigationManageriPhone.h"
#import "Extends+Libs.h"

#import "GCAPPGameViewController.h"
#import "GCAPPLeaguesViewController.h"
#import "GCAPPRankingsViewController.h"
#import "GCAPPLeagueRankingsViewController.h"
#import "GCAPPLeagueEditionViewController.h"
#import "GCAPPProfileViewController.h"
#import "GCAPPAnswersViewController.h"
#import "GCAPPLoginViewControlleriPhone.h"
#import "GCAPPSubscribeViewControlleriPhone.h"
#import "GCAPPProfileEditionViewController.h"
#import "GCAPPPushInfoViewController.h"
#import "GCAPPHomeViewControlleriPhone.h"
//#import "PSGOneApp-Swift.h"
#import "GCGamerManager.h"
#import "GCCompetitionManager.h"
#import "GCAPPDefines.h"
#import "BridgedLanguageManager.h"

@interface GCAPPNavigationManageriPhone()
@end

@implementation GCAPPNavigationManageriPhone

+(instancetype) getInstance
{
  static GCAPPNavigationManageriPhone *sharedMyManager = nil;
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
    loadingViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPLoadingVCIdentifier];
    loadingViewController.view.backgroundColor = GC_BLUE_COLOR;
    [self performWithDelay:0.3 block:^{

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
    loadingViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPLoadingVCIdentifier];
    loadingViewController.view.backgroundColor = GC_BLUE_COLOR;

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
  else
  {
    DLog(@"Loading view controller doesn't exist!");
  }
}

#pragma mark - Authentification
-(void) GCDidRequestAuthentificationFrom:(GCMasterViewController *)GCViewControllerSender
{
  if (!navigationControllerAuthentification)
  {
    GCAPPLoginViewControlleriPhone *gameConnectLoginViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPLoginVCIdentifier];
    navigationControllerAuthentification =
    [[GCAPPNavigationController alloc] initWithRootViewController:gameConnectLoginViewController];

    [self performWithDelay:0.5 block:^{
      [[self giveMeNavigationViewController].topViewController.view
       addSubviewToBonce:navigationControllerAuthentification.view];
      [[self giveMeNavigationViewController].topViewController
       addChildViewController:navigationControllerAuthentification];
      //            [[self giveMeNavigationViewController] presentViewController:navigationControllerAuthentification
      //                                                                animated:YES completion:^{
      //                [[self giveMeNavigationViewController] popToRootViewControllerAnimated:YES];
      //            }];
    }];
  }
  else
    DLog(@"Authentification process already in use !");

  [self.notificationManager closeAllNotifications];
}

-(void) GCDidRequestSubscribeFrom:(GCConnectViewController *)GCViewControllerSender
{
  if (navigationControllerAuthentification)
  {
    GCAPPSubscribeViewControlleriPhone *subscribeViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPSubscribeVCIdentifier];
    [[self giveMeNavigationViewController] pushViewController:subscribeViewController
                                                     animated:YES];

    //        SlideMenuViewController *slideMenuViewController =
    //            (SlideMenuViewController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    //        UINavigationController *navigationController = (UINavigationController*)slideMenuViewController.mainViewController;
    //        [navigationController pushViewController:subscribeViewController
    //                                        animated:YES];
    ////        [navigationControllerAuthentification pushViewController:subscribeViewController animated:TRUE];
  }
  else
    DLog(@"The navigationController for the authentification process doesn't exist");
}

-(void) GCDidEndAuthentificationFrom:(GCMasterViewController *)GCViewControllerSender
{
  if (navigationControllerAuthentification && ![navigationControllerAuthentification isBeingDismissed])
  {
    [navigationControllerAuthentification.view removeFromSuperview];
    [navigationControllerAuthentification removeFromParentViewController];
    //        [navigationControllerAuthentification dismissViewControllerAnimated:YES completion:^{
    //        }];
  }
  else
    DLog(@"The navigationController for the authentification process doesn't exist");
  navigationControllerAuthentification = nil;
}

#pragma mark - Event
-(void) GCDidSelectEvent:(GCEventModel *)eventModel atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController
{
  GCAPPGameViewController *appInGameViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPGameVCIdentifier];
  appInGameViewController.eventModel = eventModel;

  [[self giveMeNavigationViewController] pushViewController:appInGameViewController animated:TRUE];
}

-(void) GCDidSelecElement:(id)dataElement atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController
{
  if (dataElement && [dataElement isKindOfClass:[NSDictionary class]]) {
    NSInteger type = [(NSDictionary *)dataElement getXpathInteger:@"type"];
    GCConfManager *gcConfigModel = [GCConfManager getInstance];
    switch (type) {
      case 0:
      {
        NSString *awardsURLString;
        if ([[BridgedLanguageManager applicationLanguage] isEqualToString:@"fr"]) {
          awardsURLString = gcConfigModel.awardsFrURLString;
        } else {
          awardsURLString = gcConfigModel.awardsEnURLString;
        }
        [self pushWebViewControllerWithURLString:awardsURLString pinToTopLayoutGuide:NO];
      }
        break;
      case 1:
        break;
      case 2:
      {
        GCAPPRankingsViewController *rangkinsViewControlleriPhone = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPRankingsCVIdentifier];
        rangkinsViewControlleriPhone.competitionModel = [GCCompetitionManager getInstance].competitionDefault;
        [[self giveMeNavigationViewController] pushViewController:rangkinsViewControlleriPhone animated:TRUE];
      }
        break;
      case 3:
        [self pushWebViewControllerWithURLString:gcConfigModel.regulationsURLString pinToTopLayoutGuide:YES];
      default:
        break;
    }
  }
}

#pragma mark - Profile
-(void) GCDidSelectPlayedEvent:(GCEventModel *)playedEvent atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
  GCAPPGameViewController *appInGameViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPGameVCIdentifier];
  appInGameViewController.eventModel = playedEvent;

  [[self giveMeNavigationViewController] pushViewController:appInGameViewController animated:TRUE];
}

-(void) GCDidSelectElement:(id)dataElement atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
  // If click on custom element in this list.
  // ProfileViewController can be initialized via a Linker. So any render could be in it.
}

-(void) GCDidSelectTrophie:(GCTrophyModel *)trophie atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
  GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
  [[self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
  [pushInfoViewController addPushInfos:[[profileViewController.cv_trophies.data getXpathNilArray:@"flux"] reversedArray]];
  [pushInfoViewController preselectItemAtIndex:indexPath.row];
}

-(void) GCDidRequestProfileEdition:(GCGamerModel *)gamerModel fromViewController:(UIViewController *)viewController
{
  if (![gamerModel._id isEqualToString:[GCGamerManager getInstance].gamer._id]) {
    return;
  }
  GCAPPProfileEditionViewController *appProfileEditionViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPProfileEditionVCIdentifier];
  appProfileEditionViewController.gamerModel = gamerModel;

  [[self giveMeNavigationViewController] pushViewController:appProfileEditionViewController animated:TRUE];
  //	[((AppDelegate *)[UIApplication sharedApplication].delegate) setupProfileViewControllerAsTopViewController];
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
-(void) GCDidSelectLeague:(GCLeagueModel *)leagueModel fromViewController:(GCLeaguesViewController *)leaguesViewController
{
  GCAPPLeagueRankingsViewController *leagueRankingsViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPLeagueRankingsVCIdentifier];
  leagueRankingsViewController.leagueModel = leagueModel;
  [[self giveMeNavigationViewController] pushViewController:leagueRankingsViewController animated:TRUE];
}

#pragma mark - League Edition
-(void) GCDidRequestLeagueInvitation:(GCLeagueModel *)leagueModel fromViewController:(GCMasterViewController *)senderViewController
{
  GCAPPLeagueEditionViewController *leagueEditionViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPLeagueEditionVCIdentifier];
  leagueEditionViewController.leagueToEdit = leagueModel;

  [self performWithDelay:0.5 block:^{
    [[self giveMeNavigationViewController] pushViewController:leagueEditionViewController animated:TRUE];
    [leagueEditionViewController goToLeagueInvitation];
  }];
}

-(void) GCDidRequestLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCConnectViewController *)senderViewController
{
  GCAPPLeagueEditionViewController *leagueEditionViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPLeagueEditionVCIdentifier];
  leagueEditionViewController.leagueToEdit = leagueModel;

  [self performWithDelay:0.5 block:^{
    [[self giveMeNavigationViewController] pushViewController:leagueEditionViewController animated:TRUE];

    if (leagueModel)
      [leagueEditionViewController goToLeagueNameModification];
    else
      [leagueEditionViewController goToLeagueCreation];
  }];
}

-(void) GCDidSaveLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCLeagueEditionViewController *)leagueEditionViewController
{
  [[self giveMeNavigationViewController] popViewControllerAnimated:YES];
}

-(void) GCDidDeleteLeague:(GCLeagueModel *)leagueModel fromViewController:(GCMasterViewController *)senderViewController
{
  [[self giveMeNavigationViewController] popViewControllerAnimated:YES];
}

-(void) GCDidQuitLeague:(GCLeagueModel *)leagueModel fromViewController:(GCMasterViewController *)senderViewController
{
  [[self giveMeNavigationViewController] popViewControllerAnimated:YES];
}

#pragma mark - Ranking
-(void) GCDidSelectUser:(GCRankingModel *)rankingModel fromViewController:(GCConnectViewController *)rankingsViewController
{
  GCAPPProfileViewController *profileViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPProfileVCIdentifier];

  if (rankingModel && [rankingModel isKindOfClass:[GCRankingModel class]])
    profileViewController.gamerModel = rankingModel.gamer;

  [[self giveMeNavigationViewController] pushViewController:profileViewController animated:TRUE];
}

#pragma mark - Questions
-(void) GCDidSelectQuestion:(GCQuestionModel *)questionModel fromViewController:(GCInGameViewController *)inGameViewController
{
  GCAPPAnswersViewController *answersViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPAnswersVCIdentifier];
  [answersViewController updateNewQuestion:questionModel];
  [[self giveMeNavigationViewController] pushViewController:answersViewController animated:TRUE];
}

-(void) GCDidAnswerQuestion:(GCQuestionModel *)questionModel fromViewController:(GCAnswersViewController *)inGameViewController
{
  [self.notificationManager onAnswerQuestion:questionModel];
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

#pragma mark - Push Faye
-(void) GCDidReceiveNewQuestionNotification:(GCQuestionModel *)questionModel
{
  if (FORCE_NOTIFICATIONS || (self.isWatchingGameConnect && self.isWatchingGameConnect() == NO))
  {
    [self.notificationManager notifyUserForNewQuestion:questionModel];
    return ;
  }

  [priorityPushManager canIManageNewPendingQuestion:questionModel inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{

    [self openGameConnect];

    GCAPPAnswersViewController *answersViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPAnswersVCIdentifier];
    [answersViewController updateNewQuestion:questionModel];
    [[self giveMeNavigationViewController] pushViewController:answersViewController animated:TRUE];

  } andCallBackIfUserShouldBeNotified:^{
    [self.notificationManager notifyUserForNewQuestion:questionModel];
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

  [priorityPushManager canIManageQuestionResult:questionModel inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{

    GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
    [[self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
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

  [priorityPushManager canIManageNewTrophy:trophyModel inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{

    GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
    [[self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
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
  __weak GCAPPNavigationManageriPhone *weak_self = self;
  [priorityPushManager canIManageNewPendingQuestion:questionModel inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{

    [weak_self openGameConnect];

    GCAPPAnswersViewController *answersViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPAnswersVCIdentifier];
    [answersViewController updateNewQuestion:questionModel];
    [[weak_self giveMeNavigationViewController] pushViewController:answersViewController animated:TRUE];

  } andCallBackIfUserShouldBeNotified:^{
    [weak_self openGameConnect];
    [priorityPushManager forceUpdateQuestion:questionModel inNavigationController:[weak_self giveMeNavigationViewController]];
  }];
}

-(void) GCDidRequestPushInfoFromNotification:(GCNotificationView *)notificationView forPushInfos:(NSArray *)arrayOfPushInfos
{
  __weak GCAPPNavigationManageriPhone *weak_self = self;
  [priorityPushManager canIManagePushInfos:arrayOfPushInfos inNavigationController:[self giveMeNavigationViewController] callBackPushNewViewController:^{

    [weak_self openGameConnect];

    GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
    [[weak_self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
    [pushInfoViewController addPushInfos:arrayOfPushInfos];

  } andCallBackIfUserShouldBeNotified:^{

    // Take control anymay
    if ([priorityPushManager forceUpdatePushInfos:arrayOfPushInfos inNavigationController:[weak_self giveMeNavigationViewController]] == NO)
    {
      [weak_self openGameConnect];

      GCAPPPushInfoViewController *pushInfoViewController = [GCAPPSTORYBOARDIPHONE instantiateViewControllerWithIdentifier:GCAPPPushInfoVCIdentifier];
      [[self giveMeNavigationViewController] pushViewController:pushInfoViewController animated:TRUE];
      [pushInfoViewController addPushInfos:arrayOfPushInfos];
    }
  }];
}


@end
