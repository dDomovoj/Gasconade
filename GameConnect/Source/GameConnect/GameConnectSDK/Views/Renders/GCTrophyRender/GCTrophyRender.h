//
//  GCTrophyRender.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 10/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRenderGG.h"
#import "UIImageViewJA.h"
#import "GCView.h"
#import "GCMasterCollectionViewCell.h"

@interface GCTrophyRender : GCMasterCollectionViewCell <IRenderGG>

@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet GCView *v_backgroundTrophyImage;

@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_trophy;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_description;

@end
