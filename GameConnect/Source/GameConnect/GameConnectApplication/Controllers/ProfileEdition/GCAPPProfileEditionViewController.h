//
//  GCAPPProfileEditionViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCProfileEditionViewController.h"
#import "GCGamerModel.h"

@interface GCAPPProfileEditionViewController : GCAPPMasterViewController
{
    GCProfileEditionViewController *profileEditionViewController;
}

@property (strong, nonatomic) GCGamerModel *gamerModel;

@end
