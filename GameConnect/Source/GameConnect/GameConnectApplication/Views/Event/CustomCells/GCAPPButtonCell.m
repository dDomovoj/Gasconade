//
//  GCButtonCrell.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPButtonCell.h"
#import "Extends+Libs.h"

/*
 ** Item ButtonCell
 */
@implementation GCAPPButtonCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    { }
    return self;
}

-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    if (elt && [elt isKindOfClass:[NSDictionary class]])
    {
        [self.lb_title setText:[[elt getXpathEmptyString:@"title"] uppercaseString]];
        [self.lb_title setFont:[[GCFontManager getInstance] alternateFontWithSize:16]];
        [self.lb_title setTextColor:GCAPPColorButtonLB];
        [self.lb_title setBackgroundColor:GCAPPColorButtonBG];
    }
}

+(UICollectionViewCell *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:[GCAPPButtonCell getIdentifierCell] owner:nil options:nil] getObjectsType:[GCAPPButtonCell class]];
    
    [((GCAPPButtonCell*)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return (GCAPPButtonCell*) cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCAPPButtonCell";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    return CGSizeMake(collectionView.frame.size.width, 50);
}

@end


