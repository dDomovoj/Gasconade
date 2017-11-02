//
//  ILinkerGG
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/26/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRenderGG.h"

@protocol ILinkerGG <NSObject>

@required
/*
 ** CollectionView Item
 */
-(NSArray *) getAllICRenderClassesUsed;

-(Class<IRenderGG>) getICRenderForIndexPath:(NSIndexPath *)indexPath andData:(id)data;

-(UICollectionViewCell *) getCellForIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionView *)collectionView andParentViewController:(UIViewController *)parentViewController;

@optional
/*
 ** Header Section Item
 */
-(NSArray *) getAllICHeaderRenderClassesUsed;

-(Class<IRenderGG>) getICHeaderRenderForSection:(NSInteger)section andData:(id)data;

-(UICollectionReusableView *) getHeaderCellForIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionView *)collectionView andParentViewController:(UIViewController *)parentViewController;

/*
 ** Footer Section Item
 */

-(NSArray *) getAllICFooterRenderClassesUsed;

-(Class<IRenderGG>) getICFooterRenderForSection:(NSInteger)section andData:(id)data;

-(UICollectionReusableView *) getFooterCellForIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionView *)collectionView andParentViewController:(UIViewController *)parentViewController;

@end
