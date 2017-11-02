//
//  GCFayeWorker.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 07/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCFayeWorker.h"
#import "NsSnRequester.h"
#import "NsSnConfManager.h"
//#import "GCLoggerManager.h"
#import "GCProcessPushManager.h"
#import "GCConfManager.h"

@interface GCFayeWorker()
{
    FayeClient *fayeClient;
    
    // Credentials auth
    NSString *credentialsAppId;
    NSString *credentialsKey;
    
    // Historic of channels before & after credentials retrieving
    NSMutableArray *queueOfChannelsToListenTo;
    NSMutableArray *channelsListenedTo;
    
    // Automatic reconnection
    NSTimer *timerBeforeAutomaticReconnection;
    BOOL hasRequestedDisconnection;
}
@end

@implementation GCFayeWorker

+(GCFayeWorker*)getInstance
{
    static GCFayeWorker *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[GCFayeWorker alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void) initialize
{
    hasRequestedDisconnection = NO;
    credentialsAppId = nil;
    credentialsKey = nil;
    queueOfChannelsToListenTo = [NSMutableArray new];
    channelsListenedTo = [NSMutableArray new];
    
    __weak GCFayeWorker *weak_self = self;
    [self retrieveCredentialsWithCallback:^(BOOL ok)
    {
        if (ok)
        {
            for (NSString *channel in queueOfChannelsToListenTo)
                [weak_self startClientOnChannel:SWF(@"/%@/%@%@", credentialsAppId, credentialsKey, channel)];
            [queueOfChannelsToListenTo removeAllObjects];
        }
    }];
}

-(BOOL) hasCredentials
{
    if (credentialsAppId && [credentialsAppId length] > 0 && credentialsKey && [credentialsKey length] > 0)
        return YES;
    else
        return NO;
}

-(void) runFayeForGamer:(GCGamerModel *)gamer
{
    if (!gamer || !gamer._id)
    {
        //GCLog(@"Gamer doesn't exist, cannont create its channel");
        return ;
    }
    
    NSString *gamerChannel = SWF([GCConfManager getURL:GCURLChannelUser], gamer._id);
    if ([self hasCredentials])
        [self startClientOnChannel:SWF(@"/%@/%@%@", credentialsAppId, credentialsKey, gamerChannel)];
    else
        [queueOfChannelsToListenTo addObject:gamerChannel];
}

-(void) runFayeForCompetitions:(NSArray *)competitions
{
    for (id objectCompetition in competitions)
        [self runFayeForEventsInCompetition:objectCompetition];
}

-(void) runFayeForEventsInCompetition:(GCCompetitionModel *)competition
{
    if (!competition || ![competition isKindOfClass:[GCCompetitionModel class]] || !competition.channel_to_listen_to || [competition.channel_to_listen_to length] == 0)
    {
        //GCLog(@"Channel for Competition doesn't exist");
        return ;
    }
    
    if ([self hasCredentials])
        [self startClientOnChannel:SWF(@"/%@/%@%@", credentialsAppId, credentialsKey, competition.channel_to_listen_to)];
    else
        [queueOfChannelsToListenTo addObject:competition.channel_to_listen_to];
}

-(void) runFayeForEvents:(NSArray *)events
{
    for (id objectEvent in events)
        [self runFayeForQuestionsInEvent:objectEvent];
}

-(void) runFayeForQuestionsInEvent:(GCEventModel *)event
{
    if (!event || ![event isKindOfClass:[GCEventModel class]] || !event.channel_to_listen_to || [event.channel_to_listen_to length] == 0)
    {
        //GCLog(@"Channel for Event doens't exist");
        return ;
    }
    
    if (event.status != eGCEventStatusInProgress)
    {
        //GCLog(@"Event is not in progress. No need to listen to its channel!");
        return;
    }
    
    if ([self hasCredentials])
        [self startClientOnChannel:SWF(@"/%@/%@%@", credentialsAppId, credentialsKey, event.channel_to_listen_to)];
    else
        [queueOfChannelsToListenTo addObject:event.channel_to_listen_to];
}

-(void)retrieveCredentialsWithCallback:(void(^)(BOOL ok))cb_credentials
{
    [NsSnRequester request:[[NsSnConfManager getInstance] getURL:NsSnConfigURLMessageJastAuthorized] cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        if (rep)
        {
            credentialsAppId = [rep getXpathEmptyString:@"credentials/app_id"];
            credentialsKey = [rep getXpathEmptyString:@"credentials/key"];
            
            if ([self hasCredentials])
                cb_credentials(YES);
            else
            {
                //GCLog(@"Something went wrong while retrieving credentials from : %@", [[NsSnConfManager getInstance] getURL:NsSnConfigURLMessageJastAuthorized]);
                cb_credentials(NO);
            }
        }
        else
        {
            //GCLog(@"Something went wrong while retrieving credentials from : %@", [[NsSnConfManager getInstance] getURL:NsSnConfigURLMessageJastAuthorized]);
            if (cb_credentials)
                cb_credentials(NO);
        }
    } cache:NO];
}

