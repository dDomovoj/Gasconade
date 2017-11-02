//
//  GCConnectViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCMasterViewController.h"

@interface GCConnectViewController : GCMasterViewController<UIAlertViewDelegate>
@property (assign) BOOL skipAuthentification;

-(void)loadData;
-(void)runAuthentificationProcess;

@end
