//
//  CGPlatformConectionModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 ** Default value for platform connection
 */
#define JAST_HOST @"https://minijast-integration.netcodev.com"

#define GC_API_URL @"https://gc-integration.netcodev.com"
#define GC_API_VERSION @"1"

#define NSSN_API_URL @"https://nsapi-integration.netcodev.com"
#define NSSN_API_VERSION @"1"
#define NSSN_API_CLIENT_ID @"2c4ba50e-67fc-481a-994f-d7990c621e5c"
#define NSSN_API_CLIENT_SECRET @"882b57a56d63b9e9da45f1fe66a087f57ee101c1"

#define CGU_URL_FORMAT @{@"default":@"en", @"en":@"http://www.thefanclub.com/data_externe_iphone/pepsi/cgu.html", @"fr":@"http://www.thefanclub.com/data_externe_iphone/pepsi/cgu_fr.html"}
#define REWARDS_URL_FORMAT @{@"default":@"en", @"en":@"http://www.thefanclub.com/data_externe_iphone/pepsi/rewards.html", @"fr":@"http://www.thefanclub.com/data_externe_iphone/pepsi/rewards_fr.html"}
#define ABOUT_URL_FORMAT @{@"default":@"en", @"en":@"http://www.thefanclub.com/data_externe_iphone/pepsi/about.html", @"fr":@"http://www.thefanclub.com/data_externe_iphone/pepsi/about_fr.html"}

/*
 ** Default Log string for HTTP reponse
 */

#define GCHTTPResponseLog @"HTTP response code : %ld for url : %@"

typedef enum
{
    // Competitions
    GCURLGETCompetitionRankings,
    GCURLGETCompetitions,
    GCURLGETMyCompetitionRanking,
    
    // Events
    GCURLGETEventRankings,
    GCURLGETLiveUpComingEvents,
    GCURLGETMyEventRanking,
    
    // Questions
    GCURLPOSTAnswers,
    GCURLGETAllEventQuestions,
    GCURLGETEventQuestion,
    
    // Gamers
    GCURLGETGamerTrophies,
    GCURLGETGamer,
    GCURLGETGamerPlayedEvents,
    
    // Leagues
    GCURLPOSTAddLeague,
    GCURLDELETELeague,
    GCURLGETMyLeagues,
    GCURLGETLeagueGamers,
    GCURLPUTLegueEdition,
    GCURLGETLeagueRankings,
    
    // Check Status
    CGURLGETPlatformAvailability,
    
    // Channels Faye
    GCURLChannelUser,
    
} GCConfigURLType;

@interface GCPlatformConnection : NSObject

@property (strong, nonatomic) NSString *GCMINIJAST_HOST;
@property (strong, nonatomic) NSString *GCFAYE_URL;

@property (strong, nonatomic) NSString *GCLEJ_URL;
@property (strong, nonatomic) NSString *GCLEJ_VERSION;

@property (strong, nonatomic) NSString *NSAPI_URL;
@property (strong, nonatomic) NSString *NSAPI_VERSION;

@property (strong, nonatomic) NSDictionary *GCCGU_URL_FORMATS;
@property (strong, nonatomic) NSDictionary *GCREWARDS_URL_FORMATS;
@property (strong, nonatomic) NSDictionary *GCABOUT_URL_FORMATS;

@property (strong, nonatomic) NSString *NSAPI_CLIENT_ID;
@property (strong, nonatomic) NSString *NSAPI_CLIENT_SECRET;

@property (strong, nonatomic) NSString *PREFERED_LANGUAGE;

+(GCPlatformConnection *) getInstance;
-(void) initialize;
-(NSString*)getURL:(GCConfigURLType)value;

-(NSString *)getURLForCGU;
-(NSString *)getURLForRewards;
-(NSString *)getURLForAbout;

@end
