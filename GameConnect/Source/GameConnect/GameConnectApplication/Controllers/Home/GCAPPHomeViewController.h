//
//  GCAPPHomeViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPMasterViewController.h"
#import "GCEventsViewController.h"
#import "GCProfileViewController.h"

@interface GCAPPHomeViewController : GCAPPMasterViewController
{
    GCEventsViewController *events;
    GCProfileViewController *profile;
}
@property (weak, nonatomic) IBOutlet UIImageView *iv_brandLogo;
@property (weak, nonatomic) IBOutlet UIView *v_containerEvents;
@property (weak, nonatomic) IBOutlet UIView *v_containerProfile;

-(void) setUpEventsList;
-(void) setUpProfile;
-(void) updateWithGamer:(GCGamerModel *)gamer;

-(void)updateNewEvent:(GCEventModel *)newEvent;
-(void)updateEndEvent:(GCEventModel *)endEvent;

-(void)bindExternalGameForEvents;
-(void)bindExternalGameForPassedEvents;

@end
