//
//  GCFootballEventCell.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 28/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "GCAPPSoccerEventCell.h"
#import "Extends+Libs.h"
#import "GCAPPTeamMediaManager.h"
#import "NSTimeManager.h"
#import "GSMMatchModel.h"
#import "GCFontManager.h"
//#import "NSDate+NSDate_Tool.h"
//#import "PSGOneApp-Swift.h"
//@import SDWebImage;
//#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GCAPPDefines.h"

@import SDWebImage;

// Live Event
#define STATUS_EVENT_LIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:1]
#define TEAM_NAME_LIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:1]
#define SCORE_LIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:1]
#define TIME_LIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:1]

// Next Event
#define STATUS_EVENT_NOTLIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.5f]
#define TEAM_NAME_NOTLIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.5f]
#define SCORE_NOTLIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.5f]
#define TIME_NOTLIVE_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.5f]

// Backgrounds
#define STATUS_EVENT_BG [UIColor colorWithRGBString:@"ffffffff" alpha:0.2f]
#define EVENT_LIVENEXT_MATCH_BG [UIColor colorWithRGBString:@"ffffffff" alpha:0.2f]

@interface GCAPPSoccerEventCell()

@property (nonatomic) UIView *statusContainerView;
@property (nonatomic) UILabel *statusLabel;
@property (nonatomic) UILabel *timerLabel;

@end

@implementation GCAPPSoccerEventCell

- (void)constructUI
{
    [super constructUI];

    [self.topSeparator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(@8);
        make.right.equalTo(@(-8));
    }];

    self.statusContainerView = [UIView new];
    self.statusContainerView.layer.cornerRadius = 3;
    self.statusContainerView.backgroundColor = GC_RED_COLOR;
    [self.contentContainer addSubview:self.statusContainerView];
    [self.statusContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(12);
    }];

	self.statusLabel = [UILabel new];
	self.statusLabel.textColor = [UIColor whiteColor];
	self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [[GCFontManager getInstance] getFontRegularWithSize:13];

	[self.statusContainerView addSubview:self.statusLabel];

	[self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat inset = 5;
        make.edges.insets(UIEdgeInsetsMake(inset, inset, inset, inset));
	}];

    self.timerLabel = [UILabel new];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.font = [[GCFontManager getInstance] getFontRegularWithSize:13];
    [self.contentContainer addSubview:self.timerLabel];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.statusContainerView.mas_bottom).offset(8);
    }];
    self.timerLabel.hidden = YES;
}

- (NSString *)formattedTeamNameForTeam:(GSMTeamModel *)team {
#warning UARENA
//    if ([team.team_id isPSGTeamId]) {
//        NSArray<NSString *> *teamNameComponents = [team.team_name componentsSeparatedByString:@" "];
//        if (teamNameComponents.count <= 1) {
//            return team.team_name;
//        }
//
//        return [teamNameComponents componentsJoinedByString:@"\n"];
//    }
    return team.team_name;
}

