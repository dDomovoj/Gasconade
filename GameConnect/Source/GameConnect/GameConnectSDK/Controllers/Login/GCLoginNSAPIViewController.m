//
//  GCLoginNSAPIViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "NSObject+NSObject_Tool.h"
#import "GCLoginNSAPIViewController.h"
#import "NsSnSignManager.h"
#import "GCSubscribeNSAPIViewController.h"
#import "GCProcessAuthentificationManager.h"
#import "GCLoginNSAPIViewController+GCUI.h"
#import "NSLocale+ISO639_2.h"
#import "GCGamerManager.h"
#import "NsSnImportNetworkManager.h"
#import "Extends+Libs.h"
//#import "PSGOneApp-Swift.h"
#import <Masonry/Masonry.h>

@interface GCLoginNSAPIViewController ()
{
    int             charAtTheEndOfNickname;
    NSString        *fb_avatar_url;
    UIImageViewJA   *imageViewAvatarDL;

    BOOL            hasAlreadyFetchedUserInformation;
}

@property (nonatomic) GCLoginViewController *loginViewController;

- (IBAction)connect_click:(id)sender;
- (IBAction)subscribe_click:(id)sender;
@end

@implementation GCLoginNSAPIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        charAtTheEndOfNickname = 1;
        hasAlreadyFetchedUserInformation = NO;
        _numberOfThirdPartyAvailable = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self initLoginView];
    
    self.loginViewController = [GCLoginViewController new];

    __weak typeof(self) weakSelf = self;
    self.loginViewController.loginSuccessAction = ^{
        [weakSelf launchConnection];
        [weakSelf.loginViewController.view removeFromSuperview];
        [weakSelf.loginViewController removeFromParentViewController];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [weakSelf.view addSubview:indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        [indicatorView startAnimating];
    };
    [self addChildViewController:self.loginViewController];
    [self.view addSubview:self.loginViewController.view];

    [self.loginViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(160);
        make.left.bottom.right.offset(0);
    }];

    [self launchConnection];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)insertSocialNetworkConnect:(eNsSnThirdPartyConnection)thirdParty
{
    _numberOfThirdPartyAvailable += 1;
    [self expandThirdPartyViewContainerFor:thirdParty];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignConnectResponder];
}

- (void)launchConnection
{
    ProfileModel *user = [ProfileModel currentUser];
    if (user) {
        NSString *login = user.email;
        NSString *password = user.password;
        [self launchConnectionWith:login password:password];
    }
}

#pragma mark - 
#pragma mark ProfileViewControllerDelegate_iPhone

- (void)didLoginWith:(NSString *)email password:(NSString *)password
{
    [self launchConnectionWith:email password:password];
}

#pragma UIButton - User Intereactions

- (IBAction)subscribe_click:(id)sender
{
    [[GCProcessAuthentificationManager sharedManager] requestSubscribeFrom:self];
}

- (IBAction)connect_click:(id)sender
{
    [self launchConnection];
}

-(void)launchConnectionWith:(NSString *)email password:(NSString *)password
{
    NsSnSignModel *signModel = [NsSnSignModel new];
    signModel.email = email;
    signModel.password = password;
    
    if ([signModel validateEmail] == eNsSnSignErrorBadEmailFormat)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_email_bad_format", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
        return ;
    }
    else if ([signModel validatePassword] == eNsSnSignErrorPasswordLength)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_password_length_restriction", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
        return;
    }
    NSString *passwordTrimmed = [password trim];
    NSString *emailTrimmed = [email trim];
    
    [self.lb_connexionStatus setAlpha:1];
    [self.lb_connexionStatus setText:NSLocalizedString(@"gc_auth_proceeding", nil)];
    [self startLoaderInView:self.bt_connect andHideView:YES];
    [[GCGamerManager getInstance] loginByMail:emailTrimmed
                                        passe:passwordTrimmed
                                       cb_rep:^(BOOL ok, NsSnUserErrorValue error)
     {
         if (ok)
         {
             [self.lb_connexionStatus setText:NSLocalizedString(@"gc_success_login", nil)];
             [[GCProcessAuthentificationManager sharedManager] endAuthentificationFrom:self];
         }
         else
         {
             [self.lb_connexionStatus setText:NSLocalizedString(@"gc_login_fail", nil)];

             if (error == NsSnUserErrorValueUserNotFound)
             {
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_not_found_login", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
             }
             else
             {
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_failure_login", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
             }
             [self.tf_login becomeFirstResponder];
         }
         [self stopLoaderInView:self.bt_connect andShowView:YES];
     }];
}

