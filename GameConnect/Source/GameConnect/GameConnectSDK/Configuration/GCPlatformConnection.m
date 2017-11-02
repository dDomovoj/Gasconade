//
//  CGPlatformConectionModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCPlatformConnection.h"
#import "NsSnConfManager.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"
#import "BridgedLanguageManager.h"

@implementation GCPlatformConnection

#pragma Singleton
+(GCPlatformConnection *) getInstance;
{
    static GCPlatformConnection *platformConfManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        platformConfManager = [[self alloc] init];
    });
    return platformConfManager;
}

-(void) initialize
{
    self.PREFERED_LANGUAGE = [BridgedLanguageManager applicationLanguage];
    
    self.NSAPI_URL = NSSN_API_URL;
    self.NSAPI_VERSION = NSSN_API_VERSION;
    
    self.GCLEJ_URL = GC_API_URL;
    self.GCLEJ_VERSION = GC_API_VERSION;
    
    self.GCCGU_URL_FORMATS = CGU_URL_FORMAT;
    self.GCABOUT_URL_FORMATS = ABOUT_URL_FORMAT;
    self.GCREWARDS_URL_FORMATS = REWARDS_URL_FORMAT;
    
    self.NSAPI_CLIENT_ID = NSSN_API_CLIENT_ID;
    self.NSAPI_CLIENT_SECRET = NSSN_API_CLIENT_SECRET;
    
    self.GCMINIJAST_HOST = JAST_HOST;
    self.GCFAYE_URL = SWF(@"%@/faye", self.GCMINIJAST_HOST);
//    [NsSnConfManager getInstance].NSAPI_JAST_HOST = self.GCMINIJAST_HOST;
//    
//    [NsSnConfManager getInstance].NSAPI_URL = self.NSAPI_URL;
//    [NsSnConfManager getInstance].NSAPI_VERSION = self.NSAPI_VERSION;
//    
//    [NsSnConfManager getInstance].NSAPI_CLIENT_ID = self.NSAPI_CLIENT_ID;
//    [NsSnConfManager getInstance].NSAPI_CLIENT_SECRET = self.NSAPI_CLIENT_SECRET;
}

-(void)setNSAPI_URL:(NSString *)NSAPI_URL
{
    _NSAPI_URL = NSAPI_URL;
    [NsSnConfManager getInstance].NSAPI_URL = self.NSAPI_URL;
}

-(void)setNSAPI_VERSION:(NSString *)NSAPI_VERSION
{
    _NSAPI_VERSION = NSAPI_VERSION;
    [NsSnConfManager getInstance].NSAPI_VERSION = self.NSAPI_VERSION;
}
-(void)setNSAPI_CLIENT_ID:(NSString *)NSAPI_CLIENT_ID
{
    _NSAPI_CLIENT_ID = NSAPI_CLIENT_ID;
    [NsSnConfManager getInstance].NSAPI_CLIENT_ID = self.NSAPI_CLIENT_ID;
}

-(void)setNSAPI_CLIENT_SECRET:(NSString *)NSAPI_CLIENT_SECRET
{
    _NSAPI_CLIENT_SECRET = NSAPI_CLIENT_SECRET;
    [NsSnConfManager getInstance].NSAPI_CLIENT_SECRET = self.NSAPI_CLIENT_SECRET;
}

-(void)setGCMINIJAST_HOST:(NSString *)GCMINIJAST_HOST
{
    _GCMINIJAST_HOST = GCMINIJAST_HOST;
    [NsSnConfManager getInstance].NSAPI_JAST_HOST = _GCMINIJAST_HOST;
    _GCFAYE_URL = SWF(@"%@/faye", _GCMINIJAST_HOST);
}

-(void)setPREFERED_LANGUAGE:(NSString *)PREFERED_LANGUAGE
{
    _PREFERED_LANGUAGE = PREFERED_LANGUAGE;
    [NsSnConfManager getInstance].PREFERED_LANGUAGE = _PREFERED_LANGUAGE;
}

