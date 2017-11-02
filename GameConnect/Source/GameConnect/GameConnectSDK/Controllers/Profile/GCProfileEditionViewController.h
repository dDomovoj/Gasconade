//
//  GCProfileEditionViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "GCGamerModel.h"

@interface GCProfileEditionViewController : GCConnectViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet UIView *v_backgroundFooter;
@property (weak, nonatomic) IBOutlet UIView *v_containerForm;
@property (weak, nonatomic) IBOutlet UIView *v_borderAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIScrollView *sv_editionContent;
@property (weak, nonatomic) IBOutlet UIButton *bt_imageAvatarModification;
@property (weak, nonatomic) IBOutlet UIButton *bt_textAvatarModification;
@property (weak, nonatomic) IBOutlet UIButton *bt_save;
@property (weak, nonatomic) IBOutlet UIButton *bt_logout;

@property (weak, nonatomic) IBOutlet UITextField *tf_nickname;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UITextField *tf_confirm_password;

@property (strong, nonatomic) GCGamerModel *gamerModel;

@property (assign, readonly) BOOL isUploadingAvatar;

-(void) setSelectedImageByUserAndUploadIt:(UIImage *)imageAvatar;

-(void) launchUpdate;

@end
