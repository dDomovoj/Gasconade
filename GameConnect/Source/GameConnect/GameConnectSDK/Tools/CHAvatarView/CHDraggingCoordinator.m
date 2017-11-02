//
//  CHDraggingCoordinator.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CHDraggingCoordinator.h"
#import "UIDevice+UIDevice_Tool.h"
#import "CHDraggableView.h"

@interface CHDraggingCoordinator ()
{
    CHDraggableView *bubblePresentingViewController;
}
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSMutableDictionary *edgePointDictionary;;
@property (nonatomic, assign) CGRect draggableViewBounds;
@property (nonatomic, strong) UINavigationController *presentedNavigationController;
@property (nonatomic, strong) UIViewController *presentedViewController;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation CHDraggingCoordinator

- (id)initWithContainer:(UIView *)view draggableViewBounds:(CGRect)bounds
{
    self = [super init];
    if (self)
    {
        _container = view;
        _draggableViewBounds = bounds;
        _state = CHInteractionStateNormal;
        _edgePointDictionary = [NSMutableDictionary dictionary];
        _presentedNavigationController = nil;
        _presentedViewController = nil;
    }
    return self;
}

#pragma mark - Geometry

- (CGRect)_dropArea
{
    return CGRectInset(self.container.bounds, 0, 64);
}

- (CGRect)_conversationArea
{
    CGRect slice;
    CGRect remainder;
    CGFloat widthArea = [UIDevice isIPAD] ? 400 : 320;
    
    CGRectDivide(CGRectMake(self.container.bounds.size.width/2 - widthArea/2, 64, widthArea, self.container.bounds.size.height - 64), &slice, &remainder, CGRectGetHeight(CGRectInset(_draggableViewBounds, 0, 0)), CGRectMinYEdge);

    return slice;
}

- (CGRectEdge)_destinationEdgeForReleasePointInCurrentState:(CGPoint)releasePoint
{
    if (_state == CHInteractionStateConversation) {
        return CGRectMinYEdge;
    } else if(_state == CHInteractionStateNormal) {
        return releasePoint.x < CGRectGetMidX([self _dropArea]) ? CGRectMinXEdge : CGRectMaxXEdge;
    }
    NSAssert(false, @"State not supported");
    return CGRectMinYEdge;
}

- (CGPoint)_destinationPointForReleasePoint:(CGPoint)releasePoint
{
    CGRect dropArea = [self _dropArea];
    
    CGFloat midXDragView = CGRectGetMidX(_draggableViewBounds);
    CGRectEdge destinationEdge = [self _destinationEdgeForReleasePointInCurrentState:releasePoint];
    CGFloat destinationY;
    CGFloat destinationX;
 
    CGFloat topYConstraint = CGRectGetMinY(dropArea) + CGRectGetMidY(_draggableViewBounds);
    CGFloat bottomYConstraint = CGRectGetMaxY(dropArea) - CGRectGetMidY(_draggableViewBounds);
    if (releasePoint.y < topYConstraint) { // Align ChatHead vertically
        destinationY = topYConstraint;
    }else if (releasePoint.y > bottomYConstraint) {
        destinationY = bottomYConstraint;
    }else {
        destinationY = releasePoint.y;
    }

    if (self.snappingEdge == CHSnappingEdgeBoth){   //ChatHead will snap to both edges
        if (destinationEdge == CGRectMinXEdge) {
            destinationX = CGRectGetMinX(dropArea) + midXDragView;
        } else {
            destinationX = CGRectGetMaxX(dropArea) - midXDragView;
        }
        
    }else if(self.snappingEdge == CHSnappingEdgeLeft){  //ChatHead will snap only to left edge
        destinationX = CGRectGetMinX(dropArea) + midXDragView;
        
    }else{  //ChatHead will snap only to right edge
        destinationX = CGRectGetMaxX(dropArea) - midXDragView;
    }

    return CGPointMake(destinationX, destinationY);
}

#pragma mark - Dragging
- (void)draggableViewLongTouched:(CHDraggableView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        [view setAlpha:0];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)draggableViewHold:(CHDraggableView *)view
{
}

- (void)draggableView:(CHDraggableView *)view didMoveToPoint:(CGPoint)point
{
    if (_state == CHInteractionStateConversation)
    {
        if (_presentedViewController)
            [self _dismissPresentedViewControllerFrom:view];
            
        if (_presentedNavigationController)
            [self _dismissPresentedNavigationController:view];
    }
}

- (void)draggableViewReleased:(CHDraggableView *)view
{
    if (_state == CHInteractionStateNormal)
        [self _animateViewToEdges:view];
    else if(_state == CHInteractionStateConversation)
    {
        [self _animateViewToConversationArea:view];
        [self _presentViewControllerForDraggableView:view];
    }
}

