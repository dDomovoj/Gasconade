//
//  GCAPPLeaguesViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCLeaguesViewController.h"

@interface GCAPPLeaguesViewController : GCAPPMasterViewController
{
    GCLeaguesViewController *leagues;
}
@property (weak, nonatomic) IBOutlet UIView *v_containerLeaguesList;

@end
