//
//  GCDefaultEventCellRender.h
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILinkerGG.h"
#import "GCMasterCollectionViewCell.h"

@interface DefaultCellRenderGG : GCMasterCollectionViewCell <IRenderGG>

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@end

