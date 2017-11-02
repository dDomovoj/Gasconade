//
//  GCEventsViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/26/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCEventsViewController.h"
#import "DefaultCellRenderGG.h"
#import "WCDynamicFlowLayout.h"
#import "GCAPPDataEvent.h"
#import "GCProcessEventManager.h"
#import "GCEventManager.h"
#import "GCFayeWorker.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCEventsViewController ()
{
    id<IDataGG>     dataRenderingEvent;
    int countReload;
}
@end

@implementation GCEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    countReload = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cv_events startAutoRefreshWithSeconds:[[[GCConfManager getInstance] getValue:GCConfigAutorefreshEvents] intValue]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cv_events endAutoRefresh];
}

-(void)loadData
{
    __weak GCEventsViewController *weak_self = self;
    
    if (!self.competitionModel)
    {
        [self.cv_events setData:@{@"flux" : @[]}];
        DLog(@"Competition doesn't exist");
        return ;
    }
    
    if (self.competitionModel._id)
    {
        [self.cv_events beginRefreshing];
        [GCEventManager getLiveAndUpComingEventsForCompetition:self.competitionModel._id cb_response:^(NSArray *events)
         {
             if (weak_self.loadGameEvents)
                 weak_self.loadGameEvents(events, ^{
                     [weak_self loadListWithEvents:events];
                 });
             else
                 [weak_self loadListWithEvents:events];
         }];
    }
    else
    {
        [self.cv_events setData:@{@"flux" : @[]}];
        DLog(@"Competition doesn't exist ");
    }
}

-(void)loadListWithEvents:(NSArray *)events
{
    if (events)
        [self.cv_events setData:@{@"flux" : events}];
    [self.cv_events endRefreshing];
    [[GCFayeWorker getInstance] runFayeForEvents:events];
    countReload++;
}

-(void)initEventsListWithDefaultRender
{
    [self initEventsListWithSpecificRender:[DefaultCellRenderGG class]];
}

-(void)initEventsListWithSpecificRender:(Class<IRenderGG>)render
{
    [self.cv_events setDelegateGG:self];
    [self.cv_events setParentViewController:self];
    [self.cv_events setRender:render];
    [self.cv_events setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_events setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_events loadConfiguration];
    [self.cv_events setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_events_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
    
    __weak GCEventsViewController *weak_self = self;
    [self.cv_events setCallRefresh:^{
        [weak_self loadData];
    }];
}

-(void)initEventsListWithSpecificLinker:(id<ILinkerGG>)linker
{
    [self initDataRenderingForEvents];
    
    [self.cv_events setDelegateGG:self];
    [self.cv_events setParentViewController:self];
    [self.cv_events setItemLinker:linker];
    [self.cv_events setDataRendering:dataRenderingEvent];
    [self.cv_events setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_events loadConfiguration];
    
    __weak GCEventsViewController *weak_self = self;
    [self.cv_events setCallRefresh:^{
        [weak_self loadData];
    }];
}

-(void) initDataRenderingForEvents
{
    if (!dataRenderingEvent)
    {
        GCAPPDataEvent *dataRenderingForEvent = [[GCAPPDataEvent alloc] init];
        [dataRenderingForEvent myInit];
        [dataRenderingForEvent setParsingXpathItem:@"flux"];
        dataRenderingForEvent.noInfoAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_events_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}];
        dataRenderingForEvent.eventsHeaderAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_next_matches", nil).uppercaseString attributes:@{NSFontAttributeName: [[GCFontManager getInstance] alternateFontWithSize:27], NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}];
        dataRenderingEvent = dataRenderingForEvent;
    }
}

-(void) addCustomDataAfterEvents:(NSArray *)customData
{
    [self initDataRenderingForEvents];
    if ([dataRenderingEvent isKindOfClass:[GCAPPDataEvent class]])
    {
        GCAPPDataEvent *dataRendering = dataRenderingEvent;
        [dataRendering addCustomData:customData inSection:0];
    }
}

-(void) updateNewEvent:(GCEventModel *)newEvent
{
    if ([newEvent.competition_id isEqualToString:self.competitionModel._id])
    {
        // TODO: Insert new event
        [self loadData];
    }
}

-(void) updateEndEvent:(GCEventModel *)endEvent
{
    if ([endEvent.competition_id isEqualToString:self.competitionModel._id])
    {
        // TODO: Delete end event
        [self loadData];
    }
}

#pragma UICollectionViewGGDelegate
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView
{
    [[GCProcessEventManager sharedManager] selectItemInEventsList:dataElement atIndexPath:indexPath fromViewController:self];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


