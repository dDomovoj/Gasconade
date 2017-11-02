//
//  GCRankingRender.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 10/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewJA.h"
#import "GCView.h"
#import "GCMasterCollectionViewCell.h"

@interface GCRankingRender : GCMasterCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_position;
@property (weak, nonatomic) IBOutlet UILabel *lb_playerName;
@property (weak, nonatomic) IBOutlet UILabel *lb_points;

@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet GCView *v_borderAvatar;
@property (weak, nonatomic) IBOutlet UIView *v_points;

@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_playerAvatar;

@end