#pragma mark Facebook Connect
-(void)uploadAvatarFromFB
{
    imageViewAvatarDL = [[UIImageViewJA alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [imageViewAvatarDL loadImageFromURL:fb_avatar_url ttl:60*60 endblock:^(UIImageViewJA *image)
     {
         [[NsSnUserManager getInstance] uploadAvatar:image.image cb_send:^(long long total, long long current)
         {
         } cb_rep:^(NSDictionary *rep, NsSnUserErrorValue error)
         {
             if (USE_LOCAL_AVATAR)
                 [GCGamerManager getInstance].connectedGamerAvatar = image.image;

             [self setFlashMessage:NSLocalizedString(@"gc_success_login_with_fb", @"")];
             [self stopLoaderInView:self.bt_fb_login andShowView:YES];
             [[GCProcessAuthentificationManager sharedManager] endAuthentificationFrom:self];
         }];
     }];
}

-(void)tryToLogin:(NsSnSignModel *)userModel uploadAvatar:(BOOL)uploadAvatar_
{
    [self.lb_connexionStatus setAlpha:1];
    [self.lb_connexionStatus setText:NSLocalizedString(@"gc_auth_proceeding", nil)];

    [[GCGamerManager getInstance] loginByMail:userModel.email passe:userModel.password cb_rep:^(BOOL ok, NsSnUserErrorValue error)
     {
         if (ok)
         {
             NSMutableDictionary *dictForMetadata = [NSMutableDictionary new];
             NSString *DOB = [userModel dateOfBirthToStringWithFormat:@"MM/dd/yyyy"];
             if (DOB && [DOB length] > 0)
                 [dictForMetadata setValue:DOB forKey:@"metadata[birth_date]"];
             if (userModel.gender != NSGenderNone)
                 [dictForMetadata setValue:userModel.gender == NSGenderMale ? @"male" : @"female" forKey:@"metadata[gender]"];

             if ([[dictForMetadata allKeys]count] > 0)
                 [[NsSnUserManager getInstance] updateUserMetadatas:[dictForMetadata ToUnMutable] cb_rep:^(BOOL ok, NSDictionary *rep) { }];
             
             if ([NsSnSignManager shouldIImportNetwork:eNsSnThirdPartyConnectionFB forEmail:userModel.email])
             {
                 [NsSnSignManager storeThirdPartyConnect:eNsSnThirdPartyConnectionFB forEmail:userModel.email];
                 [NsSnImportNetworkManager importNetworkFromFacebook:[FBSession activeSession].accessTokenData.accessToken cb_rep:nil];
             }
             if (uploadAvatar_)
                 [self uploadAvatarFromFB];
             else
             {
                 [self setFlashMessage:NSLocalizedString(@"gc_success_login", @"")];
                 [self stopLoaderInView:self.bt_fb_login andShowView:YES];
                 [[GCProcessAuthentificationManager sharedManager] endAuthentificationFrom:self];
             }
         }
         else
             [self manageLogin:userModel];
     }];
}

-(void)tryToSubscribe:(NsSnSignModel *)signModel
{
    NSLog(@"FB SUBSCRIBE => %@", signModel.nickname);
    [self.lb_connexionStatus setText:NSLocalizedString(@"gc_auth_proceeding", nil)];
    [[NsSnSignManager getInstance] subscribeAPI:signModel cb_rep:^(BOOL inscription_ok, NSDictionary *rep, NsSnUserErrorValue error)
     {
         if (inscription_ok)
         {
             [self tryToLogin:signModel uploadAvatar:TRUE];
         }
         else
         {
             [self.lb_connexionStatus setText:NSLocalizedString(@"gc_login_fail", nil)];
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_error_subscribe_fb", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
             [self stopLoaderInView:self.bt_fb_login andShowView:YES];
         }
     }];
}

-(void)manageLogin:(NsSnSignModel *)userModel
{
    __block NSString *login_ = userModel.nickname;
    
//    NSLog(@"FB TEST LOGIN => %@", login_);
    [[NsSnSignManager getInstance] checkNicknameAvailability:login_ cb_response:^(BOOL ok)
    {
         if (ok)
         {
//             NSLog(@"FB TEST EMAIL => %@", userModel.email);
             [[NsSnSignManager getInstance] checkEmailAvailability:userModel.email cb_response:^(BOOL ok)
             {
                 if (ok)
                     [self tryToSubscribe:userModel];
                 else
                 {
                     [self.lb_connexionStatus setText:NSLocalizedString(@"gc_login_fail", nil)];
                     [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", nil) message:NSLocalizedString(@"gc_facebook_email_already_used", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", nil) otherButtonTitles:nil]show];
                     [self stopLoaderInView:self.bt_fb_login andShowView:YES];
                 }
             }];
         }
         else
         {
             login_ = [login_ strReplace:SWF(@"%d", charAtTheEndOfNickname-1) to:@""];
             userModel.nickname = [login_ stringByAppendingString:[NSString stringWithFormat:@"%d", charAtTheEndOfNickname]];
             charAtTheEndOfNickname++;
             
             if (charAtTheEndOfNickname <= 5)
                 [self manageLogin:userModel];
             else
             {
                 [self.lb_connexionStatus setText:NSLocalizedString(@"gc_login_fail", nil)];
                 [FBSession.activeSession closeAndClearTokenInformation];
                 [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_error_subscribe_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
                 [self stopLoaderInView:self.bt_fb_login andShowView:YES];
             }
         }
     }];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    __weak typeof(self) weakSelf = self;
    
    NSArray *fields = @[@"email", @"birthday", @"gender", @"first_name", @"last_name"];
    [[FBRequest requestWithGraphPath:@"me" parameters:@{@"fields": [fields componentsJoinedByString:@","]} HTTPMethod:@"GET"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [fields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *value = result[obj];
                if ([obj isEqualToString:@"first_name"]) {
                    user.first_name = value;
                } else if ([obj isEqualToString:@"last_name"]) {
                    user.last_name = value;
                } else {
                    if (value) {
                        user[obj] = value;
                    }
                }
            }];
            
            [weakSelf handleUserInfo:user];
        }
    }];
}

