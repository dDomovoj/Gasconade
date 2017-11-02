//
//  UICollectionViewGG.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "UICollectionViewGG.h"
#import "WCDynamicFlowLayout.h"
#import "Extends+Libs.h"
#import "WCDynamicFlowLayout.h"

#define EMPTY_HEADER_IDENTIFIER @"Empty_header_identifier"

@interface UICollectionViewGG()
{
    // Refreshing
    BOOL hasLaunchedFirstViewLoading;
    UIRefreshControl *refreshControl;
    UIColor *colorForRefreshControl;
    UILabel *lb_noDataInfo;
    
    // Autorefresh
    NSTimer *timerAutoRefresh;
    CGFloat autoRefreshDelay;
    BOOL autoRefreshActivated;
    
    // Flow layout
    WCDynamicFlowLayout *dynamicFlowLayout;
    UICollectionViewFlowLayout *collectionViewFlowLayout;
    
    // Pagination
    BOOL canAskForMore;
    BOOL lastMoreDataCallHasData;
    NSInteger page;
    NSInteger limit;
}
@end

@implementation UICollectionViewGG

#pragma Init
-(id)init
{
    self = [super init];
    if (self)
        [self myInit];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self myInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self myInit];
    return self;
}

-(id) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
        [self myInit];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isPullToRefreshEnabled == YES && !refreshControl)
    {
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(startRefresh:)
                 forControlEvents:UIControlEventValueChanged];
        [refreshControl setTintColor:colorForRefreshControl ? colorForRefreshControl : [UIColor whiteColor]];
        [refreshControl setFrame:CGRectMake(refreshControl.frame.origin.x, 0, refreshControl.frame.size.width, refreshControl.frame.size.height)];
        [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
        [self addSubview:refreshControl];
        [self sendSubviewToBack:refreshControl];
    }
    if (hasLaunchedFirstViewLoading == NO)
    {
        hasLaunchedFirstViewLoading = YES;
        if (!self.viewFirstLoading)
        {
            UIActivityIndicatorView *activityLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activityLoader setFrame:CGRectMake(self.frame.size.width/2.0 - activityLoader.frame.size.width/2, self.frame.size.height/2.0 - activityLoader.frame.size.height/2, activityLoader.frame.size.width, activityLoader.frame.size.height)];
            [activityLoader setColor:colorForRefreshControl ? colorForRefreshControl : [UIColor whiteColor]];
            [self addSubview:activityLoader];
            self.viewFirstLoading = activityLoader;
        }
        [self launchFirstViewLoading];
    }
}

-(void) myInit
{
    page = 1;
    limit = 5;
    canAskForMore = NO;
    autoRefreshActivated = NO;
    lastMoreDataCallHasData = NO;
    hasLaunchedFirstViewLoading = NO;
    
    self.alwaysBounceVertical = YES;
    self.alwaysBounceHorizontal = NO;
    
    [self setPullToRefreshEnabled:YES];
    [self setDynamicFlowLayoutEnable:NO];
}

-(void)launchFirstViewLoading
{
    if (self.viewFirstLoading && [self.viewFirstLoading isKindOfClass:[UIView class]])
    {
        if ([self.viewFirstLoading respondsToSelector:@selector(startAnimating)])
        {
            [self.viewFirstLoading setAlpha:1];
            [self.viewFirstLoading setHidden:NO];
            [self.viewFirstLoading performSelector:@selector(startAnimating)];
        }
    }
}

-(void)stopFirstViewLoading
{
    if (self.viewFirstLoading && [self.viewFirstLoading isKindOfClass:[UIView class]])
    {
        if ([self.viewFirstLoading respondsToSelector:@selector(stopAnimating)])
        {
            [self.viewFirstLoading setAlpha:0];
            [self.viewFirstLoading setHidden:YES];
            [self.viewFirstLoading performSelector:@selector(stopAnimating)];
        }
        [self.viewFirstLoading removeFromSuperview];
        self.viewFirstLoading = nil;
    }
}

-(void) setPullToRefreshEnabled:(BOOL)pullToRefreshEnabled
{
    _isPullToRefreshEnabled = pullToRefreshEnabled;
    
    if (_isPullToRefreshEnabled == NO && refreshControl)
    {
        [refreshControl removeFromSuperview];
        refreshControl = nil;
    }
}

-(void) setSimpleDataRenderingUsingXpath:(NSString*)xpath
{
	DefaultCellDataGG *defaultCellData = [[DefaultCellDataGG alloc] init];
	defaultCellData.parsingXpath = xpath;
    self.dataRendering = defaultCellData;
}

