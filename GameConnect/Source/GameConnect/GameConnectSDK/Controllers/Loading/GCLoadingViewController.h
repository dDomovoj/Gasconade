//
//  GCLoadingViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 15/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCMasterViewController.h"
#import "GCView.h"

@interface GCLoadingViewController : GCMasterViewController

@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet GCView *v_loader;
@property (weak, nonatomic) IBOutlet UILabel *lb_loadingText;
@property (weak, nonatomic) IBOutlet UIButton *bt_refresh;

// @property (copy, nonatomic) void(^callBackCheckDone)(BOOL isPlatformAvailable);

-(void)startLoading;
-(void)endLoading;

/**
 *  Set Loading View Comportement reguarding userInfo
 *
 *  @param userInfo custom user info with Keys :
 *  gcAccessGranted
 *  gcLoadingText
 *  gcLoadingAttributedText
 *  gcSuperText
 *  gcSuperAttributedText
 *
 */
-(void)setLoadingData:(NSDictionary *)userInfo;

-(BOOL)checkUpPlatform;

@end
