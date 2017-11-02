//
//  GCEventsViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/26/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "ILinkerGG.h"
#import "IRenderGG.h"
#import "UICollectionViewGG.h"
#import "GCEventModel.h"
#import "GCCompetitionModel.h"

@interface GCEventsViewController : GCConnectViewController<UICollectionViewGGDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewGG *cv_events;
@property (strong, nonatomic) GCCompetitionModel *competitionModel;

@property (copy, nonatomic) void(^loadGameEvents)(NSArray *events, void(^)(void));

-(void) initEventsListWithDefaultRender;
-(void) initEventsListWithSpecificRender:(Class<IRenderGG>)render;
-(void) initEventsListWithSpecificLinker:(id<ILinkerGG>)linker;
-(void) addCustomDataAfterEvents:(NSArray *)customData;

-(void) updateNewEvent:(GCEventModel *)newEvent;
-(void) updateEndEvent:(GCEventModel *)newEvent;

@end
