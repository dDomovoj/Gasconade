//
//  GCLeagueEditionViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "GCLeagueEditionViewController.h"
#import "GCProcessLeagueManager.h"
#import "GCInvitationGroupRender.h"
#import "GCLeagueManager.h"
#import "NsSnUserManager.h"
#import "NsSnImportNetworkManager.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"
#import "NsSnSignManager.h"

@interface GCLeagueEditionViewController ()
<FBLoginViewDelegate>
{
    BOOL hasAlreadyFetchedUserInformation;

    NSString *leagueNameEdition;
    eLeagueEditionState editionType;
    NSArray  *nsapiFriends;
    NSMutableArray *invitedFbFriends;
}
@end

@implementation GCLeagueEditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        hasAlreadyFetchedUserInformation = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"profile_edition_bg")];
    [self initLeagueEditionViewWithName];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (editionType == eLeagueEditionName || editionType == eLeagueEditionBoth)
    {
        [self.sv_leagueContent scrollRectToVisible:self.v_containerLeagueName.frame animated:YES];
        [self.tf_leagueName becomeFirstResponder];
    }
}

// Name Screen
-(void)initLeagueEditionViewWithName
{
    if (self.leagueEditing)
        [self.bt_save setTitle:NSLocalizedString(@"gc_save_bt", nil) forState:UIControlStateNormal];
    else
        [self.bt_save setTitle:NSLocalizedString(@"gc_add_people", nil) forState:UIControlStateNormal];
    
    [self.bt_save.titleLabel setFont:CONFFONTBOLDSIZE(17)];
    [self.bt_save setTitleColor:CONFCOLORFORKEY(@"validate_bt") forState:UIControlStateNormal];

    if (self.leagueEditing)
        [self.lb_title setText:[NSLocalizedString(@"gc_edit_league", nil) uppercaseString]];
    else
        [self.lb_title setText:[NSLocalizedString(@"gc_create_league", nil) uppercaseString]];

    [self.lb_title setFont:CONFFONTMEDIUMSIZE(13)];
    [self.lb_title setTextColor:CONFCOLORFORKEY(@"title_form_lb")];
    
    self.tf_leagueName.delegate = self;
    self.tf_leagueName.font = CONFFONTREGULARSIZE(15);
    self.tf_leagueName.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    [self.tf_leagueName setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_league_name", nil) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
}

-(void)loadData
{ }

-(void)initWithLeagueEditionState:(eLeagueEditionState)leagueEditionState
{
    editionType = leagueEditionState;
    
    if (FBSession.activeSession.state == FBSessionStateOpen ||
        FBSession.activeSession.state == FBSessionStateOpenTokenExtended ||
        FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [self.v_facebookLogin setAlpha:0];
        [self.bt_save setAlpha:1];
    }
    else
    {
        [self showFacebookLoginView];
        return ;
    }
    
    if (editionType == eLeagueEditionName || editionType == eLeagueEditionBoth)
        [self goToLeagueNameEdition];
    else if (editionType == eLeagueEditionInvitation)
        [self goToFriendsInvitationList];
    else
        DLog(@"Bad leagueEditionState !");
}

-(void)goToFriendsInvitationList
{
    [self.tf_leagueName resignFirstResponder];
    [self showInviteFacebookFriends];
}

-(void)goToLeagueNameEdition
{
    if (self.leagueEditing && self.leagueEditing.name)
        self.tf_leagueName.text = self.leagueEditing.name;

    [self.tf_leagueName becomeFirstResponder];
}

-(void)inviteFriendsFromFB:(NSArray *)friends
{
    [self loading];

    [[NsSnUserManager getInstance] getFriendsListPaginated:[NsSnUserManager getInstance].user page:1 limit:500 cb_rep:^(BOOL ok, NSInteger nbFriends, NsSnUserModel *user)
//     {
         
//     }];
//    [[NsSnUserManager getInstance] getFriendsList:[NsSnUserManager getInstance].user cb_rep:^(NsSnUserModel *user, BOOL ok)
     {
         [GCLeagueManager sortArrayOfFBFriends:friends andArrayOfNSAPIFriends:[NsSnUserManager getInstance].user.Friends thenCallBack:^(NSArray *fbFriendsInNSAPI, NSArray *fbOthers, NSArray *arrayNSAPIUserOnFacebook, NSArray *allSortedByName)
         {
             if (!self.leagueEditing) // CREATION MODE
             {
                 [self createLeague:leagueNameEdition andCallback:^(GCLeagueModel *createdLeague)
                  {
                      [self setFlashMessage:NSLocalizedString(@"gc_league_created", nil)];
                      if (arrayNSAPIUserOnFacebook && [arrayNSAPIUserOnFacebook count] > 0)
                          [self leagueModificationSavingWithGamers:arrayNSAPIUserOnFacebook];
                      else
                          [[GCProcessLeagueManager sharedManager] leagueModifcationSaved:self.leagueEditing fromViewController:self];
                  }];
             }
             else // EDITION MODE
             {
                 if (!self.leagueEditing.name)
                     self.leagueEditing.name = leagueNameEdition;
                 [self leagueModificationSavingWithGamers:arrayNSAPIUserOnFacebook];
             }
         }];
     }];
}

-(void) leagueModificationSavingWithGamers:(NSArray *)gamers
{
    if (!self.leagueEditing || !self.leagueEditing._id)
    {
        DLog(@"LeagueModel doesn't exist");
        return;
    }
    
    [self loading];
    [GCLeagueManager putLeagueEdition:self.leagueEditing._id withName:self.leagueEditing.name gamers:[NsSnUserModel arrayOfIdsFromNSAPIUsers:gamers] cb_response:^(BOOL success)
     {
         [self endLoadingWithFBConnect:NO];
         
         // LEAGUE ALREADY CREATED
         // FRIENDS ADDED  => OK
         
         if (gamers && [gamers count] > 0)
             [self setFlashMessage:NSLocalizedString(@"gc_people_invited", nil)];
         
         [[GCProcessLeagueManager sharedManager] leagueModifcationSaved:self.leagueEditing fromViewController:self];
     }];
}

-(void) createLeague:(NSString *)name andCallback:(void(^)(GCLeagueModel *createdLeague))callbackLeagueCreation
{
    if (!name || [name length] == 0)
    {
        DLog(@"League name doesn't exist! Cannot create new league.");
        return ;
    }
    [self loading];
    [GCLeagueManager postNewLeague:name cb_response:^(BOOL success, GCLeagueModel *createdLeague)
    {
        if (!success)
            [self setFlashMessage:NSLocalizedString(@"gc_league_fail_to_create", nil)];
        else
            [self setFlashMessage:NSLocalizedString(@"gc_league_success_creation", nil)];

        _leagueEditing = createdLeague;
        [self endLoadingWithFBConnect:NO];
        
        if (callbackLeagueCreation)
            callbackLeagueCreation(createdLeague);
    }];
}

- (IBAction)clickOnValidateButton:(id)sender
{
    leagueNameEdition = [self.tf_leagueName.text trim];
    if ([GCLeagueModel validateLeagueName:leagueNameEdition] == NO)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_league_name_length_restriction", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
    }
    else
    {
        if (self.leagueEditing)
            self.leagueEditing.name = leagueNameEdition;
        
        if (editionType ==  eLeagueEditionBoth)
            [self goToFriendsInvitationList];
        else
            [self leagueModificationSavingWithGamers:nil];
    }
}