-(void) setRender:(Class <IRenderGG>)render
{
    [self setRender:render andHeaderRender:nil];
}

-(void) setRender:(Class <IRenderGG>)render andHeaderRender:(Class <IRenderGG>)headerRender
{
	if (self.itemLinker == nil)
		self.itemLinker = [[DefaultCellLinkerGG alloc] init];
    
	if ([self.itemLinker isKindOfClass:[DefaultCellLinkerGG class]])
    {
		DefaultCellLinkerGG *tmp = (DefaultCellLinkerGG *)self.itemLinker;
        if (render)
            [tmp setCollectionCellRender:render];
        if (headerRender)
            [tmp setCollectionCellHeaderRender:headerRender];
	}
}

-(void) loadConfiguration
{
    if (!self.itemLinker)
    {
        DLog(@"No itemLinker<ILinkerGG> found !");
        return ;
    }
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return ;
    }
    if (![self.itemLinker respondsToSelector:@selector(getAllICRenderClassesUsed)])
    {
        DLog(@"Linker must implement getAllICRenderClassesUsed to let the UICollectionView register to the Nib !");
        return ;
    }
    
    for (Class<IRenderGG> render in [self.itemLinker getAllICRenderClassesUsed])
    {
        if ([[NSBundle mainBundle] pathForResource:[render getIdentifierCell] ofType:@"nib"] != nil)
            [self registerNib:[UINib nibWithNibName:[render getIdentifierCell] bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[render getIdentifierCell]];
        else
            [self registerClass:NSClassFromString([render getIdentifierCell]) forCellWithReuseIdentifier:[render getIdentifierCell]];
    }
    
    if ([self.itemLinker respondsToSelector:@selector(getAllICHeaderRenderClassesUsed)])
    {
        for (Class<IRenderGG> render in [self.itemLinker getAllICHeaderRenderClassesUsed])
        {
            if ([[NSBundle mainBundle] pathForResource:[render getIdentifierCell] ofType:@"nib"] != nil)
                [self registerNib:[UINib nibWithNibName:[render getIdentifierCell] bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[render getIdentifierCell]];
            else
                [self registerClass:NSClassFromString([render getIdentifierCell]) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[render getIdentifierCell]];
        }
    }
    else
    {
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EMPTY_HEADER_IDENTIFIER];
    }
    
    self.dataSource = self;
    self.delegate = self;
    
    if (self.callRefresh)
        self.callRefresh();
}

