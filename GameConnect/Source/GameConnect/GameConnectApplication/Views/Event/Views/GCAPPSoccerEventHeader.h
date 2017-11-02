//
//  GCSoccerEventHeader.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 13/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCView.h"
#import "UIImageViewJA.h"
#import "GCEventModel.h"
#import "IExternalGameEvent.h"

@interface GCAPPSoccerEventHeader : GCView <IGCExternalGameEvent>

@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_teamLeft;
@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_teamRight;

@property (weak, nonatomic) IBOutlet UILabel *lb_teamLeft;
@property (weak, nonatomic) IBOutlet UILabel *lb_teamRight;

@property (weak, nonatomic) IBOutlet UILabel *lb_score;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_penalty;

@property (copy, nonatomic) void(^loadGameEvent)(GCEventModel *event, void(^)(void));

@end
