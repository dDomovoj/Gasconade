//
//  GCTrophyRender.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 10/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCTrophyRender.h"
#import "Extends+Libs.h"
#import "GCTrophyModel.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCTrophyRender

/*
 ** Colors
 */
-(void)setColors
{
    [self.v_backgroundTrophyImage setBackgroundColor:CONFCOLORFORKEY(@"trophy_picto_bg")];
    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"trophy_cell_bg")];

    [self.lb_name setTextColor:CONFCOLORFORKEY(@"trophy_name_lb")];
    [self.lb_description setTextColor:CONFCOLORFORKEY(@"trophy_desc_lb")];
}

/*
 ** Fonts
 */
-(void)setFonts
{
    [self.lb_name setFont:CONFFONTREGULARSIZE(15)];
    [self.lb_description setFont:CONFFONTSIZE(15)];
}

/*
 ** SetCell - Render
 */
-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    if (elt && [elt isKindOfClass:[GCTrophyModel class]])
    {
        GCTrophyModel *trophyModel = elt;
        
        [self.lb_name setText:trophyModel.name];
        [self.lb_description setTexteRecadre:trophyModel.desc width:self.lb_description.frame.size.width];
        
        if (trophyModel.picture_url && [trophyModel.picture_url length] > 0)
        {
            [self.v_backgroundTrophyImage startLoaderInView:self.iv_trophy];
            [self.iv_trophy loadImageFromURL:trophyModel.picture_url ttl:[[[GCConfManager getInstance] getValue:GCConfigValueImageTTL] intValue] endblock:^(UIImageViewJA *image)
             {
                 [self.v_backgroundTrophyImage stopLoader];
             }];
        }
        else
        {
            [self.iv_trophy setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/General/badge_default"]];
        }
    }
    [self setColors];
    [self setFonts];
}

/*
 ** IIRenderGG Protocol
 */
+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:[GCTrophyRender getIdentifierCell] owner:nil options:nil] getObjectsType:[GCTrophyRender class]];
    
    [((GCTrophyRender*)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCTrophyRender";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    if (elt && [elt isKindOfClass:[GCTrophyModel class]])
    {
        GCTrophyModel *trophyModel = elt;
        
        UILabel *lb_description = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 273, 52)];
        [lb_description setTexteRecadre:trophyModel.desc width:273];
        if (lb_description.frame.size.height == 0)
            [lb_description setFrame:CGRectMake(lb_description.frame.origin.x, lb_description.frame.origin.y, lb_description.frame.size.width, 21)];
        
        CGFloat theHeight = lb_description.frame.origin.y + lb_description.frame.size.height + 12;
        if (theHeight < 108.0){
            theHeight = 108.0;
        }
        return CGSizeMake(collectionView.frame.size.width, theHeight);
    }
    return CGSizeMake(0, 0);
}

@end
