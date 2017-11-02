//
//  GCEventLinker.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPEventLinker.h"
#import "GCAPPSoccerEventCell.h"
#import "GCAPPButtonCell.h"
#import "GCEventModel.h"
#import "DefaultCellRenderGG.h"

@interface GCAPPEventLinker ()
{
    Class<IRenderGG> renderFootballEvent;
    Class<IRenderGG> renderNoEventInfo;
    Class<IRenderGG> renderNavigationButton;
}
@end

@implementation GCAPPEventLinker

-(id)init
{
    self = [super init];
    if (self)
    {
        renderFootballEvent = [GCAPPSoccerEventCell class];
        renderNavigationButton = [GCAPPButtonCell class];
        renderNoEventInfo = [DefaultCellRenderGG class];
    }
    return self;
}

-(NSArray *) getAllICRenderClassesUsed
{
    return @[renderFootballEvent, renderNoEventInfo, renderNavigationButton];
}

-(Class<IRenderGG>) getICRenderForIndexPath:(NSIndexPath *)indexPath andData:(id)data
{
    if ([data isKindOfClass:[GCEventModel class]])
        return renderFootballEvent;
    else if ([data isKindOfClass:[NSAttributedString class]])
        return renderNoEventInfo;
    else
    {
        if (!data)
            return nil;
        return renderNavigationButton;
    }
}

-(UICollectionViewCell *) getCellForIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionView *)collectionView andParentViewController:(UIViewController *)parentViewController
{
	Class<IRenderGG> render = [self getICRenderForIndexPath:indexPath andData:dataElement];
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:[render getIdentifierCell] forIndexPath:indexPath];
    return (UICollectionViewCell *)[render getCell:collectionViewCell forData:dataElement indexPath:indexPath collectionView:collectionView parentViewController:parentViewController];
}


@end

