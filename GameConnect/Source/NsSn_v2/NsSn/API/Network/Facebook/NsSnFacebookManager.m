//
//  NsSnFacebookManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 21/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "NsSnFacebookManager.h"
#import "UIImageViewJA.h"
#import "NsSnSignManager.h"

@implementation NsSnFacebookManager

//#pragma mark Facebook Connect
//-(void)uploadAvatarFromFB
//{
//    imageViewAvatarDL = [[UIImageViewJA alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    
//    [imageViewAvatarDL loadImageFromURL:fb_avatar_url ttl:60*60 endblock:^(UIImageViewJA *image)
//     {
//         [[NsSnUserManager getInstance] uploadAvatar:image.image cb_send:^(long long total, long long current)
//          {
//          } cb_rep:^(NSDictionary *rep, NsSnUserErrorValue error)
//          {
//              [self setFlashMessage:NSLocalizedString(@"gc_success_login_with_fb", @"")];
//              [self stopLoaderInView:self.v_facebook andShowView:YES];
//              [[GCProcessAuthentificationManager getInstance] endAuthentificationFrom:self];
//          }];
//     }];
//}
//
//-(void)tryToLogin:(NsSnSignModel *)userModel uploadAvatar:(BOOL)uploadAvatar_
//{
//    [self.lb_connexionStatus setAlpha:1];
//    [self.lb_connexionStatus setText:NSLocalizedString(@"gc_auth_proceeding", nil)];
//    
//    [[GCGamerManager getInstance] login:userModel.login passe:userModel.password cb_rep:^(BOOL ok, NsSnUserErrorValue error)
//     {
//         if (ok)
//         {
//             if (uploadAvatar_)
//                 [self uploadAvatarFromFB];
//             else
//             {
//                 [self setFlashMessage:NSLocalizedString(@"gc_success_login", @"")];
//                 [self stopLoaderInView:self.v_facebook andShowView:YES];
//                 [[GCProcessAuthentificationManager getInstance] endAuthentificationFrom:self];
//             }
//         }
//         else
//             [self manageLogin:userModel];
//         
//     }];
//}
//
//-(void)tryToSubscribe:(NsSnSignModel *)signModel
//{
//    [self.lb_connexionStatus setText:NSLocalizedString(@"gc_auth_proceeding", nil)];
//    [[NsSnSignManager getInstance] subscribeAPI:signModel cb_rep:^(BOOL inscription_ok, NSDictionary *rep, NsSnUserErrorValue error)
//     {
//         if (inscription_ok)
//         {
//             [self tryToLogin:signModel uploadAvatar:TRUE];
//         }
//         else
//         {
//             [self.lb_connexionStatus setText:NSLocalizedString(@"gc_login_fail", nil)];
//             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_error_subscribe_fb", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
//             [self stopLoaderInView:self.v_facebook andShowView:YES];
//         }
//     }];
//}
//
//-(void)manageLogin:(NsSnSignModel *)userModel
//{
//    NSString *login_ = userModel.login;
//    
//    [[NsSnSignManager getInstance] checkLoginAvailability:login_ cb_response:^(BOOL ok)
//     {
//         if (ok)
//         {
//             [[NsSnSignManager getInstance] checkEmailAvailability:userModel.email cb_response:^(BOOL ok)
//              {
//                  if (ok)
//                      [self tryToSubscribe:userModel];
//                  else
//                  {
//                      [self.lb_connexionStatus setText:NSLocalizedString(@"gc_login_fail", nil)];
//                      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", nil) message:NSLocalizedString(@"gc_facebook_email_already_used", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", nil) otherButtonTitles:nil]show];
//                      [self stopLoaderInView:self.v_facebook andShowView:YES];
//                  }
//              }];
//         }
//         else
//         {
//             userModel.login = [login_ stringByAppendingString:[NSString stringWithFormat:@"%d", charAtTheEndOfNickname]];
//             charAtTheEndOfNickname++;
//             if (charAtTheEndOfNickname <= 5)
//                 [self manageLogin:userModel];
//             else
//             {
//                 [self.lb_connexionStatus setText:NSLocalizedString(@"gc_login_fail", nil)];
//                 [FBSession.activeSession closeAndClearTokenInformation];
//                 [self.bt_fb_login setAlpha:1];
//                 [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_error_subscribe_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
//                 [self stopLoaderInView:self.v_facebook andShowView:YES];
//             }
//         }
//     }];
//}
//
//#pragma mark - FBLoginViewDelegate
//
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
//{
//    NSLog(@"GCLoginNSAPIViewController : loginViewShowingLoggedInUser");
//    [self startLoaderInView:self.v_facebook andHideView:YES];
//}
//
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
//{
//    NSLog(@"GCLoginNSAPIViewController : loginViewFetchedUserInfo => %@", [user description]);
//    
//    if (hasAlreadyFetchedUserInformation)
//        return ;
//    hasAlreadyFetchedUserInformation = YES;
//    
//    [self startLoaderInView:self.v_facebook andHideView:YES];
//    fb_avatar_url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d", [user id], 300, 300];
//    
//    NSString *mail_user = nil;
//    NSString *id_user = nil;
//    
//    if (user.id)
//        id_user = [user.id sha1];
//    
//    if ([user objectForKey:@"email"])
//        mail_user = [NsSnUserModel formatFacebookEmailFrom:[user objectForKey:@"email"]];
//    if (!id_user)
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_error_connection_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
//        [self stopLoaderInView:self.v_facebook andShowView:YES];
//        return;
//    }
//    
//    if (![user objectForKey:@"email"] || !mail_user)
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_bad_email_conf_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
//        [self stopLoaderInView:self.v_facebook andShowView:YES];
//        return;
//    }
//    
//    NsSnSignModel *s = [NsSnSignModel new];
//    s.login = SWF(@"%@.%@", [user.first_name trim], [user.last_name trim]);
//    s.email = [mail_user trim];
//    s.nom = [[user last_name] trim];
//    s.prenom = [[user first_name] trim];
//    s.password = [id_user trim];
//    s.gender = [[user objectForKey:@"gender"] isEqualToString:@"male"] ? NSGenderMale : NSGenderFemale;
//    s.country = [[NSLocale currentLocale] ISO639_2LanguageIdentifier];
//    
//    [self tryToLogin:s uploadAvatar:TRUE];
//}
//
//- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
//{
//    NSLog(@"GCLoginNSAPIViewController : loginViewShowingLoggedOutUser");
//}
//
//- (void)loginView:(FBLoginView *)loginView
//      handleError:(NSError *)error
//{
//    [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_error_connection_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
//    
//    NSLog(@"GCLoginNSAPIViewController : handleAuthError => %@", error);
//}


@end
