//
//  GCButtonCrell.h
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRenderGG.h"

@interface GCAPPButtonCell : UICollectionViewCell <IRenderGG>

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@end