- (void)draggableViewTouched:(CHDraggableView *)view
{
    if (view.bubbleType == eCHDraggableViewSimple)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnBubble:)])
            [self.delegate performSelector:@selector(didClickOnBubble:) withObject:view];
    }
    else if (view.bubbleType == eCHDraggableViewOpenPanel)
    {
        if (_state == CHInteractionStateNormal)
        {
            _state = CHInteractionStateConversation;
            [self _animateViewToConversationArea:view];
            [self _presentViewControllerForDraggableView:view];
        }
        else if (_state == CHInteractionStateConversation)
        {
            _state = CHInteractionStateNormal;
            NSValue *knownEdgePoint = [_edgePointDictionary objectForKey:@(view.tag)];
            if (knownEdgePoint)
                [self _animateView:view toEdgePoint:[knownEdgePoint CGPointValue]];
            else
                [self _animateViewToEdges:view];
            
            if (_presentedNavigationController)
                [self _dismissPresentedNavigationController:view];
            
            if (_presentedViewController)
                [self _dismissPresentedViewControllerFrom:view];
        }
    }
}

#pragma mark - Alignment

- (void)draggableViewNeedsAlignment:(CHDraggableView *)view
{
    NSLog(@"Align view");
    [self _animateViewToEdges:view];
}

#pragma mark Dragging Helper

- (void)_animateViewToEdges:(CHDraggableView *)view
{
    CGPoint destinationPoint = [self _destinationPointForReleasePoint:view.center];    
    [self _animateView:view toEdgePoint:destinationPoint];
}

- (void)_animateView:(CHDraggableView *)view toEdgePoint:(CGPoint)point
{
    [_edgePointDictionary setObject:[NSValue valueWithCGPoint:point] forKey:@(view.tag)];
    [view snapViewCenterToPoint:point edge:[self _destinationEdgeForReleasePointInCurrentState:view.center]];
}

- (void)_animateViewToConversationArea:(CHDraggableView *)view
{
    CGRect conversationArea = [self _conversationArea];
    
    CGPoint center = CGPointMake(CGRectGetMidX(conversationArea), CGRectGetMidY(conversationArea));
    
    [view snapViewCenterToPoint:center edge:[self _destinationEdgeForReleasePointInCurrentState:view.center]];
}

#pragma mark - View Controller Handling

- (CGRect)_navigationControllerFrame
{
    CGRect slice;
    CGRect remainder;
    CGFloat widthArea = [UIDevice isIPAD] ? 400 : 320;

    CGRectDivide(CGRectMake(self.container.bounds.size.width/2 - widthArea/2, 64, widthArea, self.container.bounds.size.height - 64), &slice, &remainder, CGRectGetMaxY([self _conversationArea]), CGRectMinYEdge);
    return remainder;
}

- (CGRect)_navigationControllerHiddenFrame
{
    return CGRectMake(CGRectGetMidX([self _conversationArea]), CGRectGetMaxY([self _conversationArea]), 0, 0);
}

- (void)_presentViewControllerForDraggableView:(CHDraggableView *)draggableView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAskForViewControllerToPresent:fromBubble:)])
    {
        UIViewController *viewController = [self.delegate didAskForViewControllerToPresent:self fromBubble:draggableView];
        
        bubblePresentingViewController = draggableView;

        if (!viewController)
        {
            NSLog(@"[CGDraggingCoordinator] ViewController doens't exist!");
            return;
        }
        
        _presentedViewController = viewController;
        _presentedViewController.view.frame = [self _navigationControllerFrame];
        
        [_presentedViewController viewWillAppear:YES];
        [self.container insertSubview:_presentedViewController.view belowSubview:draggableView];
        [self _unhidePresentedViewControllerCompletion:^{ }];
    }
    else if (self.delegate && [self.delegate respondsToSelector:@selector(didAskForNavigationControllerToPresent:fromBubble:)])
    {
        bubblePresentingViewController = draggableView;
        
        _presentedNavigationController = [self.delegate didAskForNavigationControllerToPresent:self fromBubble:draggableView];
        _presentedNavigationController.view.layer.masksToBounds = YES;
        _presentedNavigationController.view.layer.anchorPoint = CGPointMake(0.5f, 0);
        _presentedNavigationController.view.frame = [self _navigationControllerFrame];
//        _presentedNavigationController.view.transform = CGAffineTransformMakeScale(0, 0);
        [_presentedNavigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        _presentedNavigationController.navigationBar.shadowImage = [UIImage new];
        _presentedNavigationController.navigationBar.translucent = YES;
        _presentedNavigationController.view.backgroundColor = [UIColor clearColor];
        
        [self.container insertSubview:_presentedNavigationController.view belowSubview:draggableView];
        [self _unhidePresentedNavigationControllerCompletion:^{}];
    }
}

