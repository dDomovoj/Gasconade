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

@class GCRankingHeaderView;

@protocol GCRankingHeaderViewDelegate <NSObject>
@optional
- (void)didRequestEditProfiel:(GCGamerModel *)gamerModel fromView:(GCRankingHeaderView *)headerView;
- (BOOL)isProfileEditEnabled;
@end

@interface GCRankingHeaderView : GCView

@property (weak, nonatomic) id<GCRankingHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *v_background;

@property (weak, nonatomic) IBOutlet UIView *v_borderAvatar;
@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_avatarProfile;

@property (weak, nonatomic) IBOutlet UILabel *lb_playerName;

@property (weak, nonatomic) IBOutlet UILabel *lb_rankingPlace;
@property (weak, nonatomic) IBOutlet UILabel *lb_rankingPosition;
@property (weak, nonatomic) IBOutlet UILabel *lb_points;
@property (weak, nonatomic) IBOutlet UILabel *lb_ratePercentage;

-(void) initFontsAndColors;
-(void) updateWithRankingModel:(GCRankingModel *)rankingModel;
- (void)updateWithGamerModel:(GCGamerModel *)gamerModel;

@end
