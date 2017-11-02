//
//  GCProcessEventManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"
#import "GCEventsViewController.h"

@protocol GCProcessEventManagerDelegate <GCProcessManagerDelegate>
@optional
-(void) GCDidSelectEvent:(GCEventModel *)eventModel atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController;

-(void) GCDidSelecElement:(id)dataElement atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController;
@end

@interface GCProcessEventManager : GCProcessManager

@property (weak, nonatomic) id<GCProcessEventManagerDelegate> delegate;
-(void) selectItemInEventsList:(id)data atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController;

@end
