//
//  GCRankingRender.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 10/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import <QuartzCore/QuartzCore.h>
#import "GCRankingRender.h"
#import "GCRankingModel.h"
#import "NsSnAvatarManager.h"
#import "GCGamerManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCRankingRender

/*
 ** Colors
 */
-(void)setColors:(BOOL)hasSupplementaryTint
{
    [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
    [self.iv_playerAvatar.layer setCornerRadius:self.iv_playerAvatar.frame.size.width/2];
    [self.v_points.layer setCornerRadius:4.0];
    [self.v_points setBackgroundColor:CONFCOLORFORKEY(@"points_won_bg")];
    [self.v_borderAvatar setBackgroundColor:CONFCOLORFORKEY(@"avatar_border_bg")];
    
    [self setBackgroundColor:CONFCOLORFORKEY(@"ranking_cell_bg")];
//    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"trophy_cell_bg")]; // White alpha

    [self.lb_points setTextColor:CONFCOLORFORKEY(@"ranking_player_points_lb")];
    [self.lb_playerName setTextColor:CONFCOLORFORKEY(@"ranking_player_name_lb")];
    [self.lb_position setTextColor:CONFCOLORFORKEY(@"ranking_player_position_lb")];
    
    if (hasSupplementaryTint)
    {
        [self setBackgroundColor:CONFCOLORFORKEY(@"ranking_cell_supplementary_tint_bg")];
    }
    else
    {
        [self setBackgroundColor:CONFCOLORFORKEY(@"ranking_cell_bg")];
    }
}

/*
 ** Fonts
 */
-(void)setFonts
{
    [self.lb_position setFont:CONFFONTSIZE(13)];
    [self.lb_playerName setFont:CONFFONTSIZE(15)];
    [self.lb_points setFont:CONFFONTREGULARSIZE(13)];
}

/*
 ** SetCell - Render
 */
-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    if (elt && [elt isKindOfClass:[GCRankingModel class]])
    {
        GCRankingModel *rankingModel = elt;

        [self.lb_position setText:SWF(@"%lu", (unsigned long)rankingModel.rank)];
        [self.lb_points setText:SWF(@"%lu", (unsigned long)rankingModel.score)];
        [self.lb_playerName setText:rankingModel.gamer.login];

        if (USE_LOCAL_AVATAR && [GCGamerManager getInstance].connectedGamerAvatar && rankingModel.gamer && [rankingModel.gamer._id isEqualToString:[GCGamerManager getInstance].gamer._id])
        {
            self.iv_playerAvatar.image = [GCGamerManager getInstance].connectedGamerAvatar;
            [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
            [self.iv_playerAvatar.layer setCornerRadius:self.iv_playerAvatar.frame.size.width/2];
        }
        else
        {
            __weak GCRankingRender *weak_self = self;
            [self.v_borderAvatar startLoader];
            BOOL success = [NsSnAvatarManager setImageViewJA:self.iv_playerAvatar withRatio:NsSnMediaProfile_mss_140x140 fromAvatars:rankingModel.gamer.Avatar_formats andEndBlock:^(UIImageViewJA *image) {
                [weak_self.v_borderAvatar stopLoader];
            }];
            if (success == FALSE)
            {
                [self.iv_playerAvatar setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Authentification/profile_default_avatar.png"]];
                [self.iv_playerAvatar setAlpha:1];
                [self.v_borderAvatar stopLoader];
            }
        }
    }
    [self setColors:indexPath.row % 2 ? NO : YES];
    [self setFonts];
}

/*
 ** IIRenderGG Protocol
 */
+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:[GCRankingRender getIdentifierCell] owner:nil options:nil] getObjectsType:[GCRankingRender class]];
    
    [((GCRankingRender*)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCRankingRender";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    return CGSizeMake(collectionView.frame.size.width, 44);
}



@end
