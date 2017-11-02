//
//  IRenderGG
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/26/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IRenderGG <NSObject>

/*
 ** CollectionView Item
 */
//+(UICollectionViewCell *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController;

+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController;

+(NSString *) getIdentifierCell;

+(CGSize) getSizeCellforData:(id)data indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView;

@optional

///*
// ** Header Section Item
// */
//+(CGFloat) getHeightHeaderforData:(id)elt indexPath:(NSInteger)section collectionView:(UICollectionView *)collectionView;
//
//+(UICollectionReusableView *) getHeaderViewForSection:(NSInteger)section withData:(id)data collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController *)parentViewController;
//
//
///*
// ** Footer Section Item
// */
//+(CGFloat) getHeightFooterforData:(id)elt indexPath:(NSInteger)section collectionView:(UICollectionView *)collectionView;
//
//+(UICollectionReusableView *) getFooterViewForSection:(NSInteger)section withData:(id)data collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController *)parentViewController;



//+(UIView *) getHeaderViewForSection:(NSInteger)section withData:(id)data collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController *)parentViewController; // New one !

// +(NSString *) getHeaderForSection:(NSInteger)section withData:(id)data; // simple string

//+(UIView *) getHeaderViewForSection:(NSInteger)section withData:(id)data; // !! Deprecated
// Footer section
//+(CGFloat) getHeightFooterforData:(id)elt indexPath:(NSInteger)section table:(UITableView*)tb;
//+(UIView *) getFooterViewForSection:(NSInteger)section withData:(id)data tableView:(UITableView *)tableView parentViewController:(UIViewController *)parentViewController;


-(void)removeReference;
-(void)reciverPost:(NSString*)key data:(id)data;


+ (BOOL)instancesRespondToSelector:(SEL)aSelector; // never Overwirte
+ (BOOL)resolveClassMethod:(SEL)sel;///// never Overwirte

@end