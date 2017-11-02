//
//  GCSubscribeNSAPIViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCSubscribeNSAPIViewController.h"
#import "GCSubscribeNSAPIViewController+GCUI.h"
#import "NsSnSignModel.h"
#import "NsSnSignManager.h"
#import "GCProcessAuthentificationManager.h"
#import "NSLocale+ISO639_2.h"
#import "GCGamerManager.h"
#import "NsSnUserManager.h"
#import "Extends+Libs.h"

@interface GCSubscribeNSAPIViewController ()
{
    UIImage *imagePictoValidTextField;
    UIImage *imagePictoErrorTextField;
    
    NSMutableArray *arrayOfMandatoryProfileInfo;
}
- (IBAction)accept_cgu_click:(id)sender;
- (IBAction)cgu_click:(id)sender;
- (IBAction)save_click:(id)sender;
- (IBAction)male_click:(id)sender;
- (IBAction)female_click:(id)sender;
- (IBAction)close_cgu_click:(id)sender;
@end

@implementation GCSubscribeNSAPIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imagePictoValidTextField = [UIImage imageNamed:@"GCBundleRessources.bundle/Authentification/picto_textfield_validated.png"];
    imagePictoErrorTextField = [UIImage imageNamed:@"GCBundleRessources.bundle/Authentification/picto_textfield_error.png"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initSubscribeView];
    [self male_click:self];
}

#pragma UIButton - User Intereactions

- (IBAction)male_click:(id)sender
{
    self.bt_male.selected = YES;
    self.bt_female.selected = NO;
}

- (IBAction)female_click:(id)sender
{
    self.bt_male.selected = NO;
    self.bt_female.selected = YES;
}

- (IBAction)accept_cgu_click:(id)sender
{
    self.bt_acceptCgu.selected = !self.bt_acceptCgu.selected;
}

- (IBAction)cgu_click:(id)sender
{
    [self showCGU];
}

- (IBAction)close_cgu_click:(id)sender
{
    [self closeCGU];
}

