//
//  NsSnTagManager.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnRequester.h"
#import "NsSnUserModel.h"
#import "NsSnTagModel.h"
#import "NsSnThirdPartyModel.h"

typedef enum  {
    NsSnTagManagerTypeDate = 1,
    NsSnTagManagerTypePopulair,
    NsSnTagManagerTypeFavorites,
    NsSnTagManagerTypeFriends
} NsSnTagManagerType;

@interface NsSnTagManager : NSObject

+(NsSnTagManager*)getInstance;

-(void)save:(NsSnTagModel *)tag  cb_send:(void (^)(long long total, long long current))cb_send cb_rep:(void (^)(NsSnTagModel *tag,NsSnUserErrorValue error))cb_rep;

-(void)deleteTag:(NsSnTagModel*)tag cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)getTags:(NsSnTagManagerType)type page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep;

-(void)getTag:(NsSnTagModel *)currentTag cb_rep:(void (^)(NsSnTagModel *repTag,NsSnUserErrorValue error,BOOL cache))cb_rep;

-(void)getUserTags:(NsSnUserModel*)user page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep;

-(void)getSubscribeUsers:(NsSnTagModel*)tag page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep;

-(void)subscribe:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)unSubscribe:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)denySubscribe:(NSString *)forUserId inTag:(NsSnTagModel*)tag cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)acceptSubscribe:(NSString *)forUserId inTag:(NsSnTagModel*)tag cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)addFavorite:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)deleteFavorite:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)expulseUserFrom:(NSString *)tagId userId:(NSString *)userId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)reportAbuseOnTag:(NsSnTagModel *)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(BOOL)haveRightToSee:(NsSnTagModel*)tag;

-(BOOL)isPendingUser:(NsSnUserModel *)user inTag:(NsSnTagModel *)tag;

-(void)invite:(NsSnTagModel*)tag user:(NsSnUserModel*)user cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)acceptInvitationInATag:(NsSnTagModel*)tag b_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)denyInvitationInATag:(NsSnTagModel*)tag b_rep:(void (^)(BOOL ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)inviteDirect:(NsSnUserModel *)user inTag:(NsSnTagModel *)tag usingCb:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;

-(void)inviteThirdParty:(NsSnThirdPartyModel *)third_partyModel inTag:(NsSnTagModel *)tag usingCb:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;

@end
