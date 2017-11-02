//
//  GCAppSponsorsViewController.h
//  PSG_Stadium
//
//  Created by Sergey Dikovitsky on 10/18/16.
//  Copyright © 2016 Netcosports. All rights reserved.
//

#import "GCAPPMasterViewController.h"

@interface GCAppSponsorsViewController : GCAPPMasterViewController

@property (nonatomic, copy) void (^openParnersLink)(NSString *URLString);

- (void)presentOnViewController:(UIViewController *)viewController;

@end
