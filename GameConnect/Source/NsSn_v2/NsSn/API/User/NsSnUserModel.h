//
//  NsSnUserModel.h
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"
#import "UIImageViewJA.h"
#import "NsSnTagModel.h"
#import "NsSnSignModel.h"

typedef enum {
    FriendPendingNone = 1,
    FriendPendingOutgoing,
    FriendPendingIncoming,
    FriendAlreadyConfirmed
} FriendPending;

@interface NsSnUserModel : NsSnModel<NSCoding>

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *user_nickname;
@property (nonatomic, strong) NSString *user_email;
@property (nonatomic, strong) NSString *user_password;
@property (nonatomic) eNsUserVisibility user_visibility;

@property (nonatomic, strong) NSString *user_first_name;
@property (nonatomic, strong) NSString *user_last_name;
@property (nonatomic, strong) NSString *user_fk_tag_id;
@property (nonatomic, strong) NSString *user_tenant_id;

@property (nonatomic, strong) NSString *secutix_id;
@property (nonatomic, strong) NSString *secutix_token;

@property (nonatomic, assign) NSInteger user_created_at;
@property (nonatomic, assign) NSInteger user_nb_connexion;
@property (nonatomic, assign) NSInteger user_nb_photo;

@property (nonatomic, assign) FriendPending friends_pending_status;

@property (nonatomic, retain) NSArray *Metadata;
@property (nonatomic, retain) NSArray *AllFriends;
@property (nonatomic, retain) NSArray *Friends;
@property (nonatomic, retain) NSArray *FriendsPendingOutgoing;
@property (nonatomic, retain) NSArray *FriendsPendingIncoming;

@property (nonatomic, retain) NSArray *Subscribes;
@property (nonatomic, retain) NSArray *Avatar_formats;
@property (nonatomic, retain) NSArray *third_partys;

-(NSString *)getMetadataForKey:(NSString *)key;
-(BOOL)isFriends:(NSString *)iduser;
-(FriendPending)getFriendStatus:(NsSnUserModel *)user;

+(id)fromJSONArray:(NSArray*)data withFriendPendingType:(FriendPending)pendingType;
+(NSArray *) arrayOfIdsFromNSAPIUsers:(NSArray *)nsapiFriends;

@end