- (void)handleUserInfo:(id<FBGraphUser>)user {
    NSLog(@"GCLoginNSAPIViewController : loginViewFetchedUserInfo => %@", [user description]);
    
    if (hasAlreadyFetchedUserInformation)
    {
        [self stopLoaderInView:self.bt_fb_login andShowView:YES];
        return ;
    }
    hasAlreadyFetchedUserInformation = YES;
    
    [self startLoaderInView:self.bt_fb_login andHideView:YES];
    fb_avatar_url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d", [user objectID], 300, 300];
    
    NSString *mail_user = nil;
    NSString *id_user = nil;
    
    if (user.objectID)
        id_user = [user.objectID sha1];
    
    if ([user objectForKey:@"email"])
        mail_user = [NsSnSignManager formatFacebookEmailFrom:[user objectForKey:@"email"]];
    
    if (!id_user)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_error_connection_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
        [self stopLoaderInView:self.bt_fb_login andShowView:YES];
        return;
    }
    if (![user objectForKey:@"email"] || !mail_user)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_bad_email_conf_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
        [self stopLoaderInView:self.bt_fb_login andShowView:YES];
        return;
    }
    
    NSData *data = [SWF(@"%@.%@", [user.first_name trim], [user.last_name trim]) dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *createdLogin = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    createdLogin = [createdLogin lowercaseString];
    createdLogin = [createdLogin strReplace:@"-" to:@"."];
    createdLogin = [createdLogin strReplace:@"-" to:@"."];
    
    NsSnSignModel *s = [NsSnSignModel new];
    s.dateOfBirth = [(NSDictionary *)user getXpathEmptyString:@"birthday"];
    s.nickname = createdLogin;
    s.email = [mail_user trim];
    s.nom = [[user last_name] trim];
    s.prenom = [[user first_name] trim];
    s.password = [NSString stringWithFormat:@"%lu", (unsigned long)[mail_user hash]];//[id_user trim];
    s.gender = [[(NSDictionary *)user getXpathEmptyString:@"gender"] isEqualToString:@"male"] ? NSGenderMale : NSGenderFemale;
    s.country = [[NSLocale currentLocale] ISO639_2LanguageIdentifier];
    
    [self tryToLogin:s
        uploadAvatar:TRUE];
}


- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"GCLoginNSAPIViewController : loginViewShowingLoggedOutUser");
    hasAlreadyFetchedUserInformation = NO;
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gc_error_connection_fb", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles:nil] show];
    
    NSLog(@"GCLoginNSAPIViewController : handleAuthError => %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
