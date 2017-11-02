//
//  GCInvitationFriendRender.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 18/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewJA.H"
#import "IRenderGG.h"
#import "GCView.h"
#import "GCMasterCollectionViewCell.h"

@interface GCInvitationGroupRender : GCMasterCollectionViewCell <IRenderGG>

@property (weak, nonatomic) IBOutlet GCView *v_borderAvatar;
@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_friendAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lb_friendName;
@property (weak, nonatomic) IBOutlet UIButton *bt_invitation;

@end