#pragma Setter - Overwrite
-(void)setDynamicFlowLayoutEnable:(BOOL)dynamicFlowLayoutEnabled
{
    _isUsingDynamicFlowLayout = dynamicFlowLayoutEnabled;
    
    NSIndexPath *indexPathFirstItem;
    if ([self.itemLinker respondsToSelector:@selector(getICHeaderRenderForSection:andData:)] &&
        [self.dataRendering respondsToSelector:@selector(getElementForSection:fromData:)] &&
        [self.dataRendering getElementForSection:0 fromData:self.data])
        indexPathFirstItem = [NSIndexPath indexPathForRow:1 inSection:0];
    else
        indexPathFirstItem = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if ([self.itemLinker respondsToSelector:@selector(getICRenderForIndexPath:andData:)])
    {
        id dataForFirstItem = [self.dataRendering getElementForIndexPath:indexPathFirstItem fromData:self.data];
        CGSize mainItemSize = [[self.itemLinker getICRenderForIndexPath:indexPathFirstItem andData:dataForFirstItem] getSizeCellforData:dataForFirstItem indexPath:indexPathFirstItem collectionView:self];
        
        if (_isUsingDynamicFlowLayout)
        {
            // Dynamic flow layout init
            if (!dynamicFlowLayout)
            {
                dynamicFlowLayout = [WCDynamicFlowLayout new];
                dynamicFlowLayout.spring_resistance  = 600.0f;
                [dynamicFlowLayout setMinimumLineSpacing:0.0f];
                [dynamicFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            }
            
            [dynamicFlowLayout setItemSize:mainItemSize];
            self.collectionViewLayout = dynamicFlowLayout;
        }
        else if (!_isUsingDynamicFlowLayout)
        {
            // Simple Collection FlowLayout
            if (!collectionViewFlowLayout)
            {
                collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
                [collectionViewFlowLayout setMinimumLineSpacing:0.0f];
            }
            [collectionViewFlowLayout setItemSize:mainItemSize];
            self.collectionViewLayout = collectionViewFlowLayout;
        }
        else
        {
            DLog(@"No collectionFlowLayout at all!");
        }
    }
    else
    {
        DLog(@"Linker does not provide a render!");
    }
}

-(void)setMinimumRowSpacing:(CGFloat)minimumSpacingInRow
{
    if (self.isUsingDynamicFlowLayout && dynamicFlowLayout)
    {
        [dynamicFlowLayout setMinimumInteritemSpacing:minimumSpacingInRow];
    }
    else if (!self.isUsingDynamicFlowLayout && collectionViewFlowLayout)
    {
        [collectionViewFlowLayout setMinimumInteritemSpacing:minimumSpacingInRow];
    }
    else
    {
        if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
            [((UICollectionViewFlowLayout *)self.collectionViewLayout) setMinimumInteritemSpacing:minimumSpacingInRow];
    }
}

-(void)setMinimumLineSpacing:(CGFloat)minimumSpacingInLines
{
    if (self.isUsingDynamicFlowLayout && dynamicFlowLayout)
    {
        [dynamicFlowLayout setMinimumLineSpacing:minimumSpacingInLines];
    }
    else if (!self.isUsingDynamicFlowLayout && collectionViewFlowLayout)
    {
        [collectionViewFlowLayout setMinimumLineSpacing:minimumSpacingInLines];
    }
    else
    {
        if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
            [((UICollectionViewFlowLayout *)self.collectionViewLayout) setMinimumLineSpacing:minimumSpacingInLines];
    }
}

#pragma Autorefresh Controls
-(void) startAutoRefresh
{
    autoRefreshActivated = YES;
    autoRefreshDelay = UICOLLECTIONVIEWGG_DEFAULT_AUTO_REFRESH_DELAY;
}

-(void) startAutoRefreshWithSeconds:(CGFloat)seconds
{
    autoRefreshActivated = YES;
    autoRefreshDelay = seconds;
}

-(void) endAutoRefresh
{
    autoRefreshActivated = NO;
    autoRefreshDelay = 0;
    
    if (timerAutoRefresh)
    {
        [timerAutoRefresh invalidate];
        timerAutoRefresh = nil;
    }
}

-(void)autoRefreshTimerFired
{
    if (!self.callRefresh)
    {
        DLog(@"Timer for autorefreshing has been fired but, the call back callRefresh: has not been set. Terminating here...");
        return ;
    }
    DLog(@"<< Autorefresh >>");
    self.callRefresh();
}

#pragma Pull to refresh Controls
-(void) setRefreshControlColor:(UIColor *)color
{
    if (color)
        colorForRefreshControl = color;
    
    if (refreshControl && color)
        [refreshControl setTintColor:color];
    
    if (self.viewFirstLoading && color)
    {
        [self.viewFirstLoading setTintColor:color];
        if ([self.viewFirstLoading respondsToSelector:@selector(setColor:)])
        {
            [self.viewFirstLoading performSelector:@selector(setColor:) withObject:color];
        }
    }
}

-(void) beginRefreshing
{
    if (refreshControl)
    {
        [refreshControl setTintColor:colorForRefreshControl];
        [refreshControl beginRefreshing];
    }
}

-(void) endRefreshing
{
    if (refreshControl)
        [refreshControl endRefreshing];
}

#pragma UIRefreshControl - Selector called on event UIControlEventValueChanged
-(void)startRefresh:(id)sender
{
    if (self.callRefresh)
        self.callRefresh();
    else
        [self endRefreshing];
}

#pragma No Info View
-(void) showNoInfoView
{
    if (!lb_noDataInfo)
    {
        lb_noDataInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 40)];
        [lb_noDataInfo setBackgroundColor:[UIColor clearColor]];
        [lb_noDataInfo setTextAlignment:NSTextAlignmentCenter];
        lb_noDataInfo.numberOfLines = 10000;
        [lb_noDataInfo setLineBreakMode:NSLineBreakByWordWrapping];
        [lb_noDataInfo setAlpha:0];
        [self addSubview:lb_noDataInfo];
    }
    else
    {
        [lb_noDataInfo setFrame:CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 40)];
    }
    if (self.attributedNoDataText)
    {
        [lb_noDataInfo setAttributedText:self.attributedNoDataText];
        [self bringSubviewToFront:lb_noDataInfo];
        
        [lb_noDataInfo bouingAppear:YES oncomplete:^{
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [lb_noDataInfo setAlpha:1];
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)hideNoInfoView
{
    if (lb_noDataInfo)
        [lb_noDataInfo removeFromSuperview];
    lb_noDataInfo = nil;
}

-(void) setMoreData:(NSDictionary *)moreData
{
    if (!moreData)
    {
        DLog(@"Data doesn't exist!");
        return ;
    }
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return ;
    }
    
    if ([self.dataRendering respondsToSelector:@selector(mergeOldData:withNewOne:)])
    {
        NSDictionary *dictOfMergedData = [self.dataRendering mergeOldData:self.data withNewOne:moreData];
        
        if (!dictOfMergedData)
            return;
        
        page += 1;
        _data = dictOfMergedData;
        [self.collectionViewLayout invalidateLayout];
        [self reloadData];
        canAskForMore = YES;
        
        if ([self.dataRendering getNumberOfRowsInSection:0 forData:moreData] > 0)
        {
            lastMoreDataCallHasData = YES;
        }
        else
        {
            lastMoreDataCallHasData = NO;
        }
    }
    else
    {
        DLog(@"DataRendering<IDataGG> doesn't implement mergeOldData:withNewOne:");
    }
}

#pragma Data
-(void) setData:(NSDictionary *)data
{
    if (!data)
    {
        DLog(@"Data doesn't exist!");
        return ;
    }
    else
    {
        if (!self.dataRendering)
        {
            [self showNoInfoView];
            DLog(@"No dataRendering<IDataGG> found !");
        }
        else
        {
            BOOL shouldDisplayNoInfoView = NO;
            if ([self.dataRendering respondsToSelector:@selector(getNumberOfSectionsForData:)])
            {
                if ([self.dataRendering getNumberOfSectionsForData:data] == 0)
                    shouldDisplayNoInfoView = YES;
                else
                    shouldDisplayNoInfoView = NO;
            }
            else if ([self.dataRendering respondsToSelector:@selector(getNumberOfRowsInSection:forData:)])
            {
                if ([self.dataRendering getNumberOfRowsInSection:0 forData:data] == 0)
                    shouldDisplayNoInfoView = YES;
                else
                    shouldDisplayNoInfoView = NO;
            }
            if (shouldDisplayNoInfoView)
            {
                [self showNoInfoView];
                if (refreshControl && [refreshControl isRefreshing])
                    [refreshControl endRefreshing];
            }
            else
                [self hideNoInfoView];
        }
    }
    page = 1;
    _data = data;
    [self.collectionViewLayout invalidateLayout];
    [self reloadData];
    canAskForMore = YES;
    lastMoreDataCallHasData = YES;
    hasLaunchedFirstViewLoading = YES;
    
    [self stopFirstViewLoading];
    
    //    if (refreshControl && refreshControl.isRefreshing)
    //        [refreshControl endRefreshing];
    
    if (timerAutoRefresh)
    {
        [timerAutoRefresh invalidate];
        timerAutoRefresh = nil;
    }
    if (autoRefreshActivated && autoRefreshDelay > 0.0)
    {
        timerAutoRefresh = [NSTimer scheduledTimerWithTimeInterval:autoRefreshDelay target:self selector:@selector(autoRefreshTimerFired) userInfo:nil repeats:NO];
    }
}

-(void)dealloc
{
    self.delegate = nil;
    self.delegateGG = nil;
    [self endAutoRefresh];
    
    _data = nil;
    if (refreshControl)
        [refreshControl removeFromSuperview];
    refreshControl = nil;
}

#pragma UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return 0;
    }
    
    // [self.collectionViewLayout invalidateLayout];
    
    if ([self.dataRendering respondsToSelector:@selector(getNumberOfSectionsForData:)])
        return [self.dataRendering getNumberOfSectionsForData:self.data];
    else
        return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return 0;
    }
    
    NSInteger numberOfItemsInSection = 0;
    if ([self.dataRendering respondsToSelector:@selector(getNumberOfRowsInSection:forData:)])
        numberOfItemsInSection = [self.dataRendering getNumberOfRowsInSection:section forData:self.data];
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return nil;
    }
    
    id dataForItemAtIndexPath = nil;
    if ([self.dataRendering respondsToSelector:@selector(getElementForIndexPath:fromData:)])
        dataForItemAtIndexPath = [self.dataRendering getElementForIndexPath:indexPath fromData:self.data];
    
    if (!self.parentViewController)
        DLog(@"No parentViewController for UICollectionViewGG !");
    
    UICollectionViewCell *collectionViewCell = [self.itemLinker getCellForIndexPath:indexPath withData:dataForItemAtIndexPath inCollectionView:collectionView andParentViewController:self.parentViewController];
    
    if (self.delegateGG && [self.delegateGG respondsToSelector:@selector(willDisplayCell:withData:inCollectionView:atIndexPath:)])
        [self.delegateGG willDisplayCell:collectionViewCell withData:dataForItemAtIndexPath inCollectionView:self atIndexPath:indexPath];
    
    __weak UICollectionViewGG *weak_self = self;
    [NSObject backGroundBlock:^{
        
        if (indexPath.section == [weak_self numberOfSectionsInCollectionView:weak_self]-1 &&
            indexPath.row == [weak_self numberOfItemsInSection:indexPath.section]-2)
        {
            if (page == 1 && limit > [weak_self numberOfItemsInSection:indexPath.section])
                return;
            
            if (weak_self.callMoreData && canAskForMore == YES && lastMoreDataCallHasData == YES)
            {
                canAskForMore = NO;
                [NSObject mainThreadBlock:^{
                    weak_self.callMoreData();
                }];
            }
        }
    }];
    return collectionViewCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (!self.dataRendering)
        {
            DLog(@"No dataRendering<IDataGG> found !");
            return reusableview;
        }
        if (!self.itemLinker)
        {
            DLog(@"No linker<ILinkerGG> found !");
            return reusableview;
        }
        
        id dataForSection = nil;
        if ([self.dataRendering respondsToSelector:@selector(getElementForSection:fromData:)])
        {
            dataForSection = [self.dataRendering getElementForSection:indexPath.section fromData:self.data];
            
            if (!self.parentViewController)
                DLog(@"No parentViewController for UICollectionViewGG !");
            
            if ([self.itemLinker respondsToSelector:@selector(getHeaderCellForIndexPath:withData:inCollectionView:andParentViewController:)])
            {
                UICollectionReusableView *headerCollectionView = [self.itemLinker getHeaderCellForIndexPath:indexPath withData:dataForSection inCollectionView:self andParentViewController:self.parentViewController];
                return headerCollectionView;
            }
        }
    }
    reusableview = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EMPTY_HEADER_IDENTIFIER forIndexPath:indexPath];
    return reusableview;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return CGSizeMake(0, 0);
    }
    if (!self.itemLinker)
    {
        DLog(@"No linker<ILinkerGG> found !");
        return CGSizeMake(0, 0);
    }
    
    id dataForSection = nil;
    if ([self.dataRendering respondsToSelector:@selector(getElementForSection:fromData:)])
    {
        dataForSection = [self.dataRendering getElementForSection:section fromData:self.data];
        
        if ([self.itemLinker respondsToSelector:@selector(getICHeaderRenderForSection:andData:)])
        {
            Class <IRenderGG> headerRender = [self.itemLinker getICHeaderRenderForSection:section andData:dataForSection];
            
            CGSize sizeOfHeader = [headerRender getSizeCellforData:dataForSection indexPath:[NSIndexPath indexPathForRow:0 inSection:section] collectionView:self];
            return sizeOfHeader;
        }
    }
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return CGSizeMake(0, 0);
    }
    if (!self.itemLinker)
    {
        DLog(@"No linker<ILinkerGG> found !");
        return CGSizeMake(0, 0);
    }
    
    id dataForSection = nil;
    if ([self.dataRendering respondsToSelector:@selector(getElementForIndexPath:fromData:)])
    {
        dataForSection = [self.dataRendering getElementForIndexPath:indexPath fromData:self.data];
        if ([self.itemLinker respondsToSelector:@selector(getICRenderForIndexPath:andData:)])
        {
            Class <IRenderGG> render = [self.itemLinker getICRenderForIndexPath:indexPath andData:dataForSection];
            if (render)
            {
                CGSize sizeOfRender = [render getSizeCellforData:dataForSection indexPath:indexPath collectionView:self];
                return sizeOfRender;
            }
        }
    }
    return CGSizeMake(0, 0);
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.delegateGG)
    {
        DLog(@"No delegateGG<UICollectionViewGGDelegate> found !");
        return ;
    }
    if (!self.dataRendering)
    {
        DLog(@"No dataRendering<IDataGG> found !");
        return ;
    }
    if (!self.data)
    {
        DLog(@"No data in UICollectionView !");
        return ;
    }
    
    if ([self.delegateGG respondsToSelector:@selector(didSelectItemAtIndexPath:withData:inCollectionView:)])
    {
        id data = [self.dataRendering getElementForIndexPath:indexPath fromData:self.data];
        [self.delegateGG didSelectItemAtIndexPath:indexPath withData:data inCollectionView:self];
    }
    else
        DLog(@"DelegateGG<UICollectionViewGGDelegate> should implement didSelectItemAtIndexPath:withData:inCollectionView:");
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (refreshControl && [refreshControl isRefreshing])
        [refreshControl endRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.delegateGG)
    {
        DLog(@"No delegateGG<UICollectionViewGGDelegate> found !");
        return ;
    }
    
    if ([self.delegateGG respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegateGG scrollViewDidScroll:self];
}

