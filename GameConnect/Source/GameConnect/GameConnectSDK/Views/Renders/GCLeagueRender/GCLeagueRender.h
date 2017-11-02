//
//  GCLeagueRender.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 11/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewJA.h"
#import "GCView.h"
#import "GCMasterCollectionViewCell.h"

@interface GCLeagueRender : GCMasterCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_leagueLogo;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_numberOfMembers;
@property (weak, nonatomic) IBOutlet GCView *v_loader;
@property (weak, nonatomic) IBOutlet UIImageView *iv_arrow;

-(void) setSelected:(BOOL)selected andLoad:(BOOL)selectedCell;

@end
