//
//  GCLoginNSAPIViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "GCMasterViewController.h"
#import "UIImageViewJA.h"
#import "NsSnSignManager.h"

#warning UARENA
@interface GCLoginViewController: UIViewController { }
@end

@interface GCLoginNSAPIViewController : GCMasterViewController
    <UITextFieldDelegate, FBLoginViewDelegate/*, ProfileViewControllerDelegate_iPhone*/>

@property (strong, nonatomic) FBLoginView *bt_fb_login;
@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet UIView *v_thirdParties;
@property (weak, nonatomic) IBOutlet UIView *v_loginContent;
@property (weak, nonatomic) IBOutlet UIScrollView *sv_loginElements;

@property (weak, nonatomic) IBOutlet UILabel *lb_titleLogin;
@property (weak, nonatomic) IBOutlet UILabel *lb_or;
@property (weak, nonatomic) IBOutlet UILabel *lb_connexionStatus;

@property (weak, nonatomic) IBOutlet UITextField *tf_login;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;

@property (weak, nonatomic) IBOutlet UIButton *bt_connect;
@property (weak, nonatomic) IBOutlet UIButton *bt_subscribe;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (assign, readonly) NSUInteger numberOfThirdPartyAvailable;

-(void)launchConnection;
-(void)insertSocialNetworkConnect:(eNsSnThirdPartyConnection)thirdParty;

@end
