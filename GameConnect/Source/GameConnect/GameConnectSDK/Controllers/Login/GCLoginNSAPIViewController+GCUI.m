//
//  GCLoginNSAPIViewController+GCUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 06/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCLoginNSAPIViewController+GCUI.h"
#import "Extends+Libs.h"
#warning ADD IMAGES GC
//#import "UIImage+AppImages.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCLoginNSAPIViewController (GCUI)

#pragma mark Init UI
-(void)initLoginView
{
    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"profile_edition_bg")];

    [self setUpLoginTitle];
    [self setUpButtons];
    [self setUpLabels];
    [self setUpTextField];
}

#pragma Responder
-(void)resignConnectResponder
{
    [self.tf_login resignFirstResponder];
    [self.tf_password resignFirstResponder];
}

#pragma mark Social Networks
-(UIView *)setUpFacebookLogin
{
    self.bt_fb_login = [[FBLoginView alloc] initWithReadPermissions:@[@"email", @"user_friends", @"user_birthday"]];
    [self.v_thirdParties addSubview:self.bt_fb_login];
    self.v_thirdParties.hidden = NO;
    self.bt_fb_login.delegate = self;
    return self.bt_fb_login;
}

-(void)expandThirdPartyViewContainerFor:(eNsSnThirdPartyConnection)thirdParty
{
    CGFloat marginBetweenViews = 25;
    CGFloat thirdPartyHeight = 50;// self.bt_subscribe.frame.size.height;
    
    CGFloat newHeightForThirdParties = thirdPartyHeight * self.numberOfThirdPartyAvailable;
    
    if (self.numberOfThirdPartyAvailable > 1)
        newHeightForThirdParties += self.numberOfThirdPartyAvailable-1 * marginBetweenViews;
    
    [self.v_thirdParties setFrame:CGRectMake(self.v_thirdParties.frame.origin.x,
                                             self.v_thirdParties.frame.origin.y,
                                             self.v_thirdParties.frame.size.width,
                                             newHeightForThirdParties)];
    
    CGFloat newHeightForBackground = self.v_background.frame.size.height + self.v_thirdParties.frame.size.height;
    CGFloat newHeightForContainer = self.v_loginContent.frame.size.height + self.v_thirdParties.frame.size.height;
    
    if (self.numberOfThirdPartyAvailable == 1)
    {
        newHeightForBackground += marginBetweenViews;
        newHeightForContainer += marginBetweenViews;
    }
    
    [self.v_background setFrame:CGRectMake(self.v_background.frame.origin.x,
                                           self.v_background.frame.origin.y,
                                           self.v_background.frame.size.width,
                                           newHeightForBackground)];
    
    [self.v_loginContent setFrame:CGRectMake(self.v_loginContent.frame.origin.x,
                                             self.v_loginContent.frame.origin.y,
                                             self.v_loginContent.frame.size.width,
                                             newHeightForContainer)];
    
    UIView *v_thirdParty = nil;
    
    if (thirdParty == eNsSnThirdPartyConnectionFB)
    {
       v_thirdParty = [self setUpFacebookLogin];
        
    }
    
    if (v_thirdParty)
    {
        CGFloat newYForThirdParty = 0;
        
        if (self.numberOfThirdPartyAvailable > 1)
            newYForThirdParty = thirdPartyHeight * self.numberOfThirdPartyAvailable-1 + self.numberOfThirdPartyAvailable-1 * marginBetweenViews;
        
        [v_thirdParty setFrame:CGRectMake(0, newYForThirdParty, self.v_thirdParties.frame.size.width, thirdPartyHeight)];
		[v_thirdParty setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)]; //UIViewAutoresizingFlexibleHeight
    }
}

#pragma mark TITLE
-(void)setUpLoginTitle
{
    self.titleLabel.text = NSLocalizedString(@"gc_log_in", nil).uppercaseString;
    
    
    self.lb_titleLogin.text = NSLocalizedString(@"gc_login_subtitle", nil);
    self.lb_titleLogin.font = CONFFONTULTRALIGHTSIZE(13);
    self.lb_titleLogin.textColor = CONFCOLORFORKEY(@"title_form_lb");
}

#pragma mark LABELS
-(void)setUpLabels
{
    self.lb_or.font = CONFFONTBOLDSIZE(17);
    self.lb_or.textColor = CONFCOLORFORKEY(@"gc_login_subtitle");
    self.lb_or.text = NSLocalizedString(@"gc_or", nil);
    
    self.lb_connexionStatus.font = CONFFONTMEDIUMSIZE(13);
    self.lb_connexionStatus.textColor = CONFCOLORFORKEY(@"gc_connexion_status_lb");
    [self.lb_connexionStatus setAlpha:0];
}

#pragma mark BUTTONS
-(void)setUpButtons
{
    [self.bt_connect setTitle:NSLocalizedString(@"gc_go", nil).uppercaseString forState:UIControlStateNormal];
    [self.bt_connect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bt_connect.titleLabel.font = CONFFONTBOLDSIZE(17);
    
    [self.bt_subscribe setTitle:NSLocalizedString(@"gc_subscribe", nil).uppercaseString forState:UIControlStateNormal];
    [self.bt_subscribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bt_subscribe.titleLabel.font = CONFFONTBOLDSIZE(17);
}


#pragma mark TEXTFIELD
- (void) setUpTextField
{
    UIView *(^leftView)(UIImage*, CGRect frame) = ^UIView*(UIImage *image, CGRect frame) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame));
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, CGRectGetHeight(frame))];
        imageView.center = view.center;
        [view addSubview:imageView];

        return view;
    };
    
    self.tf_login.delegate = self;
    self.tf_login.leftViewMode = UITextFieldViewModeAlways;
//    self.tf_login.leftView = leftView([UIImage gameConnectLoginLeftImage], self.tf_login.frame);
    self.tf_login.font = CONFFONTREGULARSIZE(15);
    self.tf_login.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    [self.tf_login setAttributedPlaceholder:
        [[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_email", nil)
                                        attributes:
                                @{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder"),                                                                                                                                                                                                                                                              NSFontAttributeName:CONFFONTULTRALIGHTSIZE(15)}]];
    
    self.tf_password.delegate = self;
    self.tf_password.leftViewMode = UITextFieldViewModeAlways;
//    self.tf_password.leftView = leftView([UIImage gameConnectPasswordLeftImage], self.tf_password.frame);
    self.tf_password.font = CONFFONTREGULARSIZE(15);
    self.tf_password.textColor = CONFCOLORFORKEY(@"title_form_field_tf");
    [self.tf_password setAttributedPlaceholder:
        [[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_password", nil)
                                        attributes:
                    @{NSForegroundColorAttributeName:CONFCOLORFORKEY(@"title_form_field_placeholder"),
                      NSFontAttributeName:CONFFONTULTRALIGHTSIZE(15)}]];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __block BOOL foundCurrentTextField = NO;
    __block BOOL currentBlockIsValid = NO;
    __block BOOL foundNextTextField = NO;
    
    [self.v_loginContent visiteurView:^(UIView *elt)
     {
         NSLog(@"[VIEW] : %@", elt);
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
     } cbAfter:^(UIView *elt) {
     }];
    
    if (foundNextTextField == NO && currentBlockIsValid == YES)
    {
        [textField resignFirstResponder];
        [self launchConnection];
    }
    return YES;
}

@end
