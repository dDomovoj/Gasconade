//
//  GSMMatchModel.h
//  FIFA_WC14
//
//  Created by Quimoune NetcoSports on 21/10/13.
//  Copyright (c) 2013 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSMTeamModel.h"
#import "GCExternalContent.h"

typedef enum {
    GSMMatchModelMatchStatusNone = -1,
    GSMMatchModelMatchStatusFixture,
    GSMMatchModelMatchStatusPlayed,
    GSMMatchModelMatchStatusPostponned,
    GSMMatchModelMatchStatusSuspended,
    GSMMatchModelMatchStatusCanceled,
    GSMMatchModelMatchStatusPlaying,
} GSMMatchModelMatchStatus;


typedef enum {
    GSMMatchModelMatchPeriodNone = -1,
    GSMMatchModelMatchPeriodFirstHalf,
    GSMMatchModelMatchPeriodSecondHalf,
    GSMMatchModelMatchPeriodHalfTime,
    GSMMatchModelMatchPeriodExtraFirstHalf,
    GSMMatchModelMatchPeriodExtraSecondHalf,
    GSMMatchModelMatchPeriodExtraBreak,
    GSMMatchModelMatchPeriodPenaltyShootout,
    GSMMatchModelMatchPeriodFulltime,
} GSMMatchModelMatchPeriod;


@interface GSMMatchModel : GCExternalContent


@property (strong, nonatomic) NSString *match_id;
@property (strong, nonatomic) NSString *match_comp_id;
@property (strong, nonatomic) NSString *match_minutes;
@property (strong, nonatomic) NSString *match_minutes_extra;
@property (strong, nonatomic) NSString *match_gameweek;
@property (strong, nonatomic) NSString *match_full_score_t1;
@property (strong, nonatomic) NSString *match_full_score_t2;
@property (strong, nonatomic) NSString *match_penalty_t1;
@property (strong, nonatomic) NSString *match_penalty_t2;
@property (strong, nonatomic) NSString *match_winner_id;
@property (strong, nonatomic) NSString *match_comp_name;
@property (strong, nonatomic) NSString *match_place_name;
@property (strong, nonatomic) NSString *match_place_area;
@property (strong, nonatomic) NSString *match_place_city;
@property (strong, nonatomic) NSString *match_season;
@property (strong, nonatomic) NSString *match_groupname;
@property (strong, nonatomic) NSString *match_roundname;

@property (strong, nonatomic) NSDictionary *pmu_odds;

@property (assign, nonatomic) NSTimeInterval match_eventday_timestamp;
@property (assign, nonatomic) NSTimeInterval match_datetime_utc_timestamp;
@property (strong, nonatomic) NSDate *match_eventday_real;
@property (strong, nonatomic) NSDate *match_datetime_utc_real;

@property (assign, nonatomic) BOOL match_is_lineups;

@property (assign, nonatomic) GSMMatchModelMatchStatus match_status;
@property (assign, nonatomic) GSMMatchModelMatchPeriod match_period;

@property (strong, nonatomic) GSMTeamModel *Team_1;
@property (strong, nonatomic) GSMTeamModel *Team_2;



+(GSMMatchModelMatchStatus)getMatchStatus:(NSString *)match_status;
+(GSMMatchModelMatchPeriod)getMatchPeriod:(NSString *)match_period;

+ (GSMMatchModel *)fromPSGJSON:(NSDictionary *)json;

@end
