//
//  GCAPPExternalPopupView.h
//  TVA Sports Second Screen
//
//  Created by Guillaume on 19/08/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "GCView.h"

@interface GCAPPExternalPopupView : GCView

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_message;
@property (weak, nonatomic) IBOutlet UIButton *bt_start;

@property (copy, nonatomic) void (^callBackClickPopup)(void);

-(void)updatePopupWithData:(NSDictionary *)data;

@end
