//
//  NsSnUserModel.m
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnUserModel.h"
#import "Extends+Libs.h"
#import "NsSnConfManager.h"

#import "NsSnMetadataModel.h"
#import "NsSnSubscribeModel.h"

#import "NsSnAvatarModel.h"
#import "NsSnSubscribeModel.h"

#import "NsSnThirdPartyModel.h"

@implementation NsSnUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self._id forKey:@"_id"];
    [aCoder encodeObject:self.user_nickname forKey:@"user_login"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self._id = [aDecoder decodeObjectForKey:@"_id"];
        self.user_nickname = [aDecoder decodeObjectForKey:@"user_login"];
    }
    return self;
}

-(NSDictionary*)toDictionary
{
    if ([self validate])
    {
        NSDictionary *post = @{ @"nickname" : self.user_nickname,
                               @"email" : self.user_email,
                               @"first_name" : self.user_first_name,
                               @"last_name" : self.user_last_name,
                               @"fk_tag_id" : self.user_fk_tag_id,
                               @"tenant_id" : self.user_tenant_id,

                               @"nb_connexion" : @(self.user_nb_connexion),
                               @"nb_photo" : @(self.user_nb_photo) };
        return post;
    }
    return nil;
}

-(BOOL)validate
{
    if ([self.user_nickname length] < 4)
        return NO;
    return YES;
}

-(void)fromJSON:(NSDictionary *)data
{
    self._id = [data getXpathEmptyString:@"id"];
    self.user_nickname = [data getXpathEmptyString:@"nickname"];
    self.user_email = [data getXpathEmptyString:@"email"];
    self.user_visibility = [NsSnSignModel giveMeNsUserVisibilityFromString:[data getXpathEmptyString:@"visibility"]];
    self.user_first_name = [data getXpathEmptyString:@"first_name"];
    self.user_last_name = [data getXpathEmptyString:@"last_name"];
    self.user_fk_tag_id = [data getXpathEmptyString:@"fk_tag_id"];
    self.user_tenant_id = [data getXpathEmptyString:@"tenant_id"];

    self.secutix_id = [data getXpathEmptyString:@"identification"];
    self.secutix_token = [data getXpathEmptyString:@"unique_token"];

    self.user_created_at = 0;
    NSNumber *createLong = [data getXpath:@"created_at" type:[NSNumber class] def:0];
    if (createLong > 0){
        float createInt = [createLong doubleValue] / 1000.0;
        self.user_created_at = (int)createInt;
    }
    self.user_nb_connexion = [data getXpathInteger:@"nb_connexion"];
    self.user_nb_photo = [data getXpathInteger:@"nb_photo"];
    
    self.friends_pending_status = FriendPendingNone;
    
    self.Metadata = [NsSnMetadataModel fromJSONArray:[data getXpathNilArray:@"metadata"]];
    
    self.Subscribes = [NsSnSubscribeModel fromJSONArray:[data getXpathNilArray:@"Subscribes"]];

    self.Avatar_formats = [NsSnAvatarModel fromJSONDictionary:[data getXpathNilDictionary:@"avatar_formats"]];

    self.third_partys = [NsSnThirdPartyModel fromJSONArray:[data getXpathNilArray:@"third_partys"]];
}

+(NsSnUserModel *)fromJSON:(NSDictionary*)data
{
    NsSnUserModel *user = [NsSnUserModel new];
    [user fromJSON:data];
    return user;
}

+(id)fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        NsSnUserModel *user = [NsSnUserModel fromJSON:elt];
        NSString *isFriend = [elt getXpathEmptyString:@"is"];

        if ([isFriend isEqualToString:@"friend"]){
            user.friends_pending_status = FriendAlreadyConfirmed;
        }
        else if ([isFriend isEqualToString:@"incomming_pending_friendship"]){
            user.friends_pending_status = FriendPendingIncoming;
        }
        else if ([isFriend isEqualToString:@"outgoing_pending_friendship"]){
            user.friends_pending_status = FriendPendingOutgoing;
        }
        else {
            user.friends_pending_status = FriendPendingNone;
        }
        [ret addObject:user];
    }];
    return ret;
}

+(id)fromJSONArray:(NSArray*)data withFriendPendingType:(FriendPending)pendingType{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last)
    {
        NsSnUserModel *user = [NsSnUserModel fromJSON:elt];
        user.friends_pending_status = pendingType;
        [ret addObject:user];
    }];
    return ret;
}

-(NSString *)getMetadataForKey:(NSString *)key
{
    NSString *value = @"";
    for (NsSnMetadataModel *meta in self.Metadata)
    {
        if ([meta.key isEqualToString:key]){
            value = meta.value;
            break;
        }
    }
    return value;
}

-(BOOL)isFriends:(NSString*)iduser{
    __block BOOL ret = NO;
    [self.Friends each:^(NSInteger index, NsSnUserModel *friends, BOOL last) {
        if ([friends._id isEqualToString:iduser]) {
            ret = YES;
        }
    }];
    return ret;
}

-(FriendPending)getFriendStatus:(NsSnUserModel *)user{
    __block FriendPending pending = FriendPendingNone;
    
    NSString *iduser = user._id;
    [self.AllFriends each:^(NSInteger index, NsSnUserModel *friends, BOOL last) {
        if ([friends._id isEqualToString:iduser]) {
            pending = friends.friends_pending_status;
        }
    }];
    return pending;
}

+(NSArray *) arrayOfIdsFromNSAPIUsers:(NSArray *)nsapiFriends
{
    NSMutableArray *arrayOfIdsNSAPI = [[NSMutableArray alloc] initWithCapacity:[nsapiFriends count]];
    for (NsSnUserModel *nsapiFriend in nsapiFriends)
    {
        if (nsapiFriend && nsapiFriend._id)
            [arrayOfIdsNSAPI addObject:nsapiFriend._id];
    }
    return arrayOfIdsNSAPI;
}


@end
