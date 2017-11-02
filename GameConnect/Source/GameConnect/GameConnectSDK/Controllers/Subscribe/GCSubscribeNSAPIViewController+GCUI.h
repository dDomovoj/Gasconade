//
//  GCSubscribeNSAPIViewController+GCUI.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 06/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCSubscribeNSAPIViewController.h"

@interface GCSubscribeNSAPIViewController (GCUI) <UITextFieldDelegate>

-(void)initSubscribeView;
-(void)showCGU;
-(void)closeCGU;

@end