-(void)showFacebookLoginView
{
    if (!self.bt_fb_login)
    {
        self.bt_fb_login = [[FBLoginView alloc] initWithReadPermissions:@[@"email", @"user_friends"]];
        [self.v_facebookLogin addSubviewToBonce:self.bt_fb_login autoSizing:YES];
        self.bt_fb_login.delegate = self;
    }
    [self.bt_save setAlpha:0];
    [self.v_facebookLogin setAlpha:1];
    [self.tf_leagueName setEnabled:YES];
}

- (void)showInviteFacebookFriends
{
    invitedFbFriends = [NSMutableArray new];
    [self loading];

    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:[FBSession activeSession]
     message:  NSLocalizedString(@"gc_invitation_league", nil)
     title:@""
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
    {
        if (error)
         {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
             [self.bt_save setAlpha:1];
         }
         else
         {
             if (result == FBWebDialogResultDialogNotCompleted)
             {
                 NSLog(@"User canceled request.");
                 [self cancelPeopleAdding];
             }
             else
             {
                 // Handle the send request callback
                 NSLog(@"Request Sent. %@",resultURL);
                 //fbconnect://success?error_code=4201&error_message=User+canceled+the+Dialog+flow
                 
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"])
                 {
                     NSLog(@"User canceled request.");
                     [self cancelPeopleAdding];
                 }
                 else
                 {
//                     [self loading];
                     [[urlParams allKeys] enumerateObjectsUsingBlock:^(id objectKey, NSUInteger idx, BOOL *stop)
                      {
                          if (objectKey && [objectKey isKindOfClass:[NSString class]] && [objectKey hasPrefix:@"to"])
                          {
                              [invitedFbFriends addObject:[urlParams objectForKey:objectKey]];

                              if (idx == [[urlParams allKeys] count] - 1)
                                  [self inviteFriendsFromFB:invitedFbFriends];
                          }
                          else
                          {
                              DLog(@"Object in user is not correct. Terminating here...");
                          }
                      }];
                 }
             }
         }
    }];
}

