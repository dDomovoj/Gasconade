//
//  GCProfileHeader.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UILabel+UILabel_Tool.h"
#import "GCProfileHeader.h"
#import "GCGamerModel.h"
#import "NsSnAvatarManager.h"
#import "GCGamerManager.h"
#import "GCProcessAuthentificationManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCProfileHeader()
{
    GCGamerModel *gamerModel;
    BOOL hideProfileModificationButton;
}
- (IBAction)clickEditProfile:(id)sender;
@end

@implementation GCProfileHeader

-(id)init
{
    self = [super init];
    if (self)
    {
        hideProfileModificationButton = NO;
    }
    return self;
}

-(void)myInit
{
    [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
    [self.iv_avatarProfile.layer setCornerRadius:self.iv_avatarProfile.frame.size.width/2];
    [self.v_points.layer setCornerRadius:4.0];
    
    // Colors
    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"header_profile_bg")];
    [self.v_borderAvatar setBackgroundColor:CONFCOLORFORKEY(@"avatar_border_bg")];
    [self.iv_avatarProfile setBackgroundColor:CONFCOLORFORKEY(@"avatar_bg")];
    [self.v_points setBackgroundColor:CONFCOLORFORKEY(@"points_won_bg")];
    [self.lb_playerName setTextColor:CONFCOLORFORKEY(@"profile_name_lb")];
    [self.lb_playerStatus setTextColor:CONFCOLORFORKEY(@"profile_status_lb")];
    [self.lb_points setTextColor:CONFCOLORFORKEY(@"points_lb")];
    [self.lb_rankingType setTextColor:CONFCOLORFORKEY(@"profile_ranking_lb")];
    [self.lb_rankingPosition setTextColor:CONFCOLORFORKEY(@"profile_ranking_position_lb")];
    [self.lb_rankingPositionSuffix setTextColor:CONFCOLORFORKEY(@"profile_ranking_position_lb")];
    [self.bt_editAvatar setTitleColor:CONFCOLORFORKEY(@"profile_edition_bt") forState:UIControlStateNormal];
    
    // Fonts
    [self.lb_playerName setFont:CONFFONTREGULARSIZE(16)];
    [self.lb_playerStatus setFont:CONFFONTSIZE(12)];
    [self.lb_rankingType setFont:CONFFONTSIZE(9)];
    [self.lb_rankingPosition setFont:CONFFONTMEDIUMSIZE(22)];
    [self.lb_rankingPositionSuffix setFont:CONFFONTREGULARSIZE(11)];
    [self.lb_points setFont:CONFFONTREGULARSIZE(25)];
    [self.bt_editAvatar.titleLabel setFont:CONFFONTITALICSIZE(13)];
    
    [self.lb_rankingType setTexteRecadre:[NSLocalizedString(@"gc_general_ranking", nil) uppercaseString] height:self.lb_rankingType.frame.size.height];
    
    [self.lb_rankingType setFrame:CGRectMake(self.frame.size.width - self.lb_rankingType.frame.size.width - 7, self.lb_rankingType.frame.origin.y, self.lb_rankingType.frame.size.width, self.lb_rankingType.frame.size.height)];

    [self.lb_playerName setFrame:CGRectMake(self.lb_playerName.frame.origin.x, self.lb_playerName.frame.origin.y, self.v_points.frame.origin.x - 7 - self.lb_playerName.frame.origin.x, self.lb_playerName.frame.size.height)];
    
//#warning Change to profile edition in production
    [self.bt_editAvatar setTitle:/*NSLocalizedString(@"gc_log_out", nil)*/ NSLocalizedString(@"gc_edit_profile", nil) forState:UIControlStateNormal];
}