- (void)updateExternalContentInfo:(GCExternalContent *)externalContentModel
{

    GSMMatchModel *elt = (GSMMatchModel *)externalContentModel;

    self.teamHomeLabel.text = nil;
    self.teamAwayLabel.text = nil;
    self.teamHomeImage.image = nil;
    self.teamAwayImage.image = nil;
    self.scoreLabel.text = nil;
    self.matchDateLabel.text = nil;
    self.matchDateTimeLabel.text = nil;

    if (!externalContentModel || ![externalContentModel isKindOfClass:[GSMMatchModel class]])
        return;

    [self.teamHomeLabel setText:[self formattedTeamNameForTeam:elt.Team_2]];
    [self.teamAwayLabel setText:[self formattedTeamNameForTeam:elt.Team_1]];

    [self.teamHomeImage sd_setImageWithURL:[NSURL URLWithString:elt.Team_2.team_image_url]];
    [self.teamAwayImage sd_setImageWithURL:[NSURL URLWithString:elt.Team_1.team_image_url]];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@   \u2014   %@", elt.match_full_score_t1, elt.match_full_score_t2];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"dd/MM/yyyy";
    self.matchDateLabel.text = [formatter stringFromDate:elt.match_datetime_utc_real];
    formatter.dateFormat = @"HH'H'mm";
    self.matchDateTimeLabel.text = [formatter stringFromDate:elt.match_datetime_utc_real];
//    self.statusContainerView.hidden = NO;
//    switch (elt.match_status) {
//        case GSMMatchModelMatchStatusPlaying:
//            self.statusLabel.text = NSLocalizedString(@"gc_live", nil).uppercaseString;
//            break;
//        case GSMMatchModelMatchStatusFixture:
//            self.statusLabel.text = NSLocalizedString(@"gc_next", nil).uppercaseString;
//            break;
//        case GSMMatchModelMatchStatusPlayed:
//            self.statusLabel.text = NSLocalizedString(@"gc_ended", nil).uppercaseString;
//            break;
//        default:
//            self.statusContainerView.hidden = YES;
//    }

//    self.penalties.text = @"";
//    if (elt.match_penalty_t1 && elt.match_penalty_t2)
//        self.lb_penalty.text = [NSString stringWithFormat:@"(%@ - %@)", elt.match_penalty_t1, elt.match_penalty_t2];

    // Live
//    if (elt.match_status == GSMMatchModelMatchStatusPlaying)
//    {
//        if (elt.match_period == GSMMatchModelMatchPeriodHalfTime || elt.match_period == GSMMatchModelMatchPeriodExtraBreak)
//        {
//            [self.lb_time setFont:CONFFONTSIZE(13)];
//            [self.lb_time setText:NSLocalizedString(@"soccer_half_time", @"")];
//        }
//        else if (elt.match_period == GSMMatchModelMatchPeriodPenaltyShootout)
//        {
//            [self.lb_time setFont:CONFFONTSIZE(13)];
//            [self.lb_time setText:NSLocalizedString(@"soccer_penalty_shootout", @"")];
//        }
//        else
//        {
//            NSString *strDate = [NSString stringWithFormat:@"%@ - %@'", NSLocalizedString(@"soccer_status_live", @""), elt.match_minutes];
//            if (elt.match_minutes_extra)
//                strDate = [NSMutableString stringWithFormat:@"%@ +%@'", strDate, elt.match_minutes_extra];
//            NSMutableAttributedString *mutableDate = [[NSMutableAttributedString alloc] initWithString:strDate];
//            [mutableDate addAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(13)} range:NSMakeRange(0, [NSLocalizedString(@"soccer_status_live", @"") length])];
//            [mutableDate addAttributes:@{NSFontAttributeName:CONFFONTSIZE(13)} range:NSMakeRange([NSLocalizedString(@"soccer_status_live", @"") length], [strDate length] - [NSLocalizedString(@"soccer_status_live", @"") length])];
//            
//            self.lb_time.attributedText = mutableDate;
//        }
//    }
//    else
//    {
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        NSString *localeId = [[NSLocale currentLocale] localeIdentifier];
//        
//        if ([localeId hasSubstring:@"fr"] || [localeId hasSubstring:@"pt"] || [localeId hasSubstring:@"ja"])
//            [df setDateFormat:@"EEE, dd MMMM"];
//        else
//            [df setDateFormat:@"EEE, MMMM dd"];
//        
//        NSString *strDate = [df stringFromDate:elt.match_datetime_utc_real ? elt.match_datetime_utc_real : elt.match_eventday_real];
//        
//        NSString *strHour = @"";
//        if (elt.match_datetime_utc_real)
//        {
//            NSDateFormatter *df = [[NSDateFormatter alloc] init];
//            if ([localeId hasSubstring:@"fr"])
//                [df setDateFormat:@"HH'h'mm"];
//            else
//                [df setDateFormat:@"HH':'mm"];
//            strHour = [df stringFromDate:elt.match_datetime_utc_real];
//        }
//        
//        if (elt.match_status == GSMMatchModelMatchStatusCanceled)
//            strHour = NSLocalizedString(@"soccer_status_canceled", @"");
//        
//        else if (elt.match_status == GSMMatchModelMatchStatusPostponned)
//            strHour = NSLocalizedString(@"soccer_status_reported", @"");
//        
//        if ([strHour length] > 0)
//            self.lb_time.text = [NSString stringWithFormat:@"%@\n%@", strDate, strHour];
//        else
//        {
//            [df setDateFormat:@"dd"];
//            NSString *dayDate = [df stringFromDate:elt.match_datetime_utc_real ? elt.match_datetime_utc_real : elt.match_eventday_real];
//            if (![localeId hasSubstring:@"fr"] && ![localeId hasSubstring:@"pt"] && ![localeId hasSubstring:@"ja"])
//                strDate = SWF(@"%@%@", strDate, [GCConfManager getSuffixPosition:dayDate]);
//            self.lb_time.text = strDate;
//        }
//    }

}

/*
 ** Event Content
 */
