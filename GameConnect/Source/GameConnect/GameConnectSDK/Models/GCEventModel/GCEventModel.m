//
//  GCEventModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCEventModel.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"

@implementation GCEventModel

+(id) fromJSON:(NSDictionary*)data
{
    GCEventModel *event = [[GCEventModel alloc] init];

    if (data)
    {
        event._id = [data getXpathEmptyString:@"id"];
        event.competition_id = [data getXpathEmptyString:@"competition_id"];
        event.name = [data getXpathEmptyString:@"name"];
        event.desc = [data getXpathEmptyString:@"description"];
        event.picture_url = [data getXpathEmptyString:@"picture_url"];
        event.channel_to_listen_to = [data getXpathEmptyString:@"channel"];
        
        event.start_date = [GCConfManager ISO8601StringToNSDate:[data getXpathEmptyString:@"start_date"]];
        event.end_date = [GCConfManager ISO8601StringToNSDate:[data getXpathEmptyString:@"end_date"]];
        event.rank = [GCRankingModel fromJSON:[data getXpathNilDictionary:@"rank"]];
        
        event.provider_id = [data getXpathEmptyString:@"provider_id"];
        event.provider_name = [data getXpathEmptyString:@"provider_name"];
        
        NSString *stringEventStatus = [data getXpathEmptyString:@"status"];
        if ([stringEventStatus isEqualToString:@"UPCOMING"])
            event.status = eGCEventStatusUpComing;
        else if ([stringEventStatus isEqualToString:@"IN_PROGRESS"])
            event.status = eGCEventStatusInProgress;
        else if ([stringEventStatus isEqualToString:@"FINISHED"])
            event.status = eGCEventStatusFinished;
        else
            event.status = eGCEventStatusUnknown;
    }
    return event;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCEventModel fromJSON:elt]];
    }];
    return [GCEventModel sortEventsByStartDate:[ret ToUnMutable]];
}

-(BOOL) isItContainedInArray:(NSArray *)arrayOfEvents
{
    if (!arrayOfEvents)
        return NO;
        
    for (GCEventModel *event in arrayOfEvents)
    {
        if (event && [event isKindOfClass:[GCEventModel class]])
        {
            if (event._id && self._id && [event._id isEqualToString:self._id])
                return YES;
        }
    }
    return NO;
}

+(NSArray *) sortEventsByStartDate:(NSArray *)events
{
    if (!events || [events count] == 0)
    {
//        DLog(@"Events cannot be sorted, they don't exist !");
        return @[];
    }
    
    return [events sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        if ((obj1 && [obj1 isKindOfClass:[GCEventModel class]]) &&
            (obj2 && [obj2 isKindOfClass:[GCEventModel class]]))
        {
            GCEventModel *event1 = (GCEventModel *)obj1;
            GCEventModel *event2 = (GCEventModel *)obj2;
            
            if ([event1.start_date timeIntervalSince1970] < [event2.start_date timeIntervalSince1970])
                return (NSComparisonResult)NSOrderedAscending;
            
            if ([event1.start_date timeIntervalSince1970] > [event2.start_date timeIntervalSince1970])
                return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

@end
