//
//  GCAPPLoadingViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 15/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCLoadingViewController.h"

@interface GCAPPLoadingViewController : GCAPPMasterViewController
{
    GCLoadingViewController *loading;
}
@property (weak, nonatomic) IBOutlet UIView *v_containerLoading;

-(void)startLoading;
-(void)endLoading;
-(void)makeCheck;
-(void)setLoadingData:(NSDictionary *)userInfo;

@end
