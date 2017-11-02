//
//  GCDefaultEventCellRender.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "DefaultCellRenderGG.h"
#import "Extends+Libs.h"

@implementation DefaultCellRenderGG

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    { }
    return self;
}

-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    if (elt && [elt isKindOfClass:[NSString class]])
        [self.lb_title setText:elt];
    else if (elt && [elt isKindOfClass:[NSAttributedString class]])
        [self.lb_title setAttributedText:elt];
    else
        [self.lb_title setText:@"Default Render UICollectionViewGG"];
}

+(UICollectionViewCell *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:[DefaultCellRenderGG getIdentifierCell] owner:nil options:nil] getObjectsType:[DefaultCellRenderGG class]];
	}
    
    [((DefaultCellRenderGG *)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return (DefaultCellRenderGG *) cell;
    
}

+(NSString *) getIdentifierCell
{
    return @"DefaultCellRenderGG";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    return CGSizeMake(collectionView.frame.size.width, 100.0f);
}

@end
