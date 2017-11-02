//
//  GCFootballPlayedEventCell.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 09/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPSoccerPlayedEventCell.h"
#import "Extends+Libs.h"
#import "GSMMatchModel.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

// Backgrounds
#define EVENT_ENDED_MATCHCELL_BG [UIColor colorWithRGBString:@"000000" alpha:0.3f]
#define EVENT_ENDED_BOTTOM_BG [UIColor colorWithRGBString:@"ffffffff" alpha:0.1f]
#define STATUS_EVENT_BG [UIColor colorWithRGBString:@"ffffffff" alpha:0.1f]

// Lables
#define STATUS_EVENT_ENDED_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.6f]
#define TEAM_NAME_ENDED_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.6f]
#define SCORE_ENDED_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.6f]
#define RANK_ENDED_LB [UIColor colorWithRGBString:@"ffffffff" alpha:0.6f]
#define POINTS_ENDED_LB [UIColor colorWithRGBString:@"ffffffff" alpha:1]

@implementation GCAPPSoccerPlayedEventCell

-(void)setColors
{
//    [self.lb_teamLeft setTextColor:TEAM_NAME_ENDED_LB];
//    [self.lb_teamRight setTextColor:TEAM_NAME_ENDED_LB];
//    [self.lb_score setTextColor:SCORE_ENDED_LB];

    [self.lb_rankingPosition setTextColor:RANK_ENDED_LB];
    [self.lb_rankingPositionSuffix setTextColor:RANK_ENDED_LB];
    [self.lb_points setTextColor:POINTS_ENDED_LB];
//    [self.lb_statusEvent setTextColor:STATUS_EVENT_ENDED_LB];

    [self.v_background setBackgroundColor:EVENT_ENDED_MATCHCELL_BG];
    [self.v_bottomBackground setBackgroundColor:EVENT_ENDED_BOTTOM_BG];
//    [self.v_statusEvent setBackgroundColor:STATUS_EVENT_BG];

    [self.v_points setBackgroundColor:CONFCOLORFORKEY(@"points_won_bg")];
}

-(void)setFonts
{
//    [self.lb_teamLeft setFont:CONFFONTSIZE(15)];
//    [self.lb_teamRight setFont:CONFFONTSIZE(15)];
//    
//    [self.lb_score setFont:CONFFONTSIZE(18)];
//    [self.lb_statusEvent setFont:CONFFONTSIZE(14)];

    [self.lb_points setFont:CONFFONTMEDIUMSIZE(13)];
    [self.lb_rankingPosition setFont:CONFFONTMEDIUMSIZE(18)];
    [self.lb_rankingPositionSuffix setFont:CONFFONTREGULARSIZE(8)];
}

/*
 ** Event Content
 */
-(void) updateEventInfo:(GCEventModel *)eventModel
{
    if (eventModel.status == eGCEventStatusFinished)
    {
//        [self.lb_statusEvent setTexteRecadre:[NSLocalizedString(@"gc_ended", nil) uppercaseString] height:self.v_statusEvent.frame.size.height];
//        [self.v_statusEvent setFrame:CGRectMake(self.frame.size.width - self.lb_statusEvent.frame.size.width - 10, self.v_statusEvent.frame.origin.y, self.lb_statusEvent.frame.size.width + 10, self.v_statusEvent.frame.size.height)];
//        [self.lb_statusEvent setFrame:CGRectMake(self.v_statusEvent.frame.origin.x + 5, self.v_statusEvent.frame.origin.y, self.lb_statusEvent.frame.size.width, self.v_statusEvent.frame.size.height)];
    }
    if (eventModel.rank)
    {
        [self.lb_points setText:SWF(@"%lu", (unsigned long)eventModel.rank.score)];
        [self.lb_rankingPosition setText:SWF(@"%lu", (unsigned long)eventModel.rank.rank)];
        [self.lb_rankingPositionSuffix setText:[GCConfManager getSuffixPosition:self.lb_rankingPosition.text]];
    }
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
        if ([eventModel.gameContent isKindOfClass:[GSMMatchModel class]])
        {
            GSMMatchModel *matchModel = (GSMMatchModel *)eventModel.gameContent;
            [self updateExternalContentInfo:eventModel.gameContent];
            
            NSString *groupname = matchModel.match_groupname;
            if ([groupname length] == 0)
                groupname = matchModel.match_roundname;
            [self.lb_groupName setText:groupname];
            [self.lb_groupName setTextColor:RANK_ENDED_LB];
            [self.lb_groupName setFont:CONFFONTMEDIUMSIZE(16)];

        }
    }
    [self.v_points.layer setCornerRadius:4.0];
    [self setFonts];
    [self setColors];
}

/*
 ** IIRenderGG Protocol
 */
+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:[GCAPPSoccerPlayedEventCell getIdentifierCell] owner:nil options:nil] getObjectsType:[GCAPPSoccerPlayedEventCell class]];
    
    [((GCAPPSoccerPlayedEventCell *)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCAPPSoccerPlayedEventCell";
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    return CGSizeMake(collectionView.frame.size.width, 95);
}


@end