-(void)cancelPeopleAdding
{
    [self.tf_leagueName setEnabled:YES];
    [self endLoadingWithFBConnect:NO];
    editionType = eLeagueEditionBoth;
    
    [self.bt_save setTitle:NSLocalizedString(@"gc_add_people", nil) forState:UIControlStateNormal];
    [self.bt_save setAlpha:1];
    [self goToLeagueNameEdition];
}

- (NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

-(void)loading
{
    [self startLoaderInView:self.bt_save andHideView:YES];
    [self.v_facebookLogin setAlpha:0];
}

-(void)endLoadingWithFBConnect:(BOOL)showFacebook
{
    [self stopLoader];
    
    if (showFacebook)
    {
        [self.bt_save setAlpha:0];
        [self.v_facebookLogin setAlpha:1];
    }
    else
    {
        [self.bt_save setAlpha:1];
        [self.v_facebookLogin setAlpha:0];
    }
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"GCLoginNSAPIViewController : loginViewShowingLoggedInUser");
    [self loading];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"GCLoginNSAPIViewController : loginViewFetchedUserInfo => %@", [user description]);
    
    if (hasAlreadyFetchedUserInformation)
    {
        [self endLoadingWithFBConnect:NO];
        return ;
    }
    hasAlreadyFetchedUserInformation = YES;
    [self.tf_leagueName setEnabled:YES];
    
    if ([NsSnSignManager isHeConnectedUsingThirdParty:[NsSnUserManager getInstance].user] == eNsSnThirdPartyConnectionFB)
    {
        [self endLoadingWithFBConnect:NO];
        if (editionType == eLeagueEditionBoth || editionType == eLeagueEditionName)
            [self goToLeagueNameEdition];
        else
            [self goToFriendsInvitationList];
    }
    else
    {
        __weak GCLeagueEditionViewController *weak_self = self;
        [NsSnImportNetworkManager importNetworkFromFacebook:[FBSession activeSession].accessTokenData.accessToken cb_rep:^(BOOL ok, NSDictionary *response)
        {
            [weak_self endLoadingWithFBConnect:NO];
            if (editionType == eLeagueEditionBoth || editionType == eLeagueEditionName)
                [weak_self goToLeagueNameEdition];
            else
                [weak_self goToFriendsInvitationList];
        }];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"GCLoginNSAPIViewController : loginViewShowingLoggedOutUser");
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_error_connection_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];

    NSLog(@"GCLoginNSAPIViewController : handleAuthError => %@", error);
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self clickOnValidateButton:self.bt_save];
    return YES;
}

#pragma UICollectionViewGGDelegate
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView
{
    [self setFlashMessage:NSLocalizedString(@"gc_invited", nil)];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
        [self.tf_leagueName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
    