@end

/*
 ** DefaultCellDataGG
 */
#pragma DefaultCellData
@implementation DefaultCellDataGG

-(id) getElementForIndexPath:(NSIndexPath *)indexPath fromData:(id)data
{
    return [data getXpath:[NSString stringWithFormat:@"%@[%ld]"
						   , self.parsingXpath
						   ,(long)indexPath.row] type:[NSObject class] def:nil];
}

-(NSInteger) getNumberOfRowsInSection:(NSInteger)section forData:(id)data
{
	return [[data getXpathNilArray:self.parsingXpath] count];
}

-(NSInteger) getNumberOfSectionsForData:(id)data
{
    if (data)
    {
        NSArray *arrayData = [data getXpathNilArray:self.parsingXpath];
        if (arrayData && [arrayData count] > 0)
            return 1;
    }
    return 0;
}

-(id) mergeOldData:(id)data withNewOne:(NSDictionary *)newData
{
    if (!data)
        return data;
    
	NSArray *arrayInOldData =  [data getXpathNilArray:self.parsingXpath];
	arrayInOldData = [arrayInOldData arrayByAddingObjectsFromArray:[newData getXpathNilArray:self.parsingXpath]];
	NSMutableDictionary *dictionaryOfMergedData = [newData ToMutable];
    if (arrayInOldData)
		[dictionaryOfMergedData setObject:arrayInOldData forKey:[self.parsingXpath strReplace:@"/" to:@""]];
	return dictionaryOfMergedData;
}

