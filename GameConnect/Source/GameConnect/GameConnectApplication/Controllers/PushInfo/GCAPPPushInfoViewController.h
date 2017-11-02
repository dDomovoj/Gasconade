//
//  GCAPPPushInfoViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 22/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCPushInfoViewController.h"

@interface GCAPPPushInfoViewController : GCAPPMasterViewController
{
    GCPushInfoViewController *pushInfoViewController;
}
@property (weak, nonatomic) IBOutlet UIView *v_containerPushInfo;
@property (weak, nonatomic) IBOutlet UIImageView *iv_brandLogo;

-(void) addPushInfos:(NSArray *)questionsAndTrophies;
-(void) preselectItemAtIndex:(NSInteger)preselectedItemIndex;

@end
