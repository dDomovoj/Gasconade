//
//  NSLLeagueManager.m
//  PepsiLiveGaming
//
//  Created by Guillaume Derivery on 3/11/14.
//  Copyright (c) 2014 Seb Jallot. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCLeagueManager.h"
#import "GCConfManager.h"
#import "GCRequester.h"
#import "GCRankingModel.h"
//#import "GCLoggerManager.h"
#import "GCGamerManager.h"

#import "NsSnUserModel.h"
#import "NsSnMetadataModel.h"

@implementation GCLeagueManager

+(void) postNewLeague:(NSString *)leagueName cb_response:(void(^)(BOOL success, GCLeagueModel *createdLeague))cb_response
{
    NSString *url = [GCConfManager getURL:GCURLPOSTAddLeague];
    [GCRequester requestPOST:url post:@{@"private_league[name]" : leagueName} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        
        if (rep && [[rep getXpathEmptyString:@"id"] length] > 0 && httpcode == 201)
        {
            GCLeagueModel *leagueModel = [GCLeagueModel new];
            leagueModel._id = [rep getXpathEmptyString:@"id"];
            leagueModel.name = leagueName;
            cb_response(YES, leagueModel);
        }
        else
            cb_response(NO, nil);
    } cache:NO];
}

+(void) deleteLeague:(NSString *)leagueID cb_response:(void(^)(BOOL success))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLDELETELeague], leagueID);
    [GCRequester requestDELETE:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (httpcode == 204)
            cb_response(YES);
        else
            cb_response(NO);
    } cache:NO];
}

+(void) getMyLeaguesWithResponse:(void(^)(NSArray *leagues))cb_response
{
    NSString *url = [GCConfManager getURL:GCURLGETMyLeagues];
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (rep)
        {
            NSArray *arrayLeagues = [GCLeagueModel fromJSONArray:[rep getXpathNilArray:@"private_leagues"]];
            cb_response(arrayLeagues);
        }
        else
            cb_response(@[]);
    } cache:NO];
}

+(void) putLeagueEdition:(NSString *)leagueID withName:(NSString *)leagueName gamers:(NSArray *)leagueGamersIDs cb_response:(void(^)(BOOL success))cb_response
{
    if (!leagueID || [leagueID length] == 0)
    {
        DLog(@"League ID doesn't exist");
        cb_response(NO);
        return ;
    }
    if (!leagueGamersIDs || [leagueGamersIDs count] == 0)
        leagueGamersIDs = @[];
    
    NSString *url = SWF([GCConfManager getURL:GCURLPUTLegueEdition], leagueID);
    NSMutableDictionary *mutableDictionaryPost = [[NSMutableDictionary alloc] init];
    [mutableDictionaryPost setObject:leagueName forKey:@"private_league[name]"];
    
    NSInteger count = 0;
    for (id gamer in leagueGamersIDs)
    {
        if (gamer && [gamer length] > 0)
            [mutableDictionaryPost setObject:gamer forKey:SWF(@"private_league[gamers][%ld]", (long)count)];
        count++;
    }
    
    [GCRequester requestPUT:url post:[mutableDictionaryPost ToUnMutable] cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (httpcode == 204)
            cb_response(YES);
        else
            cb_response(NO);
    } cache:NO];
}

+(void) getRankingsForLeague:(NSString *)leagueID withPage:(NSUInteger)page andLimit:(NSUInteger)limit  cb_response:(void(^)(NSArray *rankings))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETLeagueRankings], leagueID, [NSNumber numberWithInteger:page], [NSNumber numberWithInteger:limit]);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (rep)
            cb_response([GCRankingModel fromJSONArray:[rep getXpathNilArray:@"ranks"]]);
        else
            cb_response(@[]);
    } cache:NO];
}

+(void) getLastMatchRankingsForLeague:(NSString *)leagueID withPage:(NSUInteger)page andLimit:(NSUInteger)limit cb_response:(void(^)(NSArray *rankings))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETLeagueRankings], leagueID, page, limit);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
     {
         GCLog(GCHTTPResponseLog, (long)httpcode, url);
         if (rep)
             cb_response([GCRankingModel fromJSONArray:[rep getXpathNilArray:@"ranks"]]);
         else
             cb_response(@[]);
     } cache:NO];
}


+(void) sortArrayOfFBFriends:(NSArray *)fbFriends andArrayOfNSAPIFriends:(NSArray *)nsapiFriends thenCallBack:(void(^)(NSArray *fbFriendsInNSAPI, NSArray *fbOthers, NSArray *arrayNSAPIUserOnFacebook, NSArray *allFBSortedByName))cbDidSorted
{
    NSMutableArray *arrayfbFriendsInNSAPI = [NSMutableArray new];
    NSMutableArray *arrayfbOthers = [NSMutableArray new];
    NSMutableArray *arrayNSAPIUserOnFB = [NSMutableArray new];
    
    for (NSString *fbUserId in fbFriends)
    {
        if (fbUserId && [fbUserId isKindOfClass:[NSString class]])
        {
            BOOL found = NO;
            for (NsSnUserModel *nsapiFriend in nsapiFriends)
            {
                if (nsapiFriend && nsapiFriend.Metadata && [nsapiFriend.Metadata count] > 0)
                {
                    for (NsSnMetadataModel *metadata in nsapiFriend.Metadata)
                    {
                        if (metadata &&
                            [metadata.key isEqualToString:@"facebook_id"] &&
                            [metadata.value isEqualToString:fbUserId])
                        {
                            [arrayfbFriendsInNSAPI addObject:fbUserId];
                            [arrayNSAPIUserOnFB addObject:nsapiFriend];
                            found = YES;
                            break;
                        }
                    }
                }
            }
            if (found == NO)
                [arrayfbOthers addObject:fbUserId];
        }
    }
    
    NSArray *mixed = [[arrayfbFriendsInNSAPI arrayByAddingObjectsFromArray:arrayfbOthers]sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        if (obj1 && obj2 && [obj1 isKindOfClass:[NSDictionary class]] && [obj2 isKindOfClass:[NSDictionary class]])
        {
            NSString *firstName1 = [obj1 objectForKey:@"first_name"];
            NSString *firstName2 = [obj2 objectForKey:@"first_name"];
            
            if ([firstName1 characterAtIndex:0] < [firstName2 characterAtIndex:0])
                return (NSComparisonResult)NSOrderedAscending;
            else
                return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    cbDidSorted(arrayfbFriendsInNSAPI, arrayfbOthers, arrayNSAPIUserOnFB, mixed);
}

@end
