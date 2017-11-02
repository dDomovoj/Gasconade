//
//  GCCompetitionModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCCompetitionModel.h"
#import "GCConfManager.h"

@implementation GCCompetitionModel

+(id) fromJSON:(NSDictionary*)data
{
    GCCompetitionModel *competition = [[GCCompetitionModel alloc] init];
    
    if (data)
    {
        competition._id = [data getXpathEmptyString:@"id"];
        competition.name = [data getXpathEmptyString:@"name"];
        competition.desc = [data getXpathEmptyString:@"description"];
        competition.picture_url = [data getXpathEmptyString:@"picture_url"];
        competition.channel_to_listen_to = [data getXpathEmptyString:@"channel"];
        competition.start_date = [GCConfManager ISO8601StringToNSDate:[data getXpathEmptyString:@"start_date"]];
        competition.end_date = [GCConfManager ISO8601StringToNSDate:[data getXpathEmptyString:@"end_date"]];
    }
    return competition;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCCompetitionModel fromJSON:elt]];
    }];
    return ret;
}

+(NSArray *) sortCompetitionsByStartDate:(NSArray *)competitions
{
    if (!competitions || [competitions count] == 0)
    {
        DLog(@"Events cannot be sorted, they don't exist !");
        return @[];
    }
    
    return [competitions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                if ((obj1 && [obj1 isKindOfClass:[GCCompetitionModel class]]) &&
                    (obj2 && [obj2 isKindOfClass:[GCCompetitionModel class]]))
                {
                    GCCompetitionModel *competition1 = (GCCompetitionModel *)obj1;
                    GCCompetitionModel *competition2 = (GCCompetitionModel *)obj2;
                    
                    if ([competition1.start_date timeIntervalSince1970] < [competition2.start_date timeIntervalSince1970])
                        return (NSComparisonResult)NSOrderedDescending;
                    if ([competition1.start_date timeIntervalSince1970] > [competition2.start_date timeIntervalSince1970])
                        return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
}

@end