#pragma mark - User Interaction
-(void)didClickOnDismissableBackground:(id)sender
{
    if (bubblePresentingViewController)
    {
        if (_state == CHInteractionStateConversation)
        {
            _state = CHInteractionStateNormal;
            NSValue *knownEdgePoint = [_edgePointDictionary objectForKey:@(bubblePresentingViewController.tag)];
            if (knownEdgePoint)
                [self _animateView:bubblePresentingViewController toEdgePoint:[knownEdgePoint CGPointValue]];
            else
                [self _animateViewToEdges:bubblePresentingViewController];
            
            [self _dismissPresentedNavigationController:bubblePresentingViewController];
            [self _dismissPresentedViewControllerFrom:bubblePresentingViewController];
        }
    }
}

#pragma mark - Management of Inserted simple ViewController
- (void)_unhidePresentedViewControllerCompletion:(void(^)(void))completionBlock
{
    if (!_presentedViewController)
        return;

//    CGAffineTransform transformStep1 = CGAffineTransformMakeScale(1.1f, 1.1f);
//    CGAffineTransform transformStep2 = CGAffineTransformMakeScale(1, 1);

    _backgroundView = [[UIView alloc] initWithFrame:[self.container bounds]];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.85f];
    _backgroundView.alpha = 0.0f;
    [self.container insertSubview:_backgroundView belowSubview:_presentedViewController.view];

    UIButton *buttonDismis = [[UIButton alloc] initWithFrame:_backgroundView.bounds];
    [buttonDismis addTarget:self action:@selector(didClickOnDismissableBackground:) forControlEvents:UIControlEventTouchUpInside];
    [buttonDismis setBackgroundColor:[UIColor clearColor]];
    [_backgroundView addSubview:buttonDismis];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _presentedViewController.view.layer.affineTransform = transformStep1;
        _backgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [UIView animateWithDuration:0.3f animations:^{
                // _presentedViewController.view.layer.affineTransform = transformStep2;
            }];
        }
    }];
}

- (void)_dismissPresentedViewControllerFrom:(CHDraggableView *)view
{
    if (!_presentedViewController)
        return ;
    
    UIViewController *reference = _presentedViewController;
    [self _hidePresentedViewControllerCompletion:^{
        
        [reference.view removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClosePresentedViewController:inCoordinator:fromBubble:)])
            [self.delegate didClosePresentedViewController:_presentedViewController inCoordinator:self fromBubble:view];
    }];
    _presentedViewController = nil;
}

- (void)_hidePresentedViewControllerCompletion:(void(^)(void))completionBlock
{
    if (!_presentedViewController)
        return;
    
    UIView *viewToDisplay = _backgroundView;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _presentedViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        _presentedViewController.view.alpha = 0.0f;
        _backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished)
    {
        if (finished)
        {
            [viewToDisplay removeFromSuperview];
            if (viewToDisplay == _backgroundView)
            {
                _backgroundView = nil;
            }
            completionBlock();
        }
    }];
}



#pragma mark - Management of Inserted NavigationController
- (void)_unhidePresentedNavigationControllerCompletion:(void(^)(void))completionBlock
{
    if (!_presentedNavigationController)
        return;
    
//    CGAffineTransform transformStep1 = CGAffineTransformMakeScale(1.1f, 1.1f);
//    CGAffineTransform transformStep2 = CGAffineTransformMakeScale(1, 1);
    
    _backgroundView = [[UIView alloc] initWithFrame:[self.container bounds]];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5f];
    _backgroundView.alpha = 0.0f;
    [self.container insertSubview:_backgroundView belowSubview:_presentedNavigationController.view];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _presentedNavigationController.view.layer.affineTransform = transformStep1;
        _backgroundView.alpha = 1.0f;
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.3f animations:^{
//                _presentedNavigationController.view.layer.affineTransform = transformStep2;
            }];
        }
    }];
}

- (void)_dismissPresentedNavigationController:(CHDraggableView *)view
{
    if (!_presentedNavigationController)
        return ;
    
    UINavigationController *reference = _presentedNavigationController;
    [self _hidePresentedNavigationControllerCompletion:^{
        [reference.view removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClosePresentedNavigationController:inCoordinator:fromBubble:)])
            [self.delegate didClosePresentedNavigationController:_presentedNavigationController inCoordinator:self fromBubble:view];

    }];
    _presentedNavigationController = nil;
}

- (void)_hidePresentedNavigationControllerCompletion:(void(^)(void))completionBlock
{
    if (!_presentedNavigationController)
        return;
    
    UIView *viewToDisplay = _backgroundView;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _presentedNavigationController.view.transform = CGAffineTransformMakeScale(0, 0);
        _presentedNavigationController.view.alpha = 0.0f;
        _backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished){
        if (finished) {
            [viewToDisplay removeFromSuperview];
            if (viewToDisplay == _backgroundView) {
                _backgroundView = nil;
            }
            completionBlock();
        }
    }];
}

@end
