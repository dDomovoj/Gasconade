//
//  GCProfileHeader.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCView.h"
#import "UIImageViewJA.h"
#import "GCGamerModel.h"
#import "GCRankingModel.h"

@protocol GCProfilHeaderDelegate <NSObject>
@optional
-(void)didClickOnEditProfile:(GCGamerModel *)gamerModel fromView:(GCView *)profileHeader;
@end

@interface GCProfileHeader : GCView

@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet GCView  *v_points;
@property (weak, nonatomic) IBOutlet UIView *v_borderAvatar;
@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_avatarProfile;
@property (weak, nonatomic) IBOutlet UILabel *lb_playerName;
@property (weak, nonatomic) IBOutlet UILabel *lb_playerStatus;
@property (weak, nonatomic) IBOutlet UILabel *lb_rankingType;
@property (weak, nonatomic) IBOutlet UILabel *lb_rankingPosition;
@property (weak, nonatomic) IBOutlet UILabel *lb_rankingPositionSuffix;
@property (weak, nonatomic) IBOutlet UILabel *lb_points;
@property (weak, nonatomic) IBOutlet UIButton *bt_editAvatar;

@property (nonatomic, weak) id<GCProfilHeaderDelegate> delegate;

-(void)updateWithGamerModel:(GCGamerModel *)updatedGamerModel;

-(void)hideProfileModificationButton;

@end