-(void)startClientOnChannel:(NSString *)channel
{
    if (!fayeClient)
    {
        hasRequestedDisconnection = NO;
        fayeClient = [[FayeClient alloc] initWithURLString:[GCPlatformConnection getInstance].GCFAYE_URL channel:channel];
        fayeClient.delegate = self;
        [fayeClient connectToServer];
    }
    else
    {
        if (!fayeClient.webSocketConnected && !timerBeforeAutomaticReconnection)
            [fayeClient connectToServer];
        [fayeClient subscribeToChannel:channel];
    }
}

-(void)sleep
{
    [fayeClient disconnectFromServer];
}

-(void)restart
{
//    [self tryReConnection];
}

-(void)shutdownFayeClient
{
    hasRequestedDisconnection = YES;
    [fayeClient disconnectFromServer];
    fayeClient = nil;

    [channelsListenedTo removeAllObjects];
    [queueOfChannelsToListenTo removeAllObjects];
}

-(void) stopFayeForGamer:(GCGamerModel *)gamer
{
    NSString *channelGamer = SWF(@"/gamers/%@", gamer._id);
    
    [queueOfChannelsToListenTo removeObject:channelGamer];
    if (fayeClient && fayeClient.webSocketConnected)
        [fayeClient unsubscribeFromChannel:SWF(@"/%@/%@%@", credentialsAppId, credentialsKey, channelGamer)];
    else
        [channelsListenedTo removeObject:channelGamer];
}

-(void) stopFayeForQuestionsInEvent:(GCEventModel *)event
{
    [queueOfChannelsToListenTo removeObject:event.channel_to_listen_to];
    if (fayeClient && fayeClient.webSocketConnected && [self hasCredentials])
        [fayeClient unsubscribeFromChannel:SWF(@"/%@/%@%@", credentialsAppId, credentialsKey, event.channel_to_listen_to)];
    else
        [channelsListenedTo removeObject:event.channel_to_listen_to];
}

-(void) stopFayeForEventsInCompetition:(GCCompetitionModel *)competition
{
    [queueOfChannelsToListenTo removeObject:competition.channel_to_listen_to];
    if (fayeClient && fayeClient.webSocketConnected && [self hasCredentials])
        [fayeClient unsubscribeFromChannel:SWF(@"/%@/%@%@", credentialsAppId, credentialsKey, competition.channel_to_listen_to)];
    else
        [channelsListenedTo removeObject:competition.channel_to_listen_to];
}

-(void)tryReConnection
{
    NSLog(@"[FAYE] AUTO RECONNECTION");
    
    NSArray *arrayOfListenedChannels = [channelsListenedTo copy];
    
    if (timerBeforeAutomaticReconnection)
    {
        [timerBeforeAutomaticReconnection invalidate];
        timerBeforeAutomaticReconnection = nil;
    }
    
    if ([self hasCredentials] && arrayOfListenedChannels && [arrayOfListenedChannels count] > 0)
    {
        for (NSString *channel in arrayOfListenedChannels)
            [self startClientOnChannel:channel];
    }
    else {
        //GCLog(@"No channels previously listened to!");
    }
}

