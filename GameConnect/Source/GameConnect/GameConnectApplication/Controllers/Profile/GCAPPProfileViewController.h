//
//  GCAPPProfileViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCProfileViewController.h"

@interface GCAPPProfileViewController : GCAPPMasterViewController
{
    GCProfileViewController *profile;
}
@property (weak, nonatomic) IBOutlet UIImageView *iv_brandLogo;
@property (weak, nonatomic) IBOutlet UIView *v_containerProfile;

@property (strong, nonatomic) GCGamerModel *gamerModel;

@end
