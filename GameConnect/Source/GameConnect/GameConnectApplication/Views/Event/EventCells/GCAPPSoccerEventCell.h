//
//  GCFootballEventCell.h
//  GameConnectV2
//
//  Created by Guilaume Derivery on 28/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRenderGG.h"
#import "IExternalGameEvent.h"
#import "UIImageViewJA.h"
#import "MatchBoxSimpleCollectionViewCell.h"

@interface GCAPPSoccerEventCell : MatchBoxSimpleCollectionViewCell <IRenderGG, IGCExternalGameEvent>

@end
