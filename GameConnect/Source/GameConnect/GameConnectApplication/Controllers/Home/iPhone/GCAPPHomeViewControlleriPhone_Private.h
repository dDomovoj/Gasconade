//
//  GCAPPHomeViewControlleriPhone_Private.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 08/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#ifndef GameConnectV2_GCAPPHomeViewControlleriPhone_Private_h
#define GameConnectV2_GCAPPHomeViewControlleriPhone_Private_h

@interface GCAPPHomeViewControlleriPhone ()
{
    CGFloat minAllowedCenterYCoord;
    CGFloat maxAllowedCenterYCoord;
    UICollisionBehavior *collisionBehavior;
    UIDynamicItemBehavior *dynamicItemBehavior;
    UIGravityBehavior *gravityBehavior;
    UIPushBehavior *pushBehavior;
    UIDynamicAnimator *dynamicAnimator;
    
    UIAttachmentBehavior *attachmentBehavior;
}
@end

#endif