-(id) getElementForSection:(NSInteger)section inData:(id)data
{
	if ([self getNumberOfRowsInSection:section forData:data])
		return [self getElementForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] fromData:data];
	return nil;
}

@end


/*
 ** DefaultCellLinkerGG
 */
#pragma DefaultLinker
@implementation DefaultCellLinkerGG

-(NSArray *) getAllICRenderClassesUsed
{
    NSMutableArray *arrayOfAllRenderUsed = [[NSMutableArray alloc] init];
    if (self.collectionCellHeaderRender)
        [arrayOfAllRenderUsed addObject:self.collectionCellHeaderRender];
    if (self.collectionCellRender)
        [arrayOfAllRenderUsed addObject:self.collectionCellRender];
    return arrayOfAllRenderUsed;
}

-(Class<IRenderGG>) getICRenderForIndexPath:(NSIndexPath *)indexPath andData:(id)data;
{
	return self.collectionCellRender;
}

-(UICollectionViewCell *) getCellForIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionView *)collectionView andParentViewController:(UIViewController *)parentViewController
{
	Class<IRenderGG> render = [self getICRenderForIndexPath:indexPath andData:dataElement];
    
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:[render getIdentifierCell] forIndexPath:indexPath];
    
    return (UICollectionViewCell *)[render getCell:collectionViewCell forData:dataElement indexPath:indexPath collectionView:collectionView parentViewController:parentViewController];
}

-(Class<IRenderGG>) getICHeaderRenderForSection:(NSInteger)section andData:(id)data
{
    return self.collectionCellHeaderRender;
}

-(UICollectionReusableView *) getHeaderCellForIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionView *)collectionView andParentViewController:(UIViewController *)parentViewController
{
	Class<IRenderGG> headerRender = [self getICHeaderRenderForSection:indexPath.section andData:dataElement];
    
    UICollectionReusableView *collectionViewHeaderCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[headerRender getIdentifierCell] forIndexPath:indexPath];
    
    return [headerRender getCell:collectionViewHeaderCell forData:dataElement indexPath:indexPath collectionView:collectionView parentViewController:parentViewController];
}

@end
