;;//
//  GCProfileEditionViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProfileEditionViewController.h"
#import "GCProcessProfileManager.h"
#import "GCProfileEditionViewController+GCUI.h"
#import "GCGamerManager.h"
#import "GCProcessAuthentificationManager.h"
#import "NsSnAvatarManager.h"
#import "NsSnUserManager.h"
#import "GCAppNavigationManageriPhone.h"
#import "Extends+Libs.h"

@interface GCProfileEditionViewController ()
{
    UIImageViewJA *imgViewJAAvatar;
}
- (IBAction)clickModifyAvatar:(id)sender;
- (IBAction)clickSaveModifications:(id)sender;
- (IBAction)clickOnLogOut:(id)sender;
@end

@implementation GCProfileEditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isUploadingAvatar = NO;
    
    [self initProfileEditionView];
    [self preFillDataWithUserModel];

    self.bt_logout.hidden = YES;
}

-(void)preFillDataWithUserModel
{
    if (self.gamerModel)
    {
        self.tf_nickname.text = self.gamerModel.login;

        if ([GCGamerManager getInstance].connectedGamerAvatar && USE_LOCAL_AVATAR)
        {
            [self.bt_imageAvatarModification setImage:[GCGamerManager getInstance].connectedGamerAvatar forState:UIControlStateNormal];
        }
        else
        {
            __weak GCProfileEditionViewController *weak_self = self;
            imgViewJAAvatar = [[UIImageViewJA alloc] initWithImage:self.bt_imageAvatarModification.currentBackgroundImage];
            
            [self startLoaderInView:self.bt_imageAvatarModification andHideView:YES];
            BOOL success = [NsSnAvatarManager setImageViewJA:imgViewJAAvatar withRatio:NsSnMediaProfile_mss_140x140 fromAvatars:self.gamerModel.Avatar_formats andEndBlock:^(UIImageViewJA *image) {
                [weak_self.bt_imageAvatarModification setImage:image.image forState:UIControlStateNormal];
                [weak_self stopLoaderInView:self.bt_imageAvatarModification andShowView:YES];
            }];
            
            if (success == NO)
            {
                [self.bt_imageAvatarModification setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Authentification/profile_default_avatar"] forState:UIControlStateNormal];
                [self stopLoaderInView:self.bt_imageAvatarModification andShowView:YES];
            }
        }
        
        // BLoque ceux pour facebook
        if ([self.gamerModel._id isEqualToString:[NsSnUserManager getInstance].user._id])
        {
            if ([NsSnSignManager isHeConnectedUsingThirdParty:[NsSnUserManager getInstance].user] != eNsSnThirdPartyConnectionNone)
            {
//                [self.tf_nickname setEnabled:NO];
                [self.tf_password setEnabled:NO];
                [self.tf_confirm_password setEnabled:NO];
                
                self.tf_password.text = self.tf_confirm_password.text = @"netcosports"; //[[[NsSnUserManager getInstance].user getMetadataForKey:@"facebook_id"] sha1];
                [self setFlashMessage:NSLocalizedString(@"gc_fb_profile_edition_disabled", nil)];
            }
            else
            {
                [self.tf_nickname setEnabled:YES];
                [self.tf_password setEnabled:YES];
                [self.tf_confirm_password setEnabled:YES];
            }
        }
    }
}

-(void) setSelectedImageByUserAndUploadIt:(UIImage *)imageAvatar
{
    [self startLoaderInView:self.bt_imageAvatarModification];
    _isUploadingAvatar = YES;
    [self.bt_imageAvatarModification setImage:imageAvatar forState:UIControlStateNormal];

    __weak GCProfileEditionViewController *weak_self = self;

    [[GCGamerManager getInstance] uploadAvatar:imageAvatar cb_send:^(long long total, long long current) {
    } cb_rep:^(GCGamerModel *gamer)
    {
        [weak_self stopLoaderInView:weak_self.bt_imageAvatarModification];
        [weak_self setFlashMessage:NSLocalizedString(@"gc_success_upload_avatar", nil)];
        _isUploadingAvatar = NO;
    }];
    
    if (USE_LOCAL_AVATAR)
        [GCGamerManager getInstance].connectedGamerAvatar = imageAvatar;
}

-(BOOL) checkUpLogin
{
    BOOL hasValidatedLogin = NO;
    NSString *typedLogin = [self.tf_nickname.text trim];
    
    if (typedLogin)
    {
        NsSnSignModel *signingModel = [NsSnSignModel new];
        signingModel.nickname = typedLogin;
        
        switch ([signingModel validateNickname])
        {
            case eNsSnSignErrorLoginLength:
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_login_length_restriction", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
                [self.tf_nickname becomeFirstResponder];
                break;
                
            case eNsSnSignErrorBadLoginFormat:
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_bad_login_format", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
                [self.tf_nickname becomeFirstResponder];
                break;
                
            default:
                hasValidatedLogin = YES;
                break;
        }
    }
    return hasValidatedLogin;
}

-(BOOL) checkUpPasswords
{
    BOOL hasValidatedPasswords = NO;
    NSString *typedPassword = [self.tf_password.text trim];
    NSString *typedConfirmPassword = [self.tf_confirm_password.text trim];
    
    if (typedPassword && typedConfirmPassword)
    {
        NsSnSignModel *signingModel = [NsSnSignModel new];
        signingModel.password = typedPassword;
        signingModel.confirm_password = typedConfirmPassword;
        
        switch ([signingModel validatePassword])
        {
            case eNsSnSignErrorPasswordLength:
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_password_length_restriction", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
                [self.tf_password becomeFirstResponder];
                break;
                
            case eNsSnSignErrorBadPasswordFormat:
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_bad_password_format", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
                [self.tf_password becomeFirstResponder];
                break;
                
            default:
            {
                if ([signingModel validateConfirmPassword] == eNsSnSignErrorPasswordsDifferent)
                {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_not_same_passwords", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
                    [self.tf_confirm_password becomeFirstResponder];
                }
                else
                    hasValidatedPasswords = YES;
            } break;
        }
    }
    return hasValidatedPasswords;
}

#pragma User - Iteractions
- (IBAction)clickModifyAvatar:(id)sender
{
    if (_isUploadingAvatar)
        [self setFlashMessage:NSLocalizedString(@"gc_avatar_being_uploaded", nil)];
    else
        [[GCProcessProfileManager sharedManager] requestImagePickerFromViewController:self];
}

- (IBAction)clickSaveModifications:(id)sender
{
    [self launchUpdate];
}

-(void) launchUpdate
{
    [self.view resignAllResponder];
    
    NSString *typedLogin = [self.tf_nickname.text trim];
    BOOL shouldUpdateLogin = [typedLogin length] > 0 ? self.gamerModel && self.gamerModel.login && ![typedLogin isEqualToString:self.gamerModel.login] : NO;
    
    NSString *typedPassword = [self.tf_password.text trim];
    BOOL shouldUpdatePassword = ([typedPassword length] > 0) && self.tf_password.enabled ? YES : NO;
    
    __block BOOL loginUpdated = NO;
    __block BOOL passwordUpdated = NO;
    __weak GCProfileEditionViewController *weak_self = self;
    
    if (shouldUpdateLogin && [self checkUpLogin])
    {
        // Send Update LOGIN
        [[GCGamerManager getInstance] updateUserProfile:@{@"nickname" : typedLogin} cb_rep:^(NSDictionary *rep, NsSnUserErrorValue error)
         {
             if (error == NsSnUserErrorValueNone)
             {
                 loginUpdated = YES;
                 [GCGamerManager getInstance].gamer.date_update = [[NSDate date] timeIntervalSince1970];
                 [GCGamerManager getInstance].gamer.login = typedLogin;
                 if ((shouldUpdatePassword && passwordUpdated) || !shouldUpdatePassword)
                 {
                     [weak_self stopLoaderInView:weak_self.bt_save andShowView:YES];
                     [weak_self setFlashMessage:NSLocalizedString(@"gc_profile_information_updated", nil)];
                     [[GCProcessProfileManager sharedManager] profileEditionSavedFomViewController:weak_self];
                 }
             }
             else
             {
                 if (error == NsSnUserErrorValueLoginAlreadyExist)
                     [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_login_already_used_subscribe", @"") delegate:weak_self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
                 else
                     [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_failure_subscribe", @"") delegate:weak_self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
                 [weak_self stopLoaderInView:weak_self.bt_save andShowView:YES];
             }
         }];
    }
    if (shouldUpdatePassword && [self checkUpPasswords])
    {
        // send update password
        [[GCGamerManager getInstance] updateUserPassword:typedPassword cb_rep:^(BOOL ok, NSDictionary *rep)
         {
             if (ok)
             {
                 passwordUpdated = YES;
                 if ((shouldUpdateLogin && loginUpdated) || !shouldUpdateLogin)
                 {
                     [weak_self stopLoaderInView:weak_self.bt_save andShowView:YES];
                     [weak_self setFlashMessage:NSLocalizedString(@"gc_profile_information_updated", nil)];
                     [[GCProcessProfileManager sharedManager] profileEditionSavedFomViewController:weak_self];
                 }
             }
         }];
    }
}

- (IBAction)clickOnLogOut:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_confirmation_logout", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"gc_cancel", nil) otherButtonTitles:NSLocalizedString(@"gc_popup_ok", nil), nil] show];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex)
    {
        __weak GCProfileEditionViewController *weak_self = self;
        [self startLoaderInView:self.bt_logout andHideView:YES];
        [[GCGamerManager getInstance] logout:^{
            [[[GCAPPNavigationManageriPhone getInstance] giveMeNavigationViewController] popToRootViewControllerAnimated:NO];
            [weak_self runAuthentificationProcess];
            [weak_self stopLoaderInView:weak_self.bt_logout andShowView:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    NSLog(@"DEALLOC PROFILE EDITION");
}

@end