#pragma mark - Faye Client Delegate
- (void)messageReceived:(NSDictionary *)messageDict channel:(NSString *)channel
{
    if (messageDict)
    {
        GCPushModel *pushModel = [GCPushModel fromJSON:messageDict];
        switch (pushModel.type)
        {
            case eGCPushTypeStartQuestion:
            {
                NSLog(@"MessageReceived START_QUESTION %@",messageDict);
                [[GCProcessPushManager sharedManager] receiveNewQuestionNotification:[GCPushQuestionModel fromJSON:messageDict]];
            } break;
                
            case eGCPushTypeEndQuestion:
            {
                NSLog(@"MessageReceived END_QUESTION %@",messageDict);
                [[GCProcessPushManager sharedManager] receiveEndQuestionNotification:[GCPushQuestionModel fromJSON:messageDict]];
            } break;
                
            case eGCPushTypeStatsQuestion:
            {
//                NSLog(@"MessageReceived STATS_QUESTION %@",messageDict);
                [[GCProcessPushManager sharedManager] receiveStatsQuestionNotification:[GCPushQuestionModel fromJSON:messageDict]];
            } break;

            case eGCPushTypeEarnedTrophy:
            {
                NSLog(@"[FAYE Message] %@", [messageDict description]);
                [[GCProcessPushManager sharedManager] receiveTrophyNotification:[GCPushTrophyModel fromJSON:messageDict]];
            } break;

            case eGCPushTypeScoreQuestion:
            {
                NSLog(@"[FAYE Message] %@", [messageDict description]);
                [[GCProcessPushManager sharedManager] receiveScoreQuestionNotification:[GCPushScoreQuestionModel fromJSON:messageDict]];
            } break;

            case eGCPushTypeRankingEvent:
            {
                NSLog(@"[FAYE Message] %@", [messageDict description]);
                [[GCProcessPushManager sharedManager] receiveRankingEventNotification:[GCPushRankingEventModel fromJSON:messageDict]];
            } break;

            case eGCPushTypeStartEvent:
            {
                NSLog(@"[FAYE Message] %@", [messageDict description]);
                [[GCProcessPushManager sharedManager] receiveNewEventNotification:[GCPushEventModel fromJSON:messageDict]];
            } break;

            case eGCPushTypeEndEvent:
            {
                NSLog(@"[FAYE Message] %@", [messageDict description]);
                [[GCProcessPushManager sharedManager] receiveEndEventNotification:[GCPushEventModel fromJSON:messageDict]];
            } break;

            default:
                //GCLog(@"Received message without TYPE through FAYE : %@", [messageDict description]);
                break;
        }
    }
}

- (void)connectedToServer
{
    //GCLog(@"[FAYE CLIENT] >>>> Connected to server");
}

- (void)disconnectedFromServer
{
    //GCLog(@"Disconnected from server");
    
    if (hasRequestedDisconnection == NO && !timerBeforeAutomaticReconnection)
    {
        //GCLog(@"Disconnection launch of timer before restarting connection");
        
        double delayBeforeReconnection = [[[GCConfManager getInstance] getValue:GCConfigValueWebsocketDelayAutoReconnection] doubleValue];
        [timerBeforeAutomaticReconnection invalidate];
        timerBeforeAutomaticReconnection = nil;
        timerBeforeAutomaticReconnection = [NSTimer scheduledTimerWithTimeInterval:delayBeforeReconnection target:self selector:@selector(tryReConnection) userInfo:nil repeats:NO];
    }
    else {
        //GCLog(@"Disconnection didn't launch timer for reco.");
    }
}

- (void)connectionFailed
{
    //GCLog(@"Connection Failed");
    
    if (hasRequestedDisconnection == NO && !timerBeforeAutomaticReconnection)
    {
        double delayBeforeReconnection = [[[GCConfManager getInstance] getValue:GCConfigValueWebsocketDelayAutoReconnection] doubleValue];
        [timerBeforeAutomaticReconnection invalidate];
        timerBeforeAutomaticReconnection = nil;
        timerBeforeAutomaticReconnection = [NSTimer scheduledTimerWithTimeInterval:delayBeforeReconnection target:self selector:@selector(tryReConnection) userInfo:nil repeats:NO];
    }
}

- (void)didSubscribeToChannel:(NSString *)channel
{
    NSLog(@"[FAYE SubscribedChannel] %@", channel);
    
    if ([channelsListenedTo containsObject:channel])
        [channelsListenedTo removeObject:channel];
    [channelsListenedTo addObject:channel];
}

- (void)didUnsubscribeFromChannel:(NSString *)channel
{
    //GCLog(@"didUnsubscribeFromChannel %@", channel);
    [channelsListenedTo removeObject:channel];
}

- (void)subscriptionFailedWithError:(NSString *)error
{
    //GCLog(@"Subscription did fail: %@", error);
}

- (void)fayeClientError:(NSError *)error
{
    //GCLog(@"fayeClientError %@", error);
}

/*
 ** To Do implement these or Faye won't work => see FayClient pipeThroughExtensions:inDirection:withCallback
 */

//- (void)fayeClientWillReceiveMessage:(NSDictionary *)messageDict withCallback:(FayeClientMessageHandler)callback
//{
//    NSLog(@"fayeClientWillReceiveMessage %@", [messageDict description]);
//}
//
//- (void)fayeClientWillSendMessage:(NSDictionary *)messageDict withCallback:(FayeClientMessageHandler)callback
//{
//    NSLog(@"fayeClientWillSendMessage %@", [messageDict description]);
//}

@end
