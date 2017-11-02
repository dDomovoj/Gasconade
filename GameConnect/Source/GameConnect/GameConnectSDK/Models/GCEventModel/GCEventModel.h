//
//  GCEventModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCExternalContent.h"
#import "GCRankingModel.h"

typedef enum
{
  eGCEventStatusUpComing,
  eGCEventStatusInProgress,
  eGCEventStatusFinished,
  eGCEventStatusUnknown,
    
} eGCEventStatus;

@interface GCEventModel : GCModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *competition_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *picture_url;
@property (nonatomic, strong) NSString *channel_to_listen_to;

@property (nonatomic, strong) NSString *provider_id;
@property (nonatomic, strong) NSString *provider_name;

@property (nonatomic) NSDate *start_date;
@property (nonatomic) NSDate *end_date;

@property (nonatomic) eGCEventStatus status;
@property (nonatomic, strong) GCExternalContent *gameContent;

/**
 *  Only used for past events reguarding a specific
 *  user (his rank are included in the event json object)
 */
@property (nonatomic) GCRankingModel *rank;

-(BOOL) isItContainedInArray:(NSArray *)arrayOfEvents;
+(NSArray *) sortEventsByStartDate:(NSArray *)events;

@end
