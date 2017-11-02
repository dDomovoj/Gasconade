//
//  GCSubscribeNSAPIViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCMasterViewController.h"
#import "GCView.h"
#import "NsSnSignModel.h"

#define TAG_VIEW_MANDATORY 4242

@interface GCSubscribeNSAPIViewController : GCMasterViewController

@property (weak, nonatomic) IBOutlet UIScrollView       *sc_scroll;

@property (weak, nonatomic) IBOutlet UIView             *v_background;
@property (weak, nonatomic) IBOutlet UIView             *v_subscribeContent;
@property (weak, nonatomic) IBOutlet UIView             *v_webviewContent;
@property (weak, nonatomic) IBOutlet UIWebView          *wv_cgu;

@property (weak, nonatomic) IBOutlet UILabel            *lb_title;
@property (weak, nonatomic) IBOutlet UILabel            *lb_gender;
@property (weak, nonatomic) IBOutlet UILabel            *lb_male;
@property (weak, nonatomic) IBOutlet UILabel            *lb_female;
@property (weak, nonatomic) IBOutlet UILabel            *lb_titleCGU;
@property (weak, nonatomic) IBOutlet UILabel            *lb_mandatoryFields;

@property (weak, nonatomic) IBOutlet UITextField        *tf_firstname;
@property (weak, nonatomic) IBOutlet UITextField        *tf_name;
@property (weak, nonatomic) IBOutlet UITextField        *tf_dateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField        *tf_nickname;
@property (weak, nonatomic) IBOutlet UITextField        *tf_email;
@property (weak, nonatomic) IBOutlet UITextField        *tf_password;
@property (weak, nonatomic) IBOutlet UITextField        *tf_confirm_password;

@property (weak, nonatomic) IBOutlet UIButton           *bt_male;
@property (weak, nonatomic) IBOutlet UIButton           *bt_female;
@property (weak, nonatomic) IBOutlet UIButton           *bt_acceptCgu;
@property (weak, nonatomic) IBOutlet UIButton           *bt_cgu;
@property (weak, nonatomic) IBOutlet UIButton           *bt_save;
@property (weak, nonatomic) IBOutlet UIButton           *bt_closeCgu;

@property (weak, nonatomic) IBOutlet GCView *v_checkingDateOfBirth;
@property (weak, nonatomic) IBOutlet GCView *v_checkingEmail;
@property (weak, nonatomic) IBOutlet GCView *v_checkingLogin;
@property (weak, nonatomic) IBOutlet GCView *v_checkingPassword;
@property (weak, nonatomic) IBOutlet GCView *v_checkingConfirmPassword;

@property (weak, nonatomic) IBOutlet UIImageView *iv_checkingDateOfBirth;
@property (weak, nonatomic) IBOutlet UIImageView *iv_checkingEmail;
@property (weak, nonatomic) IBOutlet UIImageView *iv_checkingLogin;
@property (weak, nonatomic) IBOutlet UIImageView *iv_checkingPassword;
@property (weak, nonatomic) IBOutlet UIImageView *iv_checkingConfirmPassword;

@property (weak, nonatomic) IBOutlet UIImageView *iv_bgGender;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bgFirstName;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bgLastName;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bgDateOfBirth;

/**
 *  Make an information mandatory (from the ones which are not required by NS-API)
 *  in the form for subscription.
 *
 *  @param mandatoryInfoType enum of different kind of info
 */
-(void) setMandatoryInfoType:(NSProfileInfoType)mandatoryInfoType;

/**
 *  Make an information non mandatory (from the ones which are not required by NS-API)
 *  in the form for subcription
 *
 *  @param mandatoryInfoType enum of different kind of info
 */
-(void) setNonMandatoryInfoType:(NSProfileInfoType)mandatoryInfoType;

@end
