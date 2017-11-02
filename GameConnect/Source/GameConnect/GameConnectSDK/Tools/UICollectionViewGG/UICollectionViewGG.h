//
//  UICollectionViewGG.h
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILinkerGG.h"
#import "IRenderGG.h"
#import "IDataGG.h"

#define UICOLLECTIONVIEWGG_DEFAULT_AUTO_REFRESH_DELAY 30

@class UICollectionViewGG;
@protocol UICollectionViewGGDelegate <NSObject>

@optional
-(BOOL) shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView;
-(void) didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView;
-(void) willDisplayCell:(UICollectionViewCell *)cell withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView atIndexPath:(NSIndexPath *)indexPath;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end

@interface UICollectionViewGG : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UIViewController *parentViewController;
@property (weak, nonatomic)   id<UICollectionViewGGDelegate> delegateGG;
@property (strong, nonatomic) id<ILinkerGG> itemLinker;
@property (strong, nonatomic) id<IDataGG> dataRendering;
@property (strong, nonatomic) NSDictionary *data;

@property (assign, nonatomic, setter = setDynamicFlowLayoutEnable:) BOOL isUsingDynamicFlowLayout;
@property (assign, nonatomic, setter = setPullToRefreshEnable:) BOOL isPullToRefreshEnabled;

@property (strong, nonatomic) NSAttributedString *attributedNoDataText;

@property (strong, nonatomic) UIView *viewFirstLoading;

/**
 *  Called cases:
 *  - Pull To Refresh events
 *  - Auto-refreshing system fire
 *  - In loadConfiguration
 */
@property (nonatomic,copy) void(^callRefresh)(void);

@property (nonatomic,copy) void(^callMoreData)(void);
-(void) setMoreData:(NSDictionary *)moreData;

/**
 *  Configuration Of IDataGG for UICollectionViewGG
 */
-(void) setSimpleDataRenderingUsingXpath:(NSString*)xpath;
-(void) setRender:(Class <IRenderGG>)render;
-(void) setRender:(Class <IRenderGG>)render andHeaderRender:(Class <IRenderGG>)headerRender;
-(void) loadConfiguration;

/**
 *  AutoRefresh controls
 */
-(void) startAutoRefresh;
-(void) startAutoRefreshWithSeconds:(CGFloat)seconds;
-(void) endAutoRefresh;

/**
 * Pull to refresh Controls
 */
-(void) setRefreshControlColor:(UIColor *)color;
-(void) beginRefreshing;
-(void) endRefreshing;

/**
 * Collection Flow Layout
 */

-(void)setMinimumRowSpacing:(CGFloat)minimumSpacingInRow;
-(void)setMinimumLineSpacing:(CGFloat)minimumSpacingInLines;

@end

/**
 ** Default Linker
 */
@interface DefaultCellLinkerGG : NSObject <ILinkerGG>
@property (strong, nonatomic) Class<IRenderGG> collectionCellHeaderRender;
@property (strong, nonatomic) Class<IRenderGG> collectionCellRender;
@end

/**
 ** Default Data
 */
@interface DefaultCellDataGG : NSObject <IDataGG>
@property (strong, nonatomic) NSString *parsingXpath;
@end