-(void)updateWithGamerModel:(GCGamerModel *)updatedGamerModel
{
    gamerModel = updatedGamerModel;
    
    if (![updatedGamerModel._id isEqualToString:[GCGamerManager getInstance].gamer._id] || hideProfileModificationButton)
    {
        [self.bt_editAvatar setAlpha:0];
        [self.lb_playerName setFrame:CGRectMake(self.lb_playerName.frame.origin.x, self.lb_playerName.frame.origin.y, self.lb_playerName.frame.size.width, self.v_borderAvatar.frame.size.height)];
    }
    else
    {
        [self.bt_editAvatar setAlpha:1];
        [self.lb_playerName setFrame:CGRectMake(self.lb_playerName.frame.origin.x, self.lb_playerName.frame.origin.y, self.lb_playerName.frame.size.width, self.bt_editAvatar.frame.origin.y - self.lb_playerName.frame.origin.y)];
    }
    
    [self.lb_playerName setText:gamerModel.login];
//    [self.lb_playerStatus setText:[gamerModel.player_status uppercaseString]];

    [self.lb_points setText:SWF(@"%ld", (long)updatedGamerModel.global_score)];
    [self.lb_rankingPosition setText:SWF(@"%ld", (long)updatedGamerModel.global_rank)];
    
    [self.lb_rankingPositionSuffix setTexteRecadre:[GCConfManager getSuffixPosition:self.lb_rankingPosition.text] height:self.lb_rankingPositionSuffix.frame.size.height];

    [self.lb_rankingPositionSuffix setFrame:CGRectMake(self.frame.size.width - 7 - self.lb_rankingPositionSuffix.frame.size.width, self.lb_rankingPosition.frame.origin.y - 5, self.lb_rankingPositionSuffix.frame.size.width, self.lb_rankingPositionSuffix.frame.size.height)];
    
    
    if (updatedGamerModel.global_rank > 0)
    {
        if (self.lb_rankingPosition.frame.origin.x + self.lb_rankingPosition.frame.size.width > self.lb_rankingPositionSuffix.frame.origin.x)
        {
            [self.lb_rankingPosition setFrame:CGRectMake(self.lb_rankingPosition.frame.origin.x, self.lb_rankingPosition.frame.origin.y, self.lb_rankingPosition.frame.size.width - self.lb_rankingPositionSuffix.frame.size.width - 3, self.lb_rankingPosition.frame.size.height)];
        }
    }

    UIImage *imageLoaded = [GCGamerManager getInstance].connectedGamerAvatar;
    if (USE_LOCAL_AVATAR && imageLoaded && [GCGamerManager getInstance].connectedGamerAvatar && updatedGamerModel && [updatedGamerModel._id isEqualToString:[GCGamerManager getInstance].gamer._id])
    {
        self.iv_avatarProfile.image = [GCGamerManager getInstance].connectedGamerAvatar;
        [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
        [self.iv_avatarProfile.layer setCornerRadius:self.iv_avatarProfile.frame.size.width/2];
    }
    else
    {
        __weak GCProfileHeader *weak_self = self;
        [self startLoaderInView:self.iv_avatarProfile andHideView:YES];
        BOOL success = [NsSnAvatarManager setImageViewJA:self.iv_avatarProfile withRatio:NsSnMediaProfile_mss_140x140 fromAvatars:updatedGamerModel.Avatar_formats andEndBlock:^(UIImageViewJA *image)
        {
            [weak_self stopLoaderInView:weak_self.iv_avatarProfile andShowView:YES];
        }];
        if (success == NO)
        {
            [self.iv_avatarProfile setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Authentification/profile_default_avatar"]];
            [self stopLoaderInView:self.iv_avatarProfile andShowView:YES];
        }
    }
}

-(void)hideProfileModificationButton
{
    [self.bt_editAvatar setAlpha:0];
    hideProfileModificationButton = YES;
}

#pragma mark - User Interactions
- (IBAction)clickEditProfile:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnEditProfile:fromView:)])
        [self.delegate didClickOnEditProfile:gamerModel fromView:self];
}

@end
