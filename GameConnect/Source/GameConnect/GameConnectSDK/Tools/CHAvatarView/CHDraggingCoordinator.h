//
//  CHDraggingCoordinator.h
//  ChatHeads
//
//  Created by Matthias ; on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CHDraggableView.h"

typedef enum
{
    CHInteractionStateNormal,
    CHInteractionStateConversation
} CHInteractionState;

typedef enum
{
    CHSnappingEdgeBoth,
    CHSnappingEdgeRight,
    CHSnappingEdgeLeft
} CHSnappingEdge;

@class CHDraggingCoordinator;
@protocol CHDraggingCoordinatorDelegate <NSObject>
@optional

-(UINavigationController *) didAskForNavigationControllerToPresent:(CHDraggingCoordinator *)coordinator
                                                        fromBubble:(CHDraggableView *)draggableView;

-(void) didClosePresentedNavigationController:(UINavigationController *)navigationController
                            inCoordinator:(CHDraggingCoordinator *)coordinator
                                   fromBubble:(CHDraggableView *)draggableView;

-(UIViewController *) didAskForViewControllerToPresent:(CHDraggingCoordinator *)coordinator
                                            fromBubble:(CHDraggableView *)draggableView;

-(void) didClosePresentedViewController:(UIViewController *)viewController
                            inCoordinator:(CHDraggingCoordinator *)coordinator
                             fromBubble:(CHDraggableView *)draggableView;

-(void) didClickOnBubble:(CHDraggableView *)draggableView;

@end

@interface CHDraggingCoordinator : NSObject <CHDraggableViewDelegate>
@property (nonatomic) CHSnappingEdge snappingEdge;
@property (nonatomic, assign) CHInteractionState state;
@property (nonatomic, weak) id<CHDraggingCoordinatorDelegate> delegate;

- (id)initWithContainer:(UIView *)view draggableViewBounds:(CGRect)bounds;
- (void)draggableViewTouched:(CHDraggableView *)view;

@end

