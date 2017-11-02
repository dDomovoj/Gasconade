//
//  GCSoccerEventHeader.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 13/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "NSTimeManager.h"
#import "GCAPPSoccerEventHeader.h"
#import "GCAPPTeamMediaManager.h"
#import "GSMMatchModel.h"

#define SCORE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:1]
#define TEAMS_LB [UIColor colorWithRGBString:@"ffffffff" alpha:1]
#define TIME_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.5f]

@interface GCAPPSoccerEventHeader()
{
    NSTimer *timerReloadSoccerData;
    GCEventModel *eventModel;
}
@end

@implementation GCAPPSoccerEventHeader

-(void)myInit
{
    // Colors
    [self.lb_teamLeft setTextColor:TEAMS_LB];
    [self.lb_teamRight setTextColor:TEAMS_LB];
    [self.lb_score setTextColor:SCORE_LB];
    [self.lb_time setTextColor:TIME_LB];
    [self.lb_penalty setTextColor:SCORE_LB];
    
    // Fonts
    [self.lb_teamLeft setFont:CONFFONTREGULARSIZE(17)];
    [self.lb_teamRight setFont:CONFFONTREGULARSIZE(17)];
    [self.lb_score setFont:CONFFONTBOLDSIZE(18)];
    [self.lb_time setFont:CONFFONTSIZE(13)];
    [self.lb_penalty setFont:CONFFONTSIZE(13)];
}

-(void) updateExternalContentInfo:(GCExternalContent *)externalContentModel
{
    GSMMatchModel *elt = (GSMMatchModel *)externalContentModel;
    
    if (!externalContentModel || ![externalContentModel isKindOfClass:[GSMMatchModel class]])
        return;
    //    first_init = YES;
    //    self.match = elt;
    
    [self.lb_teamLeft setText:elt.Team_1.team_short_name];
    [self.lb_teamRight setText:elt.Team_2.team_short_name];
    
    NSString *iv_teamLeftUrl = elt.Team_1.team_image_url;
    [self.iv_teamLeft loadImageFromURL:iv_teamLeftUrl ttl:60*60*6];
    
    NSString *iv_teamRightUrl = elt.Team_2.team_image_url;
    [self.iv_teamRight loadImageFromURL:iv_teamRightUrl ttl:60*60*6];
    
    
    // Live OR Fulltime
    self.lb_score.text = @"-";
    if (elt.match_status == GSMMatchModelMatchStatusPlaying || elt.match_status == GSMMatchModelMatchStatusPlayed)
        self.lb_score.text = [NSString stringWithFormat:@"%@ - %@", elt.match_full_score_t1, elt.match_full_score_t2];
    
    self.lb_penalty.text = @"";
    if (elt.match_penalty_t1 && elt.match_penalty_t2)
        self.lb_penalty.text = [NSString stringWithFormat:@"(%@ - %@)", elt.match_penalty_t1, elt.match_penalty_t2];
    
    // Live
    if (elt.match_status == GSMMatchModelMatchStatusPlaying)
    {
        if (elt.match_period == GSMMatchModelMatchPeriodHalfTime || elt.match_period == GSMMatchModelMatchPeriodExtraBreak)
        {
            [self.lb_time setFont:CONFFONTSIZE(13)];
            [self.lb_time setText:NSLocalizedString(@"soccer_half_time", @"")];
        }
        else if (elt.match_period == GSMMatchModelMatchPeriodPenaltyShootout)
        {
            [self.lb_time setFont:CONFFONTSIZE(13)];
            [self.lb_time setText:NSLocalizedString(@"soccer_penalty_shootout", @"")];
        }
        else
        {
            NSString *strDate = [NSString stringWithFormat:@"%@ - %@'", NSLocalizedString(@"soccer_status_live", @""), elt.match_minutes];
            if (elt.match_minutes_extra)
                strDate = [NSMutableString stringWithFormat:@"%@ +%@'", strDate, elt.match_minutes_extra];
            NSMutableAttributedString *mutableDate = [[NSMutableAttributedString alloc] initWithString:strDate];
            [mutableDate addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(13)} range:NSMakeRange(0, [NSLocalizedString(@"soccer_status_live", @"") length])];
            [mutableDate addAttributes:@{NSFontAttributeName:CONFFONTSIZE(13)} range:NSMakeRange([NSLocalizedString(@"soccer_status_live", @"") length], [strDate length] - [NSLocalizedString(@"soccer_status_live", @"") length])];
            
            self.lb_time.attributedText = mutableDate;
        }
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *localeId = [[NSLocale currentLocale] localeIdentifier];
        
        if ([localeId hasSubstring:@"fr"] || [localeId hasSubstring:@"pt"] || [localeId hasSubstring:@"ja"])
            [df setDateFormat:@"EEE, dd MMMM"];
        else
            [df setDateFormat:@"EEE, MMMM dd"];
        
        NSString *strDate = [df stringFromDate:elt.match_datetime_utc_real ? elt.match_datetime_utc_real : elt.match_eventday_real];
        
        NSString *strHour = @"";
        if (elt.match_datetime_utc_real)
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            if ([localeId hasSubstring:@"fr"])
                [df setDateFormat:@"HH'h'mm"];
            else
                [df setDateFormat:@"HH':'mm"];
            strHour = [df stringFromDate:elt.match_datetime_utc_real];
        }
        
        if (elt.match_status == GSMMatchModelMatchStatusCanceled)
            strHour = NSLocalizedString(@"soccer_status_canceled", @"");
        
        else if (elt.match_status == GSMMatchModelMatchStatusPostponned)
            strHour = NSLocalizedString(@"soccer_status_reported", @"");
        
        if ([strHour length] > 0)
            self.lb_time.text = [NSString stringWithFormat:@"%@\n%@", strDate, strHour];
        else
        {
            [df setDateFormat:@"dd"];
            NSString *dayDate = [df stringFromDate:elt.match_datetime_utc_real ? elt.match_datetime_utc_real : elt.match_eventday_real];
            if (![localeId hasSubstring:@"fr"] && ![localeId hasSubstring:@"pt"] && ![localeId hasSubstring:@"ja"])
                strDate = SWF(@"%@%@", strDate, [GCConfManager getSuffixPosition:dayDate]);
            self.lb_time.text = strDate;
        }
    }
}

-(void) updateEventInfo:(GCEventModel *)event
{
    eventModel = event;
    if (eventModel && [eventModel isKindOfClass:[GCEventModel class]])
    {
        // Game
        [self updateExternalContentInfo:eventModel.gameContent];

        if (timerReloadSoccerData)
            [timerReloadSoccerData invalidate];
        
        timerReloadSoccerData = nil;
        timerReloadSoccerData = [NSTimer scheduledTimerWithTimeInterval:[[[GCConfManager getInstance] getValue:GCConfigAutorefreshEvents] intValue] target:self selector:@selector(timerReloadFired) userInfo:nil repeats:NO];
    }
}

-(void)timerReloadFired
{
    if (self.loadGameEvent)
    {
        __weak GCAPPSoccerEventHeader *weak_self = self;
        self.loadGameEvent(eventModel, ^() {
            [weak_self updateEventInfo:eventModel];
        });
    }
}

@end
