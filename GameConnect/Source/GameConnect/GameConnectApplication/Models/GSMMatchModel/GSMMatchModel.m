//
//  FFFmodel.h
//  FIFA_WC14
//
//  Created by Quimoune NetcoSports on 21/10/13.
//  Copyright (c) 2013 Netco Sports. All rights reserved.
//

#import "GSMMatchModel.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"

@implementation GSMMatchModel


/*
 "a1_has_pic" = 1;
 "b1_has_pic" = 0;
 cid = 58;
 "comp_name" = "World Cup";
 "datetime_utc" = 1402858800;
 eid = 110575;
 "event_period" = "<null>";
 eventday = 1402790400;
 "full_score_a" = "<null>";
 "full_score_b" = "<null>";
 gameweek = 1;
 "is_live" = 0;
 minutes = "<null>";
 "minutes_extra" = "<null>";
 "part_a1_abbrev_name" = "<null>";
 "part_a1_id" = 371;
 "part_a1_name" = France;
 "part_b1_abbrev_name" = "<null>";
 "part_b1_id" = 1920;
 "part_b1_name" = Honduras;
 "place_area_name" = "<null>";
 "place_city_name" = "<null>";
 "place_id" = "<null>";
 "place_name" = "<null>";
 "ps_a" = "<null>";
 "ps_b" = "<null>";
 "season_name" = "2014 Brazil";
 status = 1;
 "winner_id" = "<null>";
 "winner_status" = "<null>";
 
 */

+ (GSMMatchModel *)fromPSGJSON:(NSDictionary *)json
{
    GSMMatchModel *model = [GSMMatchModel new];

    if (json && [json isKindOfClass:[NSDictionary class]]){
        if ([model.match_id length] == 0) {
            model.match_id = [json getXpathEmptyString:@"opta_id"];

        }

        NSDictionary *team1 = @{
                                @"team_id": [json getXpathEmptyString:@"away_team_id"],
                                @"team_name": [json getXpathEmptyString:@"away_team_name"]
                                };
        NSDictionary *team2 = @{
                                @"team_id": [json getXpathEmptyString:@"home_team_id"],
                                @"team_name": [json getXpathEmptyString:@"home_team_name"]
                                };
        model.Team_1 = [GSMTeamModel fromJSON:team1];
        model.Team_2 = [GSMTeamModel fromJSON:team2];
        
        model.match_full_score_t1 = SWF(@"%d", [json getXpathInteger:@"home_team_score"]);
        model.match_full_score_t2 = SWF(@"%d", [json getXpathInteger:@"away_team_score"]);
        model.match_status = [self PSGMatchStatus:[json getXpathEmptyString:@"status"]];
        model.match_datetime_utc_real = [NSDate dateWithTimeIntervalSince1970:[[json getXpath:@"date" type:[NSNumber class] def:@0] longLongValue] / 1000];
    }

    return model;
}

+ (GSMMatchModel *) fromJSON:(NSDictionary *)dic{
    GSMMatchModel *model = [GSMMatchModel new];
    
    if (dic && [dic isKindOfClass:[NSDictionary class]]){
//        NSLog(@"GSMMatchModel : %@", [dic description]);
        
        model.match_id = [dic getXpathEmptyString:@"id"];
        if ([model.match_id length] == 0){
            model.match_id = [dic getXpathEmptyString:@"eid"];
        }
        model.match_comp_id = [dic getXpathEmptyString:@"cid"];
        model.match_minutes = [dic getXpathEmptyString:@"minutes"];
        model.match_minutes_extra = [dic getXpathNilString:@"minutes_extra"];
        model.match_gameweek = [dic getXpathEmptyString:@"gameweek"];
        model.match_groupname = [dic getXpathEmptyString:@"grp_name"];
        model.match_roundname = [dic getXpathEmptyString:@"rnd_name"];
        model.match_full_score_t1 = [dic getXpathEmptyString:@"full_score_a"];
        model.match_full_score_t2 = [dic getXpathEmptyString:@"full_score_b"];
        model.match_penalty_t1 = [dic getXpathNilString:@"ps_a"];
        if (!model.match_penalty_t1){
            model.match_penalty_t1 = [dic getXpathNilString:@"penshoot_score_a"];
        }
        model.match_penalty_t2 = [dic getXpathNilString:@"ps_b"];
        if (!model.match_penalty_t2){
            model.match_penalty_t2 = [dic getXpathNilString:@"penshoot_score_b"];
        }
        model.match_winner_id = [dic getXpathEmptyString:@"winner_id"];
        
        model.match_comp_name = [dic getXpathEmptyString:@"comp_name"];
        model.match_place_name = [dic getXpathEmptyString:@"place_name"];
        model.match_place_area = [dic getXpathEmptyString:@"place_area_name"];
        model.match_place_city = [dic getXpathEmptyString:@"place_city_name"];
        model.match_season = [dic getXpathEmptyString:@"season_name"];
        
        model.match_eventday_timestamp = [[dic getXpathEmptyString:@"eventday"] doubleValue];
        model.match_datetime_utc_timestamp = [[dic getXpathEmptyString:@"datetime_utc"] doubleValue];
        
        model.match_eventday_real = nil;
        if (model.match_eventday_timestamp != 0.0){
            model.match_eventday_real = [[NSDate alloc] initWithTimeIntervalSince1970:model.match_eventday_timestamp];
        }
        
        model.match_datetime_utc_real = nil;
        if (model.match_datetime_utc_timestamp != 0.0){
            model.match_datetime_utc_real = [[NSDate alloc] initWithTimeIntervalSince1970:model.match_datetime_utc_timestamp];
        }
        
        model.match_is_lineups = [dic getXpathInteger:@"lineup"] == 1 ? YES : NO;
        
        NSString *status = [dic getXpathEmptyString:@"fk_status_id"];
        if ([status length] == 0){
            status = [dic getXpathEmptyString:@"status"];
        }
        model.match_status = [GSMMatchModel getMatchStatus:status];
        model.match_period = [GSMMatchModel getMatchPeriod:[dic getXpathEmptyString:@"event_period"]];

        NSDictionary *dicTeam1 = @{
                                   @"team_id": [dic getXpathEmptyString:@"part_a1_id"],
                                   @"team_name": [dic getXpathEmptyString:@"part_a1_name"],
                                   @"abbrev_name": [dic getXpathEmptyString:@"part_a1_abbrev_name"],
                                   @"has_photo": [dic getXpathIntegerToString:@"a1_has_pic"],
                                   };
        NSDictionary *dicTeam2 = @{
                                   @"team_id": [dic getXpathEmptyString:@"part_b1_id"],
                                   @"team_name": [dic getXpathEmptyString:@"part_b1_name"],
                                   @"abbrev_name": [dic getXpathEmptyString:@"part_b1_abbrev_name"],
                                   @"has_photo": [dic getXpathIntegerToString:@"b1_has_pic"],
                                   };
        model.Team_1 = [GSMTeamModel fromJSON:dicTeam1];
        model.Team_2 = [GSMTeamModel fromJSON:dicTeam2];
    }
    return model;
}

