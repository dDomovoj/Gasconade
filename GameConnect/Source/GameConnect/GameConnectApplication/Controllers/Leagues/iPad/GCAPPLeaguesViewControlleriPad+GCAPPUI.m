//
//  GCAPPLeaguesViewController+GCAPPUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 21/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLeaguesViewControlleriPad+GCAPPUI.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"
#import "GCAPPDefines.h"

@implementation GCAPPLeaguesViewControlleriPad (GCAPPUI)

-(void) setUpLeagueViews
{
    [self setUpButtons];
    [self setUpHeaders];
    
    if (isLeagueOwner)
    {
        [self.bt_leagueDeletion setAlpha:1];
        [self.bt_leagueEdition setAlpha:1];
        [self.bt_leagueInvitation setAlpha:1];
        [self.bt_quit setAlpha:0];
    }
    else
    {
        [self.bt_leagueDeletion setAlpha:0];
        [self.bt_leagueEdition setAlpha:0];
        [self.bt_leagueInvitation setAlpha:0];
        [self.bt_quit setAlpha:1];
    }
}

-(void) setUpButtons
{
    [self.bt_leagueDeletion setTitle:[NSLocalizedString(@"gc_delete_league", nil) capitalizedString] forState:UIControlStateNormal];
    [self.bt_leagueEdition setTitle:[NSLocalizedString(@"gc_modify_league", nil) capitalizedString] forState:UIControlStateNormal];
    [self.bt_leagueInvitation setTitle:[NSLocalizedString(@"gc_add_people", nil) capitalizedString] forState:UIControlStateNormal];
    [self.bt_leagueAddition setTitle:[NSLocalizedString(@"gc_add_league", nil) capitalizedString] forState:UIControlStateNormal];
    
    [self.bt_leagueDeletion setTitleColor:GCAPPColorButtonLB forState:UIControlStateNormal];
    [self.bt_leagueEdition setTitleColor:GCAPPColorButtonLB forState:UIControlStateNormal];
    [self.bt_leagueInvitation setTitleColor:GCAPPColorButtonLB forState:UIControlStateNormal];
    [self.bt_leagueAddition setTitleColor:GCAPPColorButtonLB forState:UIControlStateNormal];
    
    [self.bt_leagueDeletion setBackgroundColor:GCAPPColorButtonBG];
    [self.bt_leagueEdition setBackgroundColor:GCAPPColorButtonBG];
    [self.bt_leagueInvitation setBackgroundColor:GCAPPColorButtonBG];
    [self.bt_leagueAddition setBackgroundColor:GCAPPColorButtonBG];
    
    [self.bt_leagueDeletion.titleLabel setFont:CONFFONTSIZE(15)];
    [self.bt_leagueEdition.titleLabel setFont:CONFFONTSIZE(15)];
    [self.bt_leagueInvitation.titleLabel setFont:CONFFONTSIZE(15)];
    [self.bt_leagueAddition.titleLabel setFont:CONFFONTSIZE(15)];
}

-(void)setUpHeaders
{
    [self.lb_headerRanking setText:[NSLocalizedString(@"gc_rankings", nil) uppercaseString]];
    [self.lb_headerLeaguesList setText:[NSLocalizedString(@"gc_leagues", nil) uppercaseString]];
    
    [self.lb_headerLeaguesList setTextColor:GCAPPColorButtonLB];
    [self.lb_headerRanking setTextColor:GCAPPColorButtonLB];
    
    [self.lb_headerLeaguesList setFont:CONFFONTMEDIUMSIZE(14)];
    [self.lb_headerRanking setFont:CONFFONTMEDIUMSIZE(14)];
    
    [self.v_headerLeagueList setBackgroundColor:GCAPPHeaderBG];
    [self.v_headerRanking setBackgroundColor:GCAPPHeaderBG];
}

@end
