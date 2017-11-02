//
//  WCDynamicFlowLayout.m
//  FIFA_WC14
//
//  Created by Mathieu Lanoy on 19/02/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "WCDynamicFlowLayout.h"
#import "Extends+Libs.h"

#define SPRING_RESISTANCE           2000.0f
#define SPRING_IPHONE_RESISTANCE    1500.0f
#define SCROLL_PADDING_RECT         100.0f

@implementation WCDynamicFlowLayout

- (id)init
{
    if (self = [super init])
    {
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visibleIndexPathsSet = [NSMutableSet new];
        self.visibleHeaderAndFooterSet = [NSMutableSet new];

        if ([UIDevice isRetina])
            self.animationEnabled = YES;
        else
            self.animationEnabled = NO;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.spring_resistance = SPRING_RESISTANCE;
        else
            self.spring_resistance = SPRING_IPHONE_RESISTANCE;
    }
    return self;
}

- (void) setAnimationEnabled:(BOOL)animationEnabled
{
    if ([UIDevice isRetina] && ([UIDevice isIPAD] || [UIDevice isIphone5]))
        _animationEnabled = animationEnabled;
    else
        _animationEnabled = NO;
 
}

- (void) prepareLayout
{
    [super prepareLayout];

    if (self.animationEnabled)
    {
        CGRect originalRect = (CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size};
        CGRect visibleRect = CGRectInset(originalRect, -300, -300);
        NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
        NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];

        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
            BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[(UICollectionViewLayoutAttributes*)[[behaviour items] firstObject] indexPath]] != nil;
            return !currentlyVisible;
        }];

        NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:predicate];

        [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            [self.dynamicAnimator removeBehavior:obj];
            [self.visibleIndexPathsSet removeObject:[(UICollectionViewLayoutAttributes*)[[obj items] firstObject] indexPath]];
            [self.visibleHeaderAndFooterSet removeObject:[(UICollectionViewLayoutAttributes*)[[obj items] firstObject] indexPath]];
        }];

        predicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
            return (item.representedElementCategory == UICollectionElementCategoryCell ?
                    [self.visibleIndexPathsSet containsObject:item.indexPath] : [self.visibleHeaderAndFooterSet containsObject:item.indexPath]) == NO;
        }];
        NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:predicate];
        CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];

        [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
            CGPoint center = item.center;
            UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];

            springBehaviour.length = 0.0f;
            springBehaviour.damping = 0.8f;
            springBehaviour.frequency = 1.5f;

            if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
              CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
              CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
                CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / self.spring_resistance;

                if (self.latestDelta < 0) {
                    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
                        center.x += MAX(self.latestDelta, self.latestDelta*scrollResistance);
                    else
                        center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
                }
                else {
                    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
                        center.x += MIN(self.latestDelta, self.latestDelta*scrollResistance);
                    else
                        center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
                }
                item.center = center;
            }

            [self.dynamicAnimator addBehavior:springBehaviour];

            if(item.representedElementCategory == UICollectionElementCategoryCell)
            {
                [self.visibleIndexPathsSet addObject:item.indexPath];
            }
            else
            {
                [self.visibleHeaderAndFooterSet addObject:item.indexPath];
            }
        }];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *answer = nil;

    if (self.animationEnabled)
    {
        CGFloat padding = SCROLL_PADDING_RECT;

        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            rect.size.height += 3*padding;
            rect.origin.y -= padding;
        }
        else
        {
            rect.size.width += 3*padding;
            rect.origin.x -= padding;
        }

        answer = [[self.dynamicAnimator itemsInRect:rect] mutableCopy];
    }
    else
    {
        answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    }

    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];

    for (NSUInteger idx = 0; idx < [answer count]; idx++)
    {
        UICollectionViewLayoutAttributes *layoutAttributes = answer[idx];

        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            [answer removeObjectAtIndex:idx];
            idx--;
        }
    }

    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (layoutAttributes)
        {
            [answer addObject:layoutAttributes];
        }
    }];

    return answer;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    CGRect frame = attributes.frame;
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);

    if (self.animationEnabled)
    {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            CGFloat origin = MIN(MAX(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
            CGFloat content_offset_y = cv.contentOffset.y;
            CGFloat diff_pos = content_offset_y - origin;
            if (diff_pos != 0.0f)
                attributes = [self.dynamicAnimator layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
        }
        else
        {
            CGFloat origin = MIN(MAX(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
            CGFloat content_offset_x = cv.contentOffset.y;
            CGFloat diff_pos = content_offset_x - origin;
            if (diff_pos != 0.0f)
                attributes = [self.dynamicAnimator layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
        }
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if (indexPath.section+1 < [cv numberOfSections])
        {
            UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section+1]];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }
        frame = attributes.frame;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            frame.origin.y = MIN(MAX(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
        }
        else
        {
            frame.origin.x = MIN(MAX(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
        }

        attributes.zIndex = 1024;
        attributes.frame = frame;
    }

    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *dynamicLayoutAttributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];

    // Check if dynamic animator has layout attributes for a layout, otherwise use the flow layouts properties.
    return (dynamicLayoutAttributes ? dynamicLayoutAttributes : [super layoutAttributesForItemAtIndexPath:indexPath]);
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (self.animationEnabled)
    {
        UIScrollView *scrollView = self.collectionView;
        CGFloat delta = 0.0f;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
            delta = newBounds.origin.x - scrollView.bounds.origin.x;
        else
            delta = newBounds.origin.y - scrollView.bounds.origin.y;

        CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];

        [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
          CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
          CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / self.spring_resistance;

            UICollectionViewLayoutAttributes *item = springBehaviour.items.firstObject;
            CGPoint center = item.center;
            if (delta < 0)
            {
                if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
                    center.x += MAX(delta, delta*scrollResistance);
                else
                    center.y += MAX(delta, delta*scrollResistance);
            }
            else
            {
                if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
                    center.x += MIN(delta, delta*scrollResistance);
                else
                    center.y += MIN(delta, delta*scrollResistance);
            }
            item.center = center;
            
            [self.dynamicAnimator updateItemUsingCurrentState:item];
        }];
        
        self.latestDelta = delta;
    }
    
    return YES;
}

@end
