//
//  GCProfileHeader.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GCRankingHeaderView.h"
#import "GCRankingModel.h"
#import "NsSnAvatarManager.h"
#import "GCGamerManager.h"
#import "GCProcessProfileManager.h"
#import "UIView+UIView_Tool.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCRankingHeaderView() <UIGestureRecognizerDelegate>

@property (nonatomic) GCGamerModel *gamerModel;

@end

@implementation GCRankingHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.lb_points.text =
    self.lb_playerName.text =
    self.lb_rankingPlace.text =
    self.lb_ratePercentage.text =
    self.lb_rankingPosition.text = nil;

	self.iv_avatarProfile.userInteractionEnabled = YES;

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editProfile)];
	tapGestureRecognizer.numberOfTapsRequired = 1;

	[self addGestureRecognizer:tapGestureRecognizer];
}

-(void)layoutSubviews
{
    [self initFontsAndColors];
}

-(void)initFontsAndColors
{
    [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
    [self.iv_avatarProfile.layer setCornerRadius:self.iv_avatarProfile.frame.size.width/2];
    
    // Colors
    [self.v_background setBackgroundColor:GC_BLUE_COLOR];
    [self.v_borderAvatar setBackgroundColor:CONFCOLORFORKEY(@"avatar_border_bg")];
    [self.lb_playerName setTextColor:CONFCOLORFORKEY(@"profile_name_lb")];
    [self.iv_avatarProfile setBackgroundColor:CONFCOLORFORKEY(@"avatar_bg")];

    [self.lb_rankingPosition setTextColor:CONFCOLORFORKEY(@"profile_ranking_position_lb")];
    [self.lb_rankingPlace setTextColor:CONFCOLORFORKEY(@"profile_ranking_position_lb")];
    [self.lb_points setTextColor:CONFCOLORFORKEY(@"ranking_large_header_points_lb")];
    [self.lb_ratePercentage setTextColor:CONFCOLORFORKEY(@"ranking_header_rate_lb")];

    // Fonts
    [self.lb_playerName setFont:CONFFONTREGULARSIZE(16)];
    [self.lb_rankingPosition setFont:CONFFONTMEDIUMSIZE(14)];
    [self.lb_rankingPlace setFont:CONFFONTBOLDSIZE(18)];
    [self.lb_ratePercentage setFont:CONFFONTMEDIUMSIZE(14)];
//    [self startLoaderInView:self.lb_points andHideView:YES];
}

-(void) updateWithRankingModel:(GCRankingModel *)rankingModel
{
    [self updateWithGamerModel:rankingModel.gamer
                          rank:rankingModel.rank
                          score:rankingModel.score];
}

- (void)updateWithGamerModel:(GCGamerModel *)gamerModel
{
    [self updateWithGamerModel:gamerModel
                          rank:gamerModel.global_rank
                          score:gamerModel.global_score];
}
- (IBAction)onEditProfile:(id)sender
{
	[self editProfile];
}

- (void)editProfile
{
	if ([self.delegate respondsToSelector:@selector(didRequestEditProfiel:fromView:)]) {
		[self.delegate didRequestEditProfiel:self.gamerModel fromView:self];
	}
}

- (void)updateWithGamerModel:(GCGamerModel *)gamerModel rank:(NSInteger)rank score:(NSInteger)score
{

    BOOL isEditProfileEnabled = NO;

    if ([self.delegate respondsToSelector:@selector(isProfileEditEnabled)]) {
        isEditProfileEnabled = [self.delegate isProfileEditEnabled];
    }

    self.gamerModel = gamerModel;

    [self stopLoaderInView:self.lb_points andShowView:YES];
    [self setLoaderColor:nil]; // remove custom colors if it has been set

    [self.lb_playerName setText:gamerModel.login];
    [self.lb_points setText:SWF(@"%lu", (unsigned long)score)];

    if (rank == 0) {
        [self.lb_rankingPosition setText:@""];
        [self.lb_rankingPlace setText:@""];
        [self.lb_ratePercentage setText:@""];
    } else {
        [self.lb_rankingPosition setText:SWF(@"%@", NSLocalizedString(@"gc_general_ranking", nil).uppercaseString)];
        [self.lb_rankingPlace setText:SWF(@"%ld", (long)rank)];
        self.lb_ratePercentage.text = [GCConfManager getSuffixPosition:self.lb_rankingPlace.text];
    }

    if (USE_LOCAL_AVATAR && [GCGamerManager getInstance].connectedGamerAvatar && gamerModel && [gamerModel._id isEqualToString:[GCGamerManager getInstance].gamer._id])
    {
        self.iv_avatarProfile.image = [GCGamerManager getInstance].connectedGamerAvatar;
        [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
        [self.iv_avatarProfile.layer setCornerRadius:self.iv_avatarProfile.frame.size.width/2];
    }
    else
    {
        __weak GCRankingHeaderView *weak_self = self;
        [self startLoaderInView:self.iv_avatarProfile andHideView:YES];
        BOOL success =  [NsSnAvatarManager setImageViewJA:self.iv_avatarProfile withRatio:NsSnMediaProfile_mss_140x140 fromAvatars:gamerModel.Avatar_formats andEndBlock:^(UIImageViewJA *image)
                         {
                             [weak_self.iv_avatarProfile setAlpha:1];
                             [weak_self stopLoaderInView:weak_self.iv_avatarProfile andShowView:YES];
                         }];
        if (success == NO)
        {
            [self.iv_avatarProfile setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Authentification/profile_default_avatar.png"]];
            [self stopLoaderInView:self.iv_avatarProfile andShowView:YES];
        }
    }
}
@end
