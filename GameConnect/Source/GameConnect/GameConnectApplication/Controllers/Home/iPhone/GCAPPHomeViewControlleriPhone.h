//
//  GCHomeViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/26/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPHomeViewController.h"

@interface GCAPPHomeViewControlleriPhone : GCAPPHomeViewController<UICollisionBehaviorDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) UIView *v_panGesture;
@property (nonatomic) UIImageView *iv_arrowRankingDragging;

@end

