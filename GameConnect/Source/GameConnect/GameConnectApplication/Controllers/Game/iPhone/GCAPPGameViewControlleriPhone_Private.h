//
//  GCAPPGameViewControlleriPhone_Private.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 13/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#ifndef GameConnectV2_GCAPPGameViewControlleriPhone_Private_h
#define GameConnectV2_GCAPPGameViewControlleriPhone_Private_h

@interface GCAPPGameViewControlleriPhone ()
{
    CGFloat minAllowedCenterYCoord;
    CGFloat maxAllowedCenterYCoord;
    UICollisionBehavior *collisionBehavior;
    UIDynamicItemBehavior *dynamicItemBehavior;
    UIGravityBehavior *gravityBehavior;
    UIDynamicAnimator *dynamicAnimator;
    UIPushBehavior *pushBehavior;
}
@end

#endif