-(NSString*)getURL:(GCConfigURLType)urlType
{
    switch (urlType)
    {
            // Competitions
        case GCURLGETCompetitionRankings:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/ranking/_/pages/%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"p%@/l%@"];
            break;
            
            
        case GCURLGETCompetitions:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions?lang=%@", self.GCLEJ_URL, self.GCLEJ_VERSION, self.PREFERED_LANGUAGE];
            break;
            
        case GCURLGETMyCompetitionRanking:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/my_rank", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@"];
            break;
            
            
            // Events
        case GCURLGETEventRankings:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/events/%@/ranking/_/pages/%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"%@", @"p%@/l%@"];
            break;
            
        case GCURLGETLiveUpComingEvents:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/events/_/currents?lang=%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", self.PREFERED_LANGUAGE];
            break;
            
        case GCURLGETMyEventRanking:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/events/%@/my_rank", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"%@"];
            break;
            
            
            // Questions
        case GCURLPOSTAnswers:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/events/%@/questions/%@/answer", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"%@", @"%@"];
            break;
            
        case GCURLGETAllEventQuestions:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/events/%@/questions/_/with_my_answers?lang=%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"%@", self.PREFERED_LANGUAGE];
            break;

        case GCURLGETEventQuestion:
            return [NSString stringWithFormat:@"%@/mobile/%@/competitions/%@/events/%@/questions/%@/with_my_answers?lang=%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"%@", @"%@", self.PREFERED_LANGUAGE];
            break;

            // Gamers
        case GCURLGETGamerTrophies:
            return [NSString stringWithFormat:@"%@/mobile/%@/gamers/%@/trophies?lang=%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", self.PREFERED_LANGUAGE];
            break;
            
        case GCURLGETGamer:
            return [NSString stringWithFormat:@"%@/mobile/%@/gamers/%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@"];
            break;

        case GCURLGETGamerPlayedEvents:
            return [NSString stringWithFormat:@"%@/mobile/%@/gamers/%@/competitions/%@/events/_/past_events?lang=%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"%@",self.PREFERED_LANGUAGE];
            break;

            // Leagues
        case GCURLPOSTAddLeague:
            return [NSString stringWithFormat:@"%@/mobile/%@/private_leagues", self.GCLEJ_URL, self.GCLEJ_VERSION];
            break;

        case GCURLDELETELeague:
            return [NSString stringWithFormat:@"%@/mobile/%@/private_leagues/%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@"];
            break;

        case GCURLGETMyLeagues:
            return [NSString stringWithFormat:@"%@/mobile/%@/private_leagues/_/my_private_leagues", self.GCLEJ_URL, self.GCLEJ_VERSION];
            break;
            
        case GCURLGETLeagueGamers:
            return [NSString stringWithFormat:@"%@/mobile/%@/private_leagues/%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@"];
            break;
            
        case GCURLPUTLegueEdition:
            return [NSString stringWithFormat:@"%@/mobile/%@/private_leagues/%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@"];
            break;
            
        case GCURLGETLeagueRankings:
            return [NSString stringWithFormat:@"%@/mobile/%@/private_leagues/%@/ranking/_/pages/%@", self.GCLEJ_URL, self.GCLEJ_VERSION, @"%@", @"p%@/l%@"];
            break;
            
            // Check platform
        case CGURLGETPlatformAvailability:
            return [NSString stringWithFormat:@"%@/mobile/%@/can_play", self.GCLEJ_URL, self.GCLEJ_VERSION];
            break;
            
            // Channels Faye
        case GCURLChannelUser:
            return [NSString stringWithFormat:@"/gamers/%@", @"%@"];
            break;
            
        default:
            break;
    }
}

-(NSString *)getURLForCGU{
    NSString *lang = [BridgedLanguageManager applicationLanguage];
    NSString *url = [_GCCGU_URL_FORMATS getXpathNilString:lang];
    if (!url){
        url = [_GCCGU_URL_FORMATS getXpathEmptyString:[_GCCGU_URL_FORMATS getXpathEmptyString:@"default"]];
    }
    return url;
}

-(NSString *)getURLForRewards{
    NSString *lang = [BridgedLanguageManager applicationLanguage];
    NSString *url = [_GCREWARDS_URL_FORMATS getXpathNilString:lang];
    if (!url){
        url = [_GCREWARDS_URL_FORMATS getXpathEmptyString:[_GCREWARDS_URL_FORMATS getXpathEmptyString:@"default"]];
    }
    return url;
}

-(NSString *)getURLForAbout{
    NSString *lang = [BridgedLanguageManager applicationLanguage];
    NSString *url = [_GCABOUT_URL_FORMATS getXpathNilString:lang];
    if (!url){
        url = [_GCABOUT_URL_FORMATS getXpathEmptyString:[_GCABOUT_URL_FORMATS getXpathEmptyString:@"default"]];
    }
    return url;
}


@end
