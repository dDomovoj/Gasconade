//
//  NsSnUserManager.h
//  NsSn
//
//  Created by adelskott on 20/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnUserModel.h"
#import "NsSnFriendModel.h"
#import "NsSnFeedManager.h"
#import "NsSnThirdPartyModel.h"

#define NSSNNOTIF_LOGGEDIN @"NsSnNotificationLoggedIn"

@interface NsSnUserManager : NSObject
{
    NSString *uid;
}
@property (nonatomic, strong, readonly) NsSnUserModel *user;
@property (nonatomic, readonly) BOOL isLoggingIn;

/*
 ** Singleton
 */
+(NsSnUserManager*)getInstance;

/*
 ** Log in
 */
-(BOOL)isLoggedIn;
-(BOOL)isLoggedInUsingThirdParty;
-(BOOL)canReconect;

-(void)loginByMail:(NSString*)email passe:(NSString*)password post:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;
-(void)autologin:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;
-(void)logout:(void (^)(void))cb_rep;

/*
 ** Secutix
 */
-(void)loginSecutix:(NSString*)login passe:(NSString*)password post:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;
-(void)autologinSecutix:(NSDictionary*)post cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;
-(void)recoverPasswordSecutix:(NSString *)email cb_rep:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;
-(void)logoutSecutix:(void (^)(void))cb_rep;

/*
 ** TVA Sports
 */
-(void)loginTVA:(NSString *)tokenSSO cb_rep:(void(^)(BOOL ok, NsSnUserErrorValue error))cb_rep;

/*
 ** Update data
 */
-(void)refreshUser:(void (^)(BOOL ok))cb_rep;
-(void)updateUserProfile:(NSDictionary *)post cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep;
-(void)updateUserPassword:(NSString *)newPassword cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep;
-(void)updateUserMetadatas:(NSDictionary *)post cb_rep:(void (^)(BOOL ok, NSDictionary *rep))cb_rep;

/*
 ** Friends
 */
// FriendList Default limit 20
-(void)getFriendsList:(NsSnUserModel *)user cb_rep:(void (^)(NsSnUserModel *user, BOOL ok))cb_rep;
-(void)getFriendsListPaginated:(NsSnUserModel *)user page:(NSInteger)page limit:(NSInteger)limit cb_rep:(void (^)(BOOL ok, NSInteger nbFriends, NsSnUserModel *user))cb_rep;

-(void)getFriendsListPendingOutgoing:(void (^)(BOOL ok))cb_rep;
-(void)getFriendsListPendingIncoming:(void (^)(BOOL ok))cb_rep;

-(void)getAllMyFriendsListPaginated:(NSInteger)page limit:(NSInteger)limit cb_rep:(void (^)(BOOL ok, NSInteger nbFriends))cb_rep;
-(void)actionFriend:(NsSnUserModel *)user add:(BOOL)add cb_rep:(void (^)(BOOL ok))cb_rep;
-(void)acceptFriend:(NsSnUserModel *)user cb_rep:(void (^)(BOOL ok))cb_rep;
-(void)refuseFriend:(NsSnUserModel *)user cb_rep:(void (^)(BOOL ok))cb_rep;

/*
 ** User searching
 */
-(BOOL)isMe:(NSString*)uid;
-(void)search:(NSDictionary *)datas page:(NSInteger)page limit:(NSInteger)limit post:(NSDictionary *)post cb_rep:(void (^)(BOOL ok, NSArray *users, NSInteger nbUser))cb_rep;
-(NsSnUserModel *)findUser:(NsSnUserModel *)user inArray:(NSArray *)users;

/*
 ** User data
 */
-(void)getUser:(NsSnUserModel *)user cb_rep:(void (^)(NsSnUserModel*user,BOOL cache))cb_rep;
-(void)uploadAvatar:(UIImage *)imageAvatar cb_send:(void (^)(long long total, long long current))cb_send cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep;
-(void)reportAbuse:(NSString *)userId cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep;
-(void)getTopUsers:(void (^)(NSArray *topUser,NsSnUserErrorValue error,BOOL cache))cb_rep;

/*
 ** Third Party
 */
-(void)addThirdParty:(NsSnThirdPartyModel *)third_partyModel usingCb:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep;
+(void)getFaceBookFriendsIDs:(void(^)(NSArray *friends))cb;
+(void)getFaceBookFriends:(void(^)(NSArray *friends))cb;

@end



