//
//  GCProfileEditionViewController+GCUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 18/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProfileEditionViewController+GCUI.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCProfileEditionViewController (GCUI)

-(void) initProfileEditionView
{
    [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
    [self.bt_imageAvatarModification.layer setCornerRadius:self.bt_imageAvatarModification.frame.size.width/2];
    self.bt_imageAvatarModification.clipsToBounds = YES;
    [self.bt_imageAvatarModification.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"profile_edition_bg")];
    [self.v_backgroundFooter setBackgroundColor:CONFCOLORFORKEY(@"log_out_bg")];
    [self.v_borderAvatar setBackgroundColor:CONFCOLORFORKEY(@"avatar_border_bg")];
    [self.bt_imageAvatarModification setBackgroundColor:CONFCOLORFORKEY(@"avatar_bg")];
    
    [self.lb_title setText:[NSLocalizedString(@"gc_edit_profile", nil) uppercaseString]];
    [self.lb_title setFont:CONFFONTMEDIUMSIZE(13)];
    [self.lb_title setTextColor:CONFCOLORFORKEY(@"title_form_lb")];
    
    [self setUpButtons];
    [self setUpTextFields];
}

-(void) setUpButtons
{
    [self.bt_textAvatarModification setTitle:NSLocalizedString(@"gc_modify_avatar", nil) forState:UIControlStateNormal];
    [self.bt_textAvatarModification setTitleColor:CONFCOLORFORKEY(@"profile_edition_modify_avatar_bt") forState:UIControlStateNormal];
    
    [self.bt_save setTitle:NSLocalizedString(@"gc_save_bt", nil) forState:UIControlStateNormal];
    [self.bt_save.titleLabel setFont:CONFFONTBOLDSIZE(17)];
    [self.bt_save setTitleColor:CONFCOLORFORKEY(@"validate_bt") forState:UIControlStateNormal];
}

-(void) setUpTextFields
{
    self.tf_nickname.delegate = self;
    self.tf_nickname.font = CONFFONTREGULARSIZE(15);
    self.tf_nickname.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    [self.tf_nickname setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_nickname", nil) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
    
    self.tf_password.font = CONFFONTREGULARSIZE(15);
    self.tf_password.secureTextEntry = YES;
    self.tf_password.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_password.delegate = self;
    [self.tf_password setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_password", nil) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
    
    self.tf_confirm_password.font = CONFFONTREGULARSIZE(15);
    self.tf_confirm_password.secureTextEntry = YES;
    self.tf_confirm_password.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_confirm_password.delegate = self;
    [self.tf_confirm_password setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_confirm_password", nil) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __block BOOL foundCurrentTextField = NO;
    __block BOOL currentBlockIsValid = NO;
    __block BOOL foundNextTextField = NO;
    [self.v_containerForm visiteurView:^(UIView *elt)
     {
         if ([elt isKindOfClass:[UITextField class]] && elt == textField && foundCurrentTextField == NO)
         {
             foundCurrentTextField = YES;
             if ([textField.text length] > 0)
                 currentBlockIsValid = YES;
         }
         
         if ([elt isKindOfClass:[UITextField class]] && elt != textField && foundCurrentTextField == YES && foundNextTextField == NO && currentBlockIsValid == YES)
         {
             foundNextTextField = YES;
             [((UITextField *)elt) becomeFirstResponder];
         }
         
     } cbAfter:^(UIView *elt)
     {
     }];
    if (foundNextTextField == NO && currentBlockIsValid == YES)
    {
        [textField resignFirstResponder];
        [self launchUpdate];
    }
    return YES;
}

@end
