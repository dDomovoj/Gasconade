//
//  NSLLeagueManager.h
//  PepsiLiveGaming
//
//  Created by Guillaume Derivery on 3/11/14.
//  Copyright (c) 2014 Seb Jallot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCLeagueModel.h"

#ifndef FRIEND_INVITATION
#define FRIEND_INVITATION @"fb_friends_invitation"
#endif

@interface GCLeagueManager : NSObject
//{
//    BOOL postingInProgress;
//}

+(void) postNewLeague:(NSString *)leagueName cb_response:(void(^)(BOOL success, GCLeagueModel *createdLeague))cb_response;

+(void) deleteLeague:(NSString *)leagueID cb_response:(void(^)(BOOL success))cb_response;

+(void) getMyLeaguesWithResponse:(void(^)(NSArray *leagues))cb_response;

+(void) putLeagueEdition:(NSString *)leagueID withName:(NSString *)leagueName gamers:(NSArray *)leagueGamersIDs cb_response:(void(^)(BOOL success))cb_response;

+(void) getRankingsForLeague:(NSString *)leagueID withPage:(NSUInteger)page andLimit:(NSUInteger)limit  cb_response:(void(^)(NSArray *rankings))cb_response;

+(void) getLastMatchRankingsForLeague:(NSString *)leagueID withPage:(NSUInteger)page andLimit:(NSUInteger)limit cb_response:(void(^)(NSArray *rankings))cb_response;



+(void) sortArrayOfFBFriends:(NSArray *)fbFriends andArrayOfNSAPIFriends:(NSArray *)nsapiFriends thenCallBack:(void(^)(NSArray *fbFriendsInNSAPI, NSArray *fbOthers, NSArray *arrayNSAPIUserOnFacebook, NSArray *allSortedByName))cbDidSorted;

//+(GCLeagueManager *)getInstance;
//
//-(void) createLeague:(NSString *)leagueName cb_rep:(void (^)(NsSnTagModel *tag,NsSnUserErrorValue error))cb_rep_;
//
//-(void) updateLeague:(GCLeagueModel *)leagueModel cb_rep:(void (^)(NsSnTagModel *tag,NsSnUserErrorValue error))cb_rep_;
//
//-(void) getMyLeagues:(NSString *)user_id cb_rep:(void (^)(NSArray *leagues, BOOL cache))cb_rep_ cache:(BOOL)cache_;
//
//-(void)getPeopleInLeague:(GCLeagueModel *)leagueModel cb_rep:(void(^)(NSArray *rep, NsSnUserErrorValue error, BOOL cache))cb_rep_;
//
//-(void) inviteFacebookFriends:(NSArray *)arrayOfFBFriends reguardingNSAPIFriends:(NSArray *)arrayOfNSAPIFriends inLeague:(NsSnTagModel *)tagLeague cb_rep:(void(^)(BOOL ok))cb_rep;
//
//-(void) saveSelectedFBFriends:(NSArray *)arrayOfFBFriends forTagLeague:(NsSnTagModel *)tagLeague;
//
//-(BOOL) hasAPendingInvitation:(NSDictionary *)fb_friend forThisLeague:(GCLeagueModel *)leagueModel;
//
//-(void) removeLocalInvitationFile;
//
//-(NSArray *) removeFriendsMatchingFB:(NSArray *)allFBFriends andLeagueSubscribers:(NSArray *)peopleInLeague whoAreInLeague:(GCLeagueModel *)league;

@end
