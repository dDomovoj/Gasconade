//
//  GCAPPHomeViewControlleriPhone+GCAPPUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPHomeViewControlleriPhone+GCAPPUI.h"
#import "GCAPPHomeViewControlleriPhone_Private.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCAPPHomeViewControlleriPhone (GCAPPUI)

-(void)setUpDynamicsForProfileView
{
    [profile.cv_playedEvents setBackgroundColor:CONFCOLORFORKEY(@"profile_bg")];
    [profile.cv_trophies setBackgroundColor:CONFCOLORFORKEY(@"profile_bg")];
    [profile.v_containerSegmentedControl setBackgroundColor:CONFCOLORFORKEY(@"profile_bg")];

    [self setUpGestureRecognizers];
    [self setUpAnimatorAndBehaviors];
    [self setUpWatchers];
}

-(void)setUpWatchers
{
    [self.v_containerProfile addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [self.v_containerProfile addObserver:self forKeyPath:@"center" options:0 context:nil];
}

-(void)stopWatchers
{
    [self.v_containerProfile removeObserver:self forKeyPath:@"frame"];
    [self.v_containerProfile removeObserver:self forKeyPath:@"center"];
}

#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.v_containerProfile && ([keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"center"]))
    {
        CGFloat percentageMovingOn = floor(((self.v_containerProfile.frame.origin.y - (self.v_containerEvents.frame.origin.y + 100)) * 100) / (maxAllowedCenterYCoord - (minAllowedCenterYCoord + 100)));

        if (percentageMovingOn > 50)
            percentageMovingOn = ceil(percentageMovingOn);
        self.v_containerEvents.alpha = percentageMovingOn/100;
    }
}


#pragma Profile View Sliding with UIDynamics
-(void)setUpAnimatorAndBehaviors
{
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    CGRect frameProfileView = self.v_containerProfile.frame;

    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.v_containerProfile]];
    gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.v_containerProfile]];
    dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.v_containerProfile]];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.v_containerProfile] mode:UIPushBehaviorModeContinuous];

    [collisionBehavior addBoundaryWithIdentifier:@"top"
                                       fromPoint:CGPointMake(-10, minAllowedCenterYCoord - 1)
                                         toPoint:CGPointMake(frameProfileView.size.width + 20, minAllowedCenterYCoord - 1)];

    [collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                       fromPoint:CGPointMake(-10, self.view.frame.size.height + frameProfileView.size.height - (self.view.frame.size.height - frameProfileView.origin.y) + 1)
                                         toPoint:CGPointMake(self.view.frame.size.width + 20, self.view.frame.size.height + frameProfileView.size.height - (self.view.frame.size.height - frameProfileView.origin.y) + 1)];

    [collisionBehavior setCollisionMode:UICollisionBehaviorModeBoundaries];
    collisionBehavior.collisionDelegate = self;
    [gravityBehavior setGravityDirection:CGVectorMake(0, 0)];

    // dynamic item
    [dynamicItemBehavior setElasticity:0.25];   // for bouncing off the boundaries

    [dynamicAnimator addBehavior:collisionBehavior];
    [dynamicAnimator addBehavior:gravityBehavior];
    [dynamicAnimator addBehavior:pushBehavior];
    [dynamicAnimator addBehavior:dynamicItemBehavior];
}

#pragma GestureRecognizers
-(void)setUpGestureRecognizers
{
    minAllowedCenterYCoord = self.v_containerEvents.frame.origin.y + 64;
    maxAllowedCenterYCoord = self.v_containerProfile.frame.origin.y;

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap:)];

	tapGestureRecognizer.delegate = self;

    [self.v_panGesture setUserInteractionEnabled:NO];
    [profile.profileHeader addGestureRecognizer:panGestureRecognizer];
    [profile.profileHeader addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([touch.view isKindOfClass:[UIImageView class]]) {
		return NO;
	}
	return YES;
}

#pragma mark PanGesture Selector
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    [self handleArrowImage];

	UIView *gestureView = self.v_panGesture;

    CGPoint translation = [gesture translationInView:gestureView];
    CGFloat yVelocity = [gesture velocityInView:gestureView].y;

    [self.v_containerProfile setFrame:CGRectMake(self.v_containerProfile.frame.origin.x, self.v_panGesture.frame.origin.y, self.v_containerProfile.frame.size.width, self.v_containerProfile.frame.size.height)];

    if (gestureView.frame.origin.y + translation.y < minAllowedCenterYCoord - 1)
    {
        [self.v_containerProfile setFrame:CGRectMake(self.v_containerProfile.frame.origin.x, minAllowedCenterYCoord, self.v_containerProfile.frame.size.width, self.v_containerProfile.frame.size.height)];
        [gestureView setFrame:CGRectMake(gestureView.frame.origin.x, self.v_containerProfile.frame.origin.y, gestureView.frame.size.width, gestureView.frame.size.height)];
        return ;
    }
    if (gestureView.frame.origin.y + translation.y > maxAllowedCenterYCoord + 1)
    {
        [self.v_containerProfile setFrame:CGRectMake(self.v_containerProfile.frame.origin.x, maxAllowedCenterYCoord, self.v_containerProfile.frame.size.width, self.v_containerProfile.frame.size.height)];
        [gestureView setFrame:CGRectMake(gestureView.frame.origin.x, self.v_containerProfile.frame.origin.y, gestureView.frame.size.width, gestureView.frame.size.height)];
        return;
    }

    gestureView.center = CGPointMake(gestureView.center.x, gestureView.center.y + translation.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:gestureView];

    if (gesture.state == UIGestureRecognizerStateEnded)
    {
//        [self.v_containerProfile setUserInteractionEnabled:NO];
        [dynamicAnimator updateItemUsingCurrentState:self.v_containerProfile];

        if (yVelocity < -500.0)
        {
            NSLog(@"First");

            [gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            //            [_dynamicItemBehavior setElasticity:0.1];
            [pushBehavior setPushDirection:CGVectorMake(0, /* [gesture velocityInView:gesture.view].y */ -500)];
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
    [dynamicAnimator updateItemUsingCurrentState:self.v_containerProfile];

    if (self.v_containerProfile.frame.origin.y > self.view.frame.size.height / 2) // Is Down, go Up
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
    [self.v_panGesture setFrame:CGRectMake(self.v_containerProfile.frame.origin.x, self.v_containerProfile.frame.origin.y, self.v_containerProfile.frame.size.width, self.v_panGesture.frame.size.height)];
    [self handleArrowImage];
}

-(void)handleArrowImage
{
    UIImage *pictureForArrow = nil;
    if (self.v_containerProfile.frame.origin.y > self.v_containerEvents.frame.origin.y + self.v_containerEvents.frame.size.height - 10) // Is Down, go Up
        pictureForArrow = [UIImage imageNamed:@"profile_arrow_drag_up_indicator"];

    else if (self.v_containerProfile.frame.origin.y < self.v_containerEvents.frame.origin.y + 10) // Is Up, go Down
        pictureForArrow = [UIImage imageNamed:@"profile_arrow_drag_down_indicator"];

    else
        pictureForArrow = [UIImage imageNamed:@"profile_arrow_dragging_indicator"];

    [UIView animateWithDuration:0.2 animations:^{
        [self.iv_arrowRankingDragging setImage:pictureForArrow];
    }];
}

@end