-(void) updateEventInfo:(GCEventModel *)eventModel
{
    UIColor *defaultStatusColor = [UIColor colorWithRGB:0x767C85];
    self.statusContainerView.hidden = NO;
    self.statusContainerView.backgroundColor = defaultStatusColor;
    switch (eventModel.status) {
        case eGCEventStatusInProgress:
            self.statusLabel.text = NSLocalizedString(@"gc_live", nil).uppercaseString;
            self.statusContainerView.backgroundColor = GC_RED_COLOR;
            break;
        case eGCEventStatusUpComing:
            self.statusLabel.text = NSLocalizedString(@"gc_next", nil).uppercaseString;
            break;
        case eGCEventStatusFinished:
            self.statusLabel.text = NSLocalizedString(@"gc_ended", nil).uppercaseString;
            break;
        default:
            self.statusContainerView.hidden = YES;
    }

    if (eventModel.status == eGCEventStatusInProgress || eventModel.status == eGCEventStatusFinished) {
        self.matchDateContainer.hidden = YES;
        self.scoreLabel.hidden = NO;
    } else {
        self.matchDateContainer.hidden = NO;
        self.scoreLabel.hidden = YES;
    }

//    NSDate *now = [NSDate date];
//    NSDate *start = eventModel.start_date;
//    if ([start compare:now] == NSOrderedDescending) {
//        self.timerLabel.hidden = YES;
//    } else {
//        NSTimeInterval secondsSinceStart = [now timeIntervalSinceDate:start];
//        self.timerLabel.hidden = !(secondsSinceStart > 0 && eventModel.status == eGCEventStatusInProgress);
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        calendar.locale = [NSLocale localeWithLocaleIdentifier:[BridgedLanguageManager applicationLanguage]];
//        NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
//        dateComponentsFormatter.calendar = calendar;
//        dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
//        dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDefault;
//        dateComponentsFormatter.allowedUnits = NSCalendarUnitMinute;
//        self.timerLabel.text = SWF(@"'%@", [dateComponentsFormatter stringFromTimeInterval:secondsSinceStart]);
//    }

    // NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//    if (eventModel.status == eGCEventStatusInProgress)
//    {
//        [self.lb_statusEvent setTexteRecadre:[NSLocalizedString(@"gc_live", nil) uppercaseString] height:self.v_statusEvent.frame.size.height];
//        
//        //        [self.v_statusEvent setFrame:CGRectMake(-/2 - self.lb_statusEvent.frame.size.width/2 - self.lb_statusEvent.frame.origin.x, self.v_statusEvent.frame.origin.y, self.lb_statusEvent.frame.size.width + self.lb_statusEvent.frame.origin.x*2, self.lb_statusEvent.frame.size.height)];
//        
//        [self.lb_statusEvent setTextColor:STATUS_EVENT_LIVE_LB];
//        [self.lb_teamLeft setTextColor:TEAM_NAME_LIVE_LB];
//        [self.lb_teamRight setTextColor:TEAM_NAME_LIVE_LB];
//        [self.lb_score setTextColor:SCORE_LIVE_LB];
//        [self.lb_time setTextColor:TIME_LIVE_LB];
//        [self.lb_penalty setTextColor:SCORE_LIVE_LB];
//    }
//    else if (eventModel.status == eGCEventStatusUpComing)
//    {
//        [self.lb_statusEvent setTexteRecadre:[NSLocalizedString(@"gc_next", nil) uppercaseString] height:self.v_statusEvent.frame.size.height];
//        
//        [self.lb_statusEvent setTextColor:STATUS_EVENT_NOTLIVE_LB];
//        [self.lb_teamLeft setTextColor:TEAM_NAME_NOTLIVE_LB];
//        [self.lb_teamRight setTextColor:TEAM_NAME_NOTLIVE_LB];
//        [self.lb_score setTextColor:SCORE_NOTLIVE_LB];
//        [self.lb_time setTextColor:TIME_NOTLIVE_LB];
//        [self.lb_penalty setTextColor:SCORE_LIVE_LB];
//    }
//    [self.v_statusEvent setFrame:CGRectMake(self.frame.size.width / 2 - (self.lb_statusEvent.frame.size.width + self.lb_statusEvent.frame.origin.x*2) / 2,
//                                            self.v_statusEvent.frame.origin.y,
//                                            self.lb_statusEvent.frame.size.width + self.lb_statusEvent.frame.origin.x*2,
//                                            self.lb_statusEvent.frame.size.height)];
}

/*
 ** SetCell - Render
 */
-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    if (elt && [elt isKindOfClass:[GCEventModel class]])
    {
        GCEventModel *eventModel = elt;
        [self updateEventInfo:eventModel];
        [self updateExternalContentInfo:eventModel.gameContent];
        //[self.lb_time setText:SWF(@"%@ %@", self.lb_time.text, eventModel.name)];
    }
}

/*
 ** IIRenderGG Protocol
 */
+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
        cell = [[GCAPPSoccerEventCell alloc] initWithFrame:CGRectZero];
    
    [((GCAPPSoccerEventCell*)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCAPPSoccerEventCell";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    return CGSizeMake(collectionView.frame.size.width, 130);
}

@end
