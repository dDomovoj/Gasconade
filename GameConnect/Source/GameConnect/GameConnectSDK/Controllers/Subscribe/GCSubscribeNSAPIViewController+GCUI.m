//
//  GCSubscribeNSAPIViewController+GCUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 06/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCSubscribeNSAPIViewController+GCUI.h"
#import "Extends+Libs.h"
#import "GCPlatformConnection.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCSubscribeNSAPIViewController (GCUI)

#pragma mark Init UI
-(void)initSubscribeView
{
    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"profile_edition_bg")];
    
    [self setUpSubscribeTitle];
    [self setUpGender];
    [self setUpTextFields];
    [self setUpCGU];
    [self setUpButtons];
}

#pragma mark TITLE
-(void)setUpSubscribeTitle
{
    self.lb_title.text = [NSLocalizedString(@"gc_create_account", nil) uppercaseString];
    self.lb_title.font = CONFFONTMEDIUMSIZE(15);
    self.lb_title.textColor = CONFCOLORFORKEY(@"title_form_lb");
}

#pragma mark GENDER
-(void)setUpGender
{
    self.lb_gender.text = NSLocalizedString(@"gc_gender", nil);
    self.lb_gender.font = CONFFONTMEDIUMSIZE(13);
    self.lb_gender.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    
    self.lb_male.text = NSLocalizedString(@"gc_male", nil);
    self.lb_male.font = CONFFONTSIZE(13);
    self.lb_male.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    
    self.lb_female.text = NSLocalizedString(@"gc_female", nil);
    self.lb_female.font = CONFFONTSIZE(13);
    self.lb_female.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    
    self.lb_mandatoryFields.text = NSLocalizedString(@"gc_symbol_mandatory_fields", nil);
    self.lb_mandatoryFields.font = CONFFONTSIZE(13);
    self.lb_mandatoryFields.textColor = CONFCOLORFORKEY(@"title_form_field_placeholder");
}

#pragma mark TEXTFIELD
- (void) setUpTextFields
{
    self.tf_firstname.font = CONFFONTREGULARSIZE(15);
    self.tf_firstname.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_firstname.delegate = self;
    if (self.tf_firstname.tag == TAG_VIEW_MANDATORY)
        [self.tf_firstname setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SWF(@"%@ *", NSLocalizedString(@"gc_first_name", nil)) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
    else
        [self.tf_firstname setAttributedPlaceholder:[[NSAttributedString alloc] initWithString: NSLocalizedString(@"gc_first_name", nil) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
    
    self.tf_name.font = CONFFONTREGULARSIZE(15);
    self.tf_name.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_name.delegate = self;
    if (self.tf_name.tag == TAG_VIEW_MANDATORY)
        [self.tf_name setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SWF(@"%@ *", NSLocalizedString(@"gc_last_name", nil)) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
    else
        [self.tf_name setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_last_name", nil) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];

    self.tf_dateOfBirth.font = CONFFONTREGULARSIZE(15);
    self.tf_dateOfBirth.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_dateOfBirth.delegate = self;
    if (self.tf_name.tag == TAG_VIEW_MANDATORY)
        [self.tf_dateOfBirth setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SWF(@"%@ *", NSLocalizedString(@"gc_date_of_birth_jjmmyyyy", nil)) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
    else
        [self.tf_dateOfBirth setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_date_of_birth_jjmmyyyy", nil) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];
    
    self.tf_nickname.font = CONFFONTREGULARSIZE(15);
    self.tf_nickname.secureTextEntry = NO;
    self.tf_nickname.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_nickname.delegate = self;
    self.tf_nickname.enablesReturnKeyAutomatically = YES;
    [self.tf_nickname setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SWF(@"%@ *", NSLocalizedString(@"gc_nickname", nil)) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];

    self.tf_email.font = CONFFONTREGULARSIZE(15);
    self.tf_email.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_email.delegate = self;
    self.tf_email.enablesReturnKeyAutomatically = YES;
    [self.tf_email setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SWF(@"%@ *", NSLocalizedString(@"gc_email", nil)) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];

    self.tf_password.font = CONFFONTREGULARSIZE(15);
    self.tf_password.secureTextEntry = YES;
    self.tf_password.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_password.delegate = self;
    self.tf_password.enablesReturnKeyAutomatically = YES;
    [self.tf_password setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SWF(@"%@ *", NSLocalizedString(@"gc_password", nil)) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];

    self.tf_confirm_password.font = CONFFONTREGULARSIZE(15);
    self.tf_confirm_password.secureTextEntry = YES;
    self.tf_confirm_password.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    self.tf_confirm_password.delegate = self;
    self.tf_email.enablesReturnKeyAutomatically = YES;
    [self.tf_confirm_password setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SWF(@"%@ *", NSLocalizedString(@"gc_confirm_password", nil)) attributes:@{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder")}]];

}

#pragma mark CGU
-(void)setUpCGU
{
    [self.v_webviewContent setAlpha:0];
    [self.bt_closeCgu setAlpha:0];
    [self.bt_closeCgu setBackgroundColor:CONFCOLORFORKEY(@"close_button_bg")];
    self.bt_closeCgu.layer.cornerRadius = 6.0f;
    
    [self.lb_titleCGU setTextColor:CONFCOLORFORKEY(@"title_form_lb")];
    [self.lb_titleCGU setText:[NSLocalizedString(@"gc_terms_of_use", nil) uppercaseString]];
    
    [self.wv_cgu loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[GCPlatformConnection getInstance] getURLForCGU]]]];
}

-(void)showCGU
{
    [self.sc_scroll setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.2 animations:^{

        [self.v_subscribeContent setAlpha:0];
        [self.bt_closeCgu setAlpha:1];
        [self.v_webviewContent setAlpha:1];

    } completion:^(BOOL finished) {
        
    }];
}

-(void)closeCGU
{
    [self.sc_scroll setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.v_subscribeContent setAlpha:1];
        [self.bt_closeCgu setAlpha:0];
        [self.v_webviewContent setAlpha:0];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark BUTTONS
-(void)setUpButtons
{
    self.bt_male.selected = NO;
    self.bt_female.selected = NO;
    
    // CGU
    NSAttributedString *attridubtedStringCGU = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_accept_terms", nil)
                                                                               attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                            NSForegroundColorAttributeName : CONFCOLORFORKEY(@"signup_title_button_cgu"),
                                                                                            NSFontAttributeName : CONFFONTBOLDSIZE(15)}];
    [self.bt_cgu setAttributedTitle:attridubtedStringCGU forState:UIControlStateNormal];
    
    [self.bt_acceptCgu setSelected:NO];

    // Save
    [self.bt_save setTitle:[NSLocalizedString(@"gc_register", nil) uppercaseString] forState:UIControlStateNormal];
    [self.bt_save setTitleColor:CONFCOLORFORKEY(@"validate_bt") forState:UIControlStateNormal];
    self.bt_save.titleLabel.font = CONFFONTBOLDSIZE(17);
}

@end