- (IBAction)save_click:(id)sender
{
    NsSnSignModel *signingModel = [NsSnSignModel new];
    [signingModel setMoreMandatoryData:arrayOfMandatoryProfileInfo];
    
    signingModel.nickname = [self.tf_nickname.text trim];
    signingModel.password = [self.tf_password.text trim];
    signingModel.confirm_password = [self.tf_confirm_password.text trim];
    signingModel.email = [[self.tf_email.text trim] lowercaseString];
    signingModel.nom = [self.tf_name.text trim];
    signingModel.prenom = [self.tf_firstname.text trim];
    signingModel.gender = self.bt_male.isSelected ? NSGenderMale : self.bt_female.isSelected ? NSGenderFemale : NSGenderNone;
    signingModel.country = [[NSLocale currentLocale] ISO639_2LanguageIdentifier];
    signingModel.dateOfBirth = [self.tf_dateOfBirth.text trim];
    
    switch ([signingModel validateSigningModel])
    {
        case eNsSnSignErrorBadEmailFormat:
            [self.iv_checkingEmail setImage:imagePictoErrorTextField];
            [self.v_checkingEmail setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_email_bad_format", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_email becomeFirstResponder];
            return ;

        case eNsSnSignErrorBadLoginFormat:
            [self.iv_checkingLogin setImage:imagePictoErrorTextField];
            [self.v_checkingLogin setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_bad_login_format", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_nickname becomeFirstResponder];
            return;
            
        case eNsSnSignErrorLoginLength:
            [self.iv_checkingLogin setImage:imagePictoErrorTextField];
            [self.v_checkingLogin setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_login_length_restriction", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_nickname becomeFirstResponder];
            return ;
            
        case eNsSnSignErrorBadPasswordFormat:
            [self.iv_checkingPassword setImage:imagePictoErrorTextField];
            [self.v_checkingPassword setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_bad_password_format", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_password becomeFirstResponder];
            return;

        case eNsSnSignErrorPasswordLength:
            [self.iv_checkingPassword setImage:imagePictoErrorTextField];
            [self.v_checkingPassword setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_password_length_restriction", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_password becomeFirstResponder];
            return ;
            
        case eNsSnSignErrorPasswordsDifferent:
            [self.iv_checkingConfirmPassword setImage:imagePictoErrorTextField];
            [self.v_checkingConfirmPassword setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_not_same_passwords", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_confirm_password becomeFirstResponder];
            return;
            
        case eNsSnSignErrorNoGender:
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_gender_has_to_be_specified", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            return;
            
        case eNsSnSignErrorNoFirstName:
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_firstname_has_to_be_specified", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_firstname becomeFirstResponder];
            return;

        case eNsSnSignErrorNoLastName:
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_lastname_has_to_be_specified", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_name becomeFirstResponder];
            return;
            
        case eNsSnSignErrorNoDOB:
            [self.iv_checkingDateOfBirth setImage:imagePictoErrorTextField];
            [self.v_checkingDateOfBirth setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_dob_has_to_be_specified", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_dateOfBirth becomeFirstResponder];
            return;
            
        case eNsSnSignErrorBadDOBFormat:
            [self.iv_checkingDateOfBirth setImage:imagePictoErrorTextField];
            [self.v_checkingDateOfBirth setAlpha:1];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_dob_bad_format", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
            [self.tf_dateOfBirth becomeFirstResponder];
            return;

        default:
            [self.v_checkingDateOfBirth setAlpha:0];
            [self.v_checkingEmail setAlpha:0];
            [self.v_checkingLogin setAlpha:0];
            [self.v_checkingPassword setAlpha:0];
            [self.v_checkingConfirmPassword setAlpha:0];
            break;
    }

    if (self.bt_acceptCgu.isSelected == NO)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_must_accept_cgu_warning", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
        return ;
    }

    [self startLoaderInView:self.bt_save andHideView:YES];
    [[GCGamerManager getInstance] subscribeAPI:signingModel cb_rep:^(BOOL inscription_ok, NSDictionary *rep, NsSnUserErrorValue error)
     {
         if (inscription_ok)
         {
             NSString *email_user = [self.tf_email.text trim];
             NSString *password_user = [self.tf_password.text trim];
             
             [[GCGamerManager getInstance] loginByMail:email_user passe:password_user  cb_rep:^(BOOL ok, NsSnUserErrorValue error)
              {
                  if (ok)
                  {
                      NSMutableDictionary *dictForMetadata = [NSMutableDictionary new];
                      NSString *DOB = [signingModel dateOfBirthToString];
                      if (DOB && [DOB length] > 0)
                          [dictForMetadata setValue:DOB forKey:@"metadata[birth_date]"];
                      if (signingModel.gender != NSGenderNone)
                          [dictForMetadata setValue:signingModel.gender == NSGenderMale ? @"male" : @"female" forKey:@"metadata[gender]"];
                      
                      if ([[dictForMetadata allKeys]count] == 0)
                      {
                          [self setFlashMessage:NSLocalizedString(@"gc_success_account_creation", @"")];
                          [[GCProcessAuthentificationManager sharedManager] endAuthentificationFrom:self];
                          [self stopLoaderInView:self.bt_save andShowView:YES];
                      }
                      else
                      {
                          [[NsSnUserManager getInstance] updateUserMetadatas:[dictForMetadata ToUnMutable] cb_rep:^(BOOL ok, NSDictionary *rep)
                           {
                               [self setFlashMessage:NSLocalizedString(@"gc_success_account_creation", @"")];
                               [[GCProcessAuthentificationManager sharedManager] endAuthentificationFrom:self];
                               [self stopLoaderInView:self.bt_save andShowView:YES];
                           }];
                      }
                  }
                  else
                      [self stopLoaderInView:self.bt_save andShowView:YES];
              }];
         }
         else
         {
             if (error == NsSnUserErrorValueLoginAlreadyExist)
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_login_already_used_subscribe", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
             else
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", @"") message:NSLocalizedString(@"gc_failure_subscribe", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", @"") otherButtonTitles: nil] show];
             [self stopLoaderInView:self.bt_save andShowView:YES];
         }
     }];
}

-(void) setMandatoryInfoType:(NSProfileInfoType)mandatoryInfoType
{
    if (!arrayOfMandatoryProfileInfo)
        arrayOfMandatoryProfileInfo = [[NSMutableArray alloc]init];
    [arrayOfMandatoryProfileInfo addObject:[NSNumber numberWithInt:mandatoryInfoType]];
    
    switch (mandatoryInfoType)
    {
        case NSProfileInfoGender:
        {
            self.bt_male.tag = TAG_VIEW_MANDATORY;
            self.bt_female.tag = TAG_VIEW_MANDATORY;
            [self male_click:self];
        } break;
            
        case NSProfileInfoFirstName:
        {
            self.tf_firstname.tag = TAG_VIEW_MANDATORY;
        } break;
            
        case NSProfileInfoLastName:
        {
            self.tf_name.tag = TAG_VIEW_MANDATORY;
        } break;
            
        case NSProfileInfoDoB:
        {
            self.tf_dateOfBirth.tag = TAG_VIEW_MANDATORY;
        } break ;
            
        default:
            break;
    }
}

-(void) setNonMandatoryInfoType:(NSProfileInfoType)mandatoryInfoType
{
    if (arrayOfMandatoryProfileInfo)
    {
        __block NSIndexSet *indexSetToRemove = nil;
        [arrayOfMandatoryProfileInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if (obj && [obj isKindOfClass:[NSNumber class]] && [obj intValue] == mandatoryInfoType)
             {
                 indexSetToRemove = [NSIndexSet indexSetWithIndex:idx];
             }
         }];
        [arrayOfMandatoryProfileInfo removeObjectsAtIndexes:indexSetToRemove];
    }

    switch (mandatoryInfoType)
    {
        case NSProfileInfoGender:
        {
            self.bt_male.tag = 0;
            self.bt_female.tag = 0;
            [self male_click:self]; // Not working (view is not fully created)
        } break;
            
        case NSProfileInfoFirstName:
        {
            self.tf_firstname.tag = 0;
        } break;
            
        case NSProfileInfoLastName:
        {
            self.tf_name.tag = 0;
        } break;
            
        case NSProfileInfoDoB:
        {
            self.tf_dateOfBirth.tag = 0;
        } break ;
            
        default:
            break;
    }
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __block BOOL foundCurrentTextField = NO;
    __block BOOL currentBlockIsValid = NO;
    __block BOOL foundNextTextField = NO;
    [self.v_subscribeContent visiteurView:^(UIView *elt)
     {
         if ([elt isKindOfClass:[UITextField class]] && elt == textField && foundCurrentTextField == NO)
         {
             foundCurrentTextField = YES;
             if ([textField.text length] > 0)
                 currentBlockIsValid = YES;
         }
         
         if ([elt isKindOfClass:[UITextField class]] && elt != textField && foundCurrentTextField == YES && foundNextTextField == NO)
         {
             foundNextTextField = YES;
             [((UITextField *)elt) becomeFirstResponder];
         }
     } cbAfter:^(UIView *elt) {
     }];
    if (foundNextTextField == NO && currentBlockIsValid == YES)
        [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.tf_dateOfBirth)
        [self.v_checkingDateOfBirth setAlpha:0];

    else if (textField == self.tf_email)
        [self.v_checkingEmail setAlpha:0];

    else if (textField == self.tf_nickname)
        [self.v_checkingLogin setAlpha:0];
    
    else if (textField == self.tf_password)
        [self.v_checkingPassword setAlpha:0];
    
    else if (textField == self.tf_confirm_password)
        [self.v_checkingConfirmPassword setAlpha:0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self runCheckOn:textField];
}

-(void) runCheckOn:(UITextField *)textField
{
    NsSnSignModel *signModel = [NsSnSignModel new];
    
    if (textField == self.tf_dateOfBirth && [[self.tf_dateOfBirth.text trim] length] > 0)
    {
        signModel.dateOfBirth = [self.tf_dateOfBirth.text trim];
        
        [self.v_checkingDateOfBirth setAlpha:1];
        if ([signModel validateDateOfBirth] == eNsSnSignErrorNone)
            [self.iv_checkingDateOfBirth setImage:imagePictoValidTextField];
        else
            [self.iv_checkingDateOfBirth setImage:imagePictoErrorTextField];
    }
    else if (textField == self.tf_email && [[self.tf_email.text trim] length] > 0)
    {
        signModel.email = [[self.tf_email.text trim] lowercaseString];
        if ([signModel validateEmail] == eNsSnSignErrorNone)
        {
            [self.iv_checkingEmail setAlpha:0];
            [self.v_checkingEmail setAlpha:1];
            [self.v_checkingEmail startLoader];
            [[NsSnSignManager getInstance] checkEmailAvailability:signModel.email cb_response:^(BOOL ok)
            {
                [self.v_checkingEmail stopLoader];
                if (ok)
                    [self.iv_checkingEmail setImage:imagePictoValidTextField];
                else
                    [self.iv_checkingEmail setImage:imagePictoErrorTextField];
                [self.iv_checkingEmail setAlpha:1];
            }];
        }
        else
        {
            [self.v_checkingEmail setAlpha:1];
            [self.iv_checkingEmail setImage:imagePictoErrorTextField];
        }
    }
    else if (textField == self.tf_nickname && [[self.tf_nickname.text trim] length] > 0)
    {
        signModel.nickname = [self.tf_nickname.text trim];
        if ([signModel validateNickname] == eNsSnSignErrorNone)
        {
            [self.iv_checkingLogin setAlpha:0];
            [self.v_checkingLogin setAlpha:1];
            [self.v_checkingLogin startLoader];
            [[NsSnSignManager getInstance] checkNicknameAvailability:signModel.nickname cb_response:^(BOOL ok)
            {
                [self.v_checkingLogin stopLoader];
                if (ok)
                    [self.iv_checkingLogin setImage:imagePictoValidTextField];
                else
                    [self.iv_checkingLogin setImage:imagePictoErrorTextField];
                [self.iv_checkingLogin setAlpha:1];
            }];
        }
        else
        {
            [self.v_checkingLogin setAlpha:1];
            [self.iv_checkingLogin setImage:imagePictoErrorTextField];
        }
    }
    else if (textField == self.tf_password && [[self.tf_password.text trim] length] > 0)
    {
        signModel.password = [[self.tf_password.text trim] lowercaseString];
        
        [self.v_checkingPassword setAlpha:1];
        if ([signModel validatePassword] == eNsSnSignErrorNone)
            [self.iv_checkingPassword setImage:imagePictoValidTextField];
        else
            [self.iv_checkingPassword setImage:imagePictoErrorTextField];
    }
    else if (textField == self.tf_confirm_password && [[self.tf_confirm_password.text trim] length] > 0)
    {
        signModel.password = [self.tf_password.text trim];
        signModel.confirm_password = [self.tf_confirm_password.text trim];

        [self.v_checkingConfirmPassword setAlpha:1];
        if ([signModel validateConfirmPassword] == eNsSnSignErrorNone)
            [self.iv_checkingConfirmPassword setImage:imagePictoValidTextField];
        else
            [self.iv_checkingConfirmPassword setImage:imagePictoErrorTextField];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
