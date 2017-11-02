//
//  GCLeagueRender.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 11/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCLeagueRender.h"
#import "GCLeagueModel.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCLeagueRender()
{
    BOOL hasSupplementaryCellTint;
    BOOL isSelected;
    BOOL isLoading;
    
    NSIndexPath *indexPathCell;
}
@end

@implementation GCLeagueRender

-(id)init{
    self = [super init];
    if (self){
        [self myInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self myInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}

-(void)myInit
{
    isSelected = NO;
    isLoading = NO;
}

/*
 ** SetCell - Render
 */
-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    indexPathCell = indexPath;
    
    if (elt && [elt isKindOfClass:[GCLeagueModel class]])
    {
        GCLeagueModel *leagueModel = elt;
        
        [self.lb_name setText:leagueModel.name];
        [self.lb_numberOfMembers setText:SWF(@"%ld %@", (long)leagueModel.count, leagueModel.count == 1 ? NSLocalizedString(@"gc_member", nil ): NSLocalizedString(@"gc_members", nil))];
    }
    [self setColors:indexPath.row % 2 ? NO : YES];
    [self setFonts];
    [self setSelected:isSelected andLoad:isLoading];
}

/*
 ** Fonts
 */
-(void) setFonts
{
    [self.lb_name setFont:CONFFONTSIZE(15)];
    [self.lb_numberOfMembers setFont:CONFFONTITALICSIZE(13)];
}

/*
 ** Colors
 */
-(void)setColors:(BOOL) hasSupplementaryTint
{
    hasSupplementaryCellTint = hasSupplementaryTint;
    
    [self.lb_name setTextColor:CONFCOLORFORKEY(@"league_name_lb")];
    [self.lb_numberOfMembers setTextColor:CONFCOLORFORKEY(@"league_members_lb")];
    
    if (hasSupplementaryCellTint)
        [self setBackgroundColor:CONFCOLORFORKEY(@"league_cell_supplementary_tint_bg")];
    else
        [self setBackgroundColor:CONFCOLORFORKEY(@"league_cell_bg")];
}

-(void) setSelected:(BOOL)selected andLoad:(BOOL)loadInCell
{
    isSelected = selected;
    isLoading = loadInCell;
    if (selected)
    {
        NSLog(@"SELECTED index : %ld", (long)indexPathCell.row);
        if (loadInCell)
        {
            [self.v_loader startLoader];
            [self.iv_arrow setHidden:YES];
        }
        else
        {
            [self.v_loader stopLoader];
            [self.iv_arrow setHidden:NO];
        }
        [self setBackgroundColor:CONFCOLORFORKEY(@"league_cell_selected_bg")];
    }
    else
    {
        NSLog(@"UNSELECTED index : %ld", (long)indexPathCell.row);
        [self.v_loader stopLoader];
        [self.iv_arrow setHidden:NO];
        
        if (hasSupplementaryCellTint)
            [self setBackgroundColor:CONFCOLORFORKEY(@"league_cell_supplementary_tint_bg")];
        else
            [self setBackgroundColor:CONFCOLORFORKEY(@"league_cell_bg")];
    }
}

#pragma IIRenderGG Protocol
+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:[GCLeagueRender getIdentifierCell] owner:nil options:nil] getObjectsType:[GCLeagueRender class]];
    }
    
    [((GCLeagueRender*)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCLeagueRender";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    return CGSizeMake(collectionView.frame.size.width, 44);
}

@end
