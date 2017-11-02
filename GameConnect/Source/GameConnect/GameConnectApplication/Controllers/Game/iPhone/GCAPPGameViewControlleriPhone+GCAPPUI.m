//
//  GCAPPGameViewControlleriPhone+GCUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 13/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPGameViewControlleriPhone+GCAPPUI.h"
#import "GCAPPGameViewControlleriPhone_Private.h"

@implementation GCAPPGameViewControlleriPhone (GCAPPUI)

-(void)setUpDynamicsForProfileView
{
    [self handleArrowImage];
    [self setUpGestureRecognizers];
    [self setUpAnimatorAndBehaviors];
    [self setUpWatchers];
}

-(void)setUpWatchers
{
    [self.v_containerRanking addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [self.v_containerRanking addObserver:self forKeyPath:@"center" options:0 context:nil];
}

-(void)stopWatchers
{
    [self.v_containerRanking removeObserver:self forKeyPath:@"frame"];
    [self.v_containerRanking removeObserver:self forKeyPath:@"center"];
}

#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.v_containerRanking && ([keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"center"]))
    {
        CGFloat percentageMovingOn = floor(((self.v_containerRanking.frame.origin.y - ([self navigationBarOffset] + 150)) * 100) / (maxAllowedCenterYCoord - (minAllowedCenterYCoord + 150)));

        if (percentageMovingOn > 50)
            percentageMovingOn = ceil(percentageMovingOn);
        self.v_containerQuestions.alpha = percentageMovingOn/100;
    }
}

#pragma Profile View Sliding with UIDynamics
-(void)setUpAnimatorAndBehaviors
{
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    CGRect frameProfileView = self.v_containerRanking.frame;

    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.v_containerRanking]];
    gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.v_containerRanking]];
    dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.v_containerRanking]];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.v_containerRanking] mode:UIPushBehaviorModeContinuous];

    [collisionBehavior addBoundaryWithIdentifier:@"top"
                                       fromPoint:CGPointMake(-10, [self navigationBarOffset])
                                         toPoint:CGPointMake(frameProfileView.size.width + 20, [self navigationBarOffset])];

    [collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                       fromPoint:CGPointMake(-10, self.view.frame.size.height + frameProfileView.size.height - (self.view.frame.size.height - frameProfileView.origin.y) + 1 - 50)
                                         toPoint:CGPointMake(self.view.frame.size.width + 20, self.view.frame.size.height + frameProfileView.size.height - (self.view.frame.size.height - frameProfileView.origin.y) + 1 - 50)];

    [collisionBehavior setCollisionMode:UICollisionBehaviorModeBoundaries];
    collisionBehavior.collisionDelegate = self;
    [gravityBehavior setGravityDirection:CGVectorMake(0, 0)];

    // dynamic item
    [dynamicItemBehavior setElasticity: 0.25];   // for bouncing off the boundaries

    [dynamicAnimator addBehavior:collisionBehavior];
    [dynamicAnimator addBehavior:gravityBehavior];
    [dynamicAnimator addBehavior:pushBehavior];
    [dynamicAnimator addBehavior:dynamicItemBehavior];
}

