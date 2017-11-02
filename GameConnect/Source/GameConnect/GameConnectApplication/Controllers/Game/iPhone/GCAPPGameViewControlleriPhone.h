//
//  GCGCAPPGameViewControlleriPhone.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPGameViewController.h"

@interface GCAPPGameViewControlleriPhone : GCAPPGameViewController <UICollisionBehaviorDelegate>

@property (nonatomic) UIView *v_panGesture;
@property (nonatomic) UIImageView *iv_arrowRankingDragging;
@property (weak, nonatomic) IBOutlet UIButton *sponsorsButton;

@end
