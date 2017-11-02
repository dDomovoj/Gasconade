//
//  CHDraggableView.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eCHDraggableViewSimple, // Make the coordinator call didClickOnBubble
    eCHDraggableViewOpenPanel, // Make the coordinator call didAskForViewControllerToPresent:fromBubble or didAskForNavigationControllerToPresent
    
} eCHDraggableViewType;

@class CHDraggableView;

@protocol CHDraggableViewDelegate <NSObject>

- (void)draggableViewHold:(CHDraggableView *)view;
- (void)draggableView:(CHDraggableView *)view didMoveToPoint:(CGPoint)point;
- (void)draggableViewReleased:(CHDraggableView *)view;

- (void)draggableViewTouched:(CHDraggableView *)view;
- (void)draggableViewNeedsAlignment:(CHDraggableView *)view;

- (void)draggableViewLongTouched:(CHDraggableView *)view;

@end


@interface CHDraggableView : UIView

@property (nonatomic, assign) eCHDraggableViewType bubbleType;
@property (nonatomic, assign) id<CHDraggableViewDelegate> delegate;

- (void)snapViewCenterToPoint:(CGPoint)point edge:(CGRectEdge)edge;

@end