#pragma GestureRecognizers
-(void)setUpGestureRecognizers
{
    minAllowedCenterYCoord = [self navigationBarOffset];
    maxAllowedCenterYCoord = self.view.frame.size.height - 150;

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap:)];

    [self.v_panGesture setUserInteractionEnabled:YES];
    [self.v_panGesture addGestureRecognizer:panGestureRecognizer];
    [self.v_panGesture addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark PanGesture Selector
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    [self handleArrowImage];

    CGPoint translation = [gesture translationInView:gesture.view];
    CGFloat yVelocity = [gesture velocityInView:gesture.view].y;

    [self.v_containerRanking setFrame:CGRectMake(self.v_containerRanking.frame.origin.x, self.v_panGesture.frame.origin.y, self.v_containerRanking.frame.size.width, self.v_containerRanking.frame.size.height)];

    if (gesture.view.frame.origin.y + translation.y <= minAllowedCenterYCoord)
    {
        [self.v_containerRanking setFrame:CGRectMake(self.v_containerRanking.frame.origin.x, minAllowedCenterYCoord, self.v_containerRanking.frame.size.width, self.v_containerRanking.frame.size.height)];
        [gesture.view setFrame:CGRectMake(gesture.view.frame.origin.x, self.v_containerRanking.frame.origin.y, gesture.view.frame.size.width, gesture.view.frame.size.height)];
        return ;
    }
    if (gesture.view.frame.origin.y + translation.y >= maxAllowedCenterYCoord)
    {
        [self.v_containerRanking setFrame:CGRectMake(self.v_containerRanking.frame.origin.x, maxAllowedCenterYCoord, self.v_containerRanking.frame.size.width, self.v_containerRanking.frame.size.height)];
        [gesture.view setFrame:CGRectMake(gesture.view.frame.origin.x, self.v_containerRanking.frame.origin.y, gesture.view.frame.size.width, gesture.view.frame.size.height)];
        return;
    }

    gesture.view.center = CGPointMake(gesture.view.center.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];

    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [dynamicAnimator updateItemUsingCurrentState:self.v_containerRanking];

        if (yVelocity < -500.0)
        {
            NSLog(@"First");

            [gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            //            [_dynamicItemBehavior setElasticity:0.1];
            [pushBehavior setPushDirection:CGVectorMake(0,/* [gesture velocityInView:gesture.view].y */ -500)];
        }
        else if (yVelocity >= -500.0 && yVelocity < 0)
        {
            NSLog(@"Second");
            [gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            //            [_dynamicItemBehavior setElasticity:0.1];
            [pushBehavior setPushDirection:CGVectorMake(0, -500.0)];
        }
        else if (yVelocity >= 0 && yVelocity < 500.0)
        {
            NSLog(@"Third");
            [gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            //            [_dynamicItemBehavior setElasticity:0.1];
            [pushBehavior setPushDirection:CGVectorMake(0, 500.0)];
        }
        else
        {
            NSLog(@"Fourth");
            [gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            //            [_dynamicItemBehavior setElasticity:0.1];
            [pushBehavior setPushDirection:CGVectorMake(0, /* [gesture velocityInView:gesture.view].y */ 500)];
        }
    }
}

#pragma mark TapGesture Selector
-(void)handlTap:(UITapGestureRecognizer *)gesture
{
    [dynamicAnimator updateItemUsingCurrentState:self.v_containerRanking];

    if (self.v_containerRanking.frame.origin.y > self.view.frame.size.height / 2) // Is Down, go Up
    {
        [gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
        //            [_dynamicItemBehavior setElasticity:0.1];
        [pushBehavior setPushDirection:CGVectorMake(0, -500)];
    }
    else // Is Up, go Down
    {
        [gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
        //            [_dynamicItemBehavior setElasticity:0.1];
        [pushBehavior setPushDirection:CGVectorMake(0, 500.0)];
    }
}

#pragma UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    [gravityBehavior setGravityDirection:CGVectorMake(0, 0)];
    [self.v_panGesture setFrame:CGRectMake(self.v_containerRanking.frame.origin.x, self.v_containerRanking.frame.origin.y, self.v_containerRanking.frame.size.width, self.v_panGesture.frame.size.height)];
    [self handleArrowImage];
}

-(void)handleArrowImage
{
    UIImage *pictureForArrow = nil;
    if (self.v_containerRanking.frame.origin.y < self.view.frame.size.height / 2) {
        pictureForArrow = [UIImage imageNamed:@"profile_arrow_drag_down_indicator"];
    } else {
        pictureForArrow = [UIImage imageNamed:@"profile_arrow_drag_up_indicator"];
    }

    [UIView animateWithDuration:0.2 animations:^{
        [self.iv_arrowRankingDragging setImage:pictureForArrow];
    }];
}

@end
