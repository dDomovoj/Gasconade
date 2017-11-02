//
//  GCUserManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnRequester.h"
#import "GCGamerModel.h"
#import "NsSnUserModel.h"
#import "GCTrophyModel.h"
#import "NsSnSignManager.h"

#define USE_LOCAL_AVATAR YES
#define LOCAL_AVATAR_FILENAME_FORMAT @"avatar-gc-%@.dat"
#define CACHE_NSAPI_GC 600

@interface GCGamerManager : NSObject

@property (strong, nonatomic, readonly) GCGamerModel *gamer;
@property (copy, nonatomic) UIImage *connectedGamerAvatar;
@property (strong, nonatomic, readonly) NSString *user_generated_token;

@property (assign, readonly) BOOL platformsAvailabilityCheckDone;
@property (assign, readonly) BOOL platformsAvailabilityCheckRequested;
@property (assign, readonly) BOOL isPlatformAvailableToPlay;

+(GCGamerManager *)getInstance;

#pragma mark - Check platform

-(void) checkPlatformsAvailability:(void(^)(BOOL isPlatformAvailableToPlay))callbackCheck;

#pragma mark - Authentification & NSAPI services

-(void)autologin:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;

-(void)loginByMail:(NSString*)email passe:(NSString*)password cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;

-(void)loginBySSOTVA:(NSString *)tokenSSO cb_rep:(void(^)(BOOL ok, NsSnUserErrorValue error))cb_rep;

-(void)subscribeAPI:(NsSnSignModel*)user cb_rep:(void (^)(BOOL inscription_ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)updateUserMetadatas:(NSDictionary *)post cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep;

-(BOOL) isLoggedIn;

-(BOOL) isLoggingIn;

-(BOOL) canReconect;

-(void)logout:(void (^)(void))cb_rep;

-(void)updateUserProfile:(NSDictionary *)post cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep;

-(void)updateUserPassword:(NSString *)newPassword cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep;

#pragma mark - Avatar

-(void) setConnectedGamerAvatar:(UIImage *)imageAvatar;
-(void) loadConnectedGamerAvatar;

-(void)uploadAvatar:(UIImage *)imageAvatar cb_send:(void (^)(long long total, long long current))cb_send cb_rep:(void (^)(GCGamerModel *gamer))cb_rep;

#pragma mark - Profile GameConnect

-(void) getTrophiesForGamer:(NSString *)gamerID cb_response:(void (^)(NSArray *trophies))cb_response;

-(void) getProfileForGamer:(NSString *)gamerID cb_response:(void (^)(GCGamerModel *gamer))cb_response;

-(void) getPlayedEventsForGamer:(NSString *)gamerID inCompetition:(NSString *)competitionID cb_response:(void (^)(NSArray *playedEvents))cb_response;

@end