+(NSArray *)fromJSONArray:(NSArray*)data
{
    if (data && [data isKindOfClass:[NSArray class]])
    {
        __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[data count]];
        [data each:^(NSInteger index, id elt, BOOL last){
            GSMMatchModel *model = [GSMMatchModel fromPSGJSON:elt];
            [ret addObject:model];
        }];
        return ret;
    }
    else
    {
        return @[];
    }
}


+(GSMMatchModelMatchStatus)getMatchStatus:(NSString *)match_status{
    // 1 => fixture / 2 => played / 3 => postponned / 4 => suspended / 5 => cancelled / 6 => playing

    if ([match_status isEqualToString:@"1"]){
        return GSMMatchModelMatchStatusFixture;
    }
    else if ([match_status isEqualToString:@"2"]){
        return GSMMatchModelMatchStatusPlayed;
    }
    else if ([match_status isEqualToString:@"3"]){
        return GSMMatchModelMatchStatusPostponned;
    }
    else if ([match_status isEqualToString:@"4"]){
        return GSMMatchModelMatchStatusSuspended;
    }
    else if ([match_status isEqualToString:@"5"]){
        return GSMMatchModelMatchStatusCanceled;
    }
    else if ([match_status isEqualToString:@"6"]){
        return GSMMatchModelMatchStatusPlaying;
    }
    else {
        return GSMMatchModelMatchStatusNone;
    }
}

+ (GSMMatchModelMatchStatus)PSGMatchStatus:(NSString *)statusString
{
    NSString *status = [statusString lowercaseString];

    if ([status isEqualToString:@"finished"]) {
        return GSMMatchModelMatchStatusPlayed;
    } else if ([status isEqualToString:@"prematch"]) {
        return GSMMatchModelMatchStatusFixture;
    } else if ([status isEqualToString:@"live"] || [status isEqualToString:@"halftime"]) {
        return GSMMatchModelMatchStatusPlaying;
    } else if ([status isEqualToString:@"abandoned"] || [status isEqualToString:@"cancelled"]) {
        return GSMMatchModelMatchStatusCanceled;
    } else if ([status isEqualToString:@"postponed"]) {
        return GSMMatchModelMatchStatusPostponned;
    } else {
        return GSMMatchModelMatchStatusFixture;
    }

}

+(GSMMatchModelMatchPeriod)getMatchPeriod:(NSString *)match_period{
//    1H=1st half / 2H=2nd half / HT=Halftime / E1=Extratime 1st half / E2=Extratime 2nd half / EH=Extratime break / PS=Penalty shootout / FT=Fulltime
    if ([match_period isEqualToString:@"1H"]){
        return GSMMatchModelMatchPeriodFirstHalf;
    }
    else if ([match_period isEqualToString:@"2H"]){
        return GSMMatchModelMatchPeriodSecondHalf;
    }
    else if ([match_period isEqualToString:@"HT"]){
        return GSMMatchModelMatchPeriodHalfTime;
    }
    else if ([match_period isEqualToString:@"E1"]){
        return GSMMatchModelMatchPeriodExtraFirstHalf;
    }
    else if ([match_period isEqualToString:@"E2"]){
        return GSMMatchModelMatchPeriodExtraSecondHalf;
    }
    else if ([match_period isEqualToString:@"EH"]){
        return GSMMatchModelMatchPeriodExtraBreak;
    }
    else if ([match_period isEqualToString:@"PS"]){
        return GSMMatchModelMatchPeriodPenaltyShootout;
    }
    else if ([match_period isEqualToString:@"FT"]){
        return GSMMatchModelMatchPeriodFulltime;
    }
    else {
        return GSMMatchModelMatchPeriodNone;
    }
}

@end
