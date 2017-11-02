//
//  NsSnTagManager.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnTagManager.h"
#import "NsSnTagModel.h"
#import "NsSnConfManager.h"
#import "NsSnSubscribeModel.h"
#import "Extends+Libs.h"
#import "NsSnUserManager.h"
#import "NsSnPendingTagModel.h"

@implementation NsSnTagManager

+(NsSnTagManager*)getInstance{
    static NsSnTagManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnTagManager alloc] init];
    });
    return sharedMyManager;
}

-(void)getTags:(NsSnTagManagerType)type page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagGetTags], type, page, limit];
    
    if ([url isSubString:@"(null)"])
        return cb_rep(nil, NsSnUserErrorValueUnknown,false);

    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSArray *a = [rep getXpathNilArray:@"/feeds/feeds"];
        cb_rep([NsSnTagModel fromJSONArray:a],error,cache);
    } cache:YES];
}

-(void)getTag:(NsSnTagModel *)currentTag cb_rep:(void (^)(NsSnTagModel *repTag,NsSnUserErrorValue error,BOOL cache))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagGetTag], currentTag._id];
    
    if ([url isSubString:@"(null)"])
        return cb_rep(nil,NsSnUserErrorValueUnknown,false);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        NSDictionary *a = [rep getXpathNilDictionary:@"/feeds/tag"];
        cb_rep([NsSnTagModel fromJSON:a],error,cache);
    } cache:YES];
}

-(void)getUserTags:(NsSnUserModel*)user page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagGetUserTags], user._id, page, limit];
    
    if ([url isSubString:@"(null)"])
        return cb_rep(nil,NsSnUserErrorValueUnknown,NO);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSArray *a = [rep getXpathNilArray:@"/feeds/feeds"];
        cb_rep([NsSnTagModel fromJSONArray:a],error,cache);
    } cache:YES];
}

-(void)getSubscribeUsers:(NsSnTagModel*)tag page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagGetSubscribeUsers], tag._id, page, limit];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil,NsSnUserErrorValueUnknown,NO);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        NSArray *a = [rep getXpathNilArray:@"/feeds/feeds"];
        cb_rep([NsSnUserModel fromJSONArray:a],error,cache);
    } cache:YES];
}

-(void)save:(NsSnTagModel *)tag  cb_send:(void (^)(long long total, long long current))cb_send cb_rep:(void (^)(NsSnTagModel *tag,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLTagSave];
    tag.tag_type = 1;
    if ([tag._id length])
        url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLTagUpdate];
    NSDictionary *toDict = [tag toDictionary];
    
    [NsSnRequester request:url post:toDict cb_send:^(long long total, long long current) {
        cb_send(total, current);
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        cb_rep([NsSnTagModel fromJSON:[rep getXpathNilDictionary:@"feeds/tag"]], error);
    } credential:nil cache:NO];
}

-(BOOL)isPendingUser:(NsSnUserModel *)user inTag:(NsSnTagModel *)tag
{
    NSArray *pendingsUserInTag = tag.Pendings;
    for (NsSnPendingTagModel *pending in pendingsUserInTag)
    {
        if (pending && [pending isKindOfClass:[NsSnPendingTagModel class]])
        {
            if ([pending.fk_user_id isEqualToString:user._id])
                return TRUE;
        }
    }
    return FALSE;
}

-(void)deleteTag:(NsSnTagModel*)tag cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [[NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLDeleteTag], tag.tag_name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        if ([rep getXpathBool:@"ok" defaultValue:NO])
            cb_rep(YES, rep,error);
        else
            cb_rep(NO, rep,error);
    } cache:NO];
}

-(void)subscribe:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagSubscribe], tag._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil,NsSnUserErrorValueUnknown);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } cache:NO];
}

-(void)unSubscribe:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagUnSubscribe], tag._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil,NsSnUserErrorValueUnknown);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } cache:NO];
}

-(void)acceptSubscribe:(NSString *)forUserId inTag:(NsSnTagModel*)tag cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagAcceptSubscribe], tag._id, forUserId];

    if ([url isSubString:@"(null)"])
        return cb_rep(NO, nil,NsSnUserErrorValueUnknown);

    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        cb_rep([rep getXpathBool:@"ok" defaultValue:NO], rep,error);

    } cache:NO];
}

-(void)denySubscribe:(NSString *)forUserId inTag:(NsSnTagModel*)tag cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagDenySubscribe], tag._id, forUserId];
    
    if ([url isSubString:@"(null)"])
        return cb_rep(NO, nil,NsSnUserErrorValueUnknown);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         cb_rep([rep getXpathBool:@"ok" defaultValue:NO], rep,error);
     } cache:NO];
}


-(BOOL)haveRightToSee:(NsSnTagModel*)tag{
    if(tag.tag_private == 0)
        return true;
    else{
        if([[NsSnUserManager getInstance] isMe:tag.fk_user_id])
            return true;
        __block BOOL found = NO;
        [[NsSnUserManager getInstance].user.Subscribes each:^(NSInteger index, NsSnSubscribeModel *elt, BOOL last) {
            if ([elt.fk_tag_id isEqualToString:tag._id]){
                found = YES;
            }
        }];
        return found;
    }
    return false;
}

-(void)invite:(NsSnTagModel*)tag user:(NsSnUserModel*)user cb_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagInvite], tag._id,user._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO, nil,NsSnUserErrorValueUnknown);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        cb_rep([rep getXpathBool:@"ok" defaultValue:NO], rep,error);
    } cache:NO];
}

-(void)acceptInvitationInATag:(NsSnTagModel*)tag b_rep:(void (^)(BOOL ok, NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagAcceptInvitation], tag._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO, nil,NsSnUserErrorValueUnknown);

    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        if (rep && [rep isKindOfClass:[NSDictionary class]])
        {
            if ([rep getXpathBool:@"ok" defaultValue:NO])
                cb_rep(YES, rep, error);
            else
                cb_rep(NO, rep, error);
        }
        else
            cb_rep(NO, rep, error);
    } cache:NO];
}

-(void)denyInvitationInATag:(NsSnTagModel*)tag b_rep:(void (^)(BOOL ok,NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagDenyInvitation], tag._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(NO, nil,NsSnUserErrorValueUnknown);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
        if (rep && [rep isKindOfClass:[NSDictionary class]])
        {
            if ([rep getXpathBool:@"ok" defaultValue:NO])
                cb_rep(YES, rep, error);
            else
                cb_rep(NO, rep, error);
        }
        else
            cb_rep(NO, rep, error);
    } cache:NO];
}

-(void)addFavorite:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagAddFavorite], tag._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil, NsSnUserErrorValueUnknown);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep, error);
    } cache:NO];
}

-(void)deleteFavorite:(NsSnTagModel*)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagDeleteFavorite], tag._id];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil, NsSnUserErrorValueUnknown);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep, error);
    } cache:NO];
}

-(void)expulseUserFrom:(NSString *)tagId userId:(NSString *)userId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagReportAbuse], userId_, tagId];

    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
    {
        cb_rep(rep, error);
    } cache:NO];
}

-(void)reportAbuseOnTag:(NsSnTagModel *)tag cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagReportAbuse], tag._id];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         cb_rep(rep,error);
     } cache:NO];
}

-(void)inviteThirdParty:(NsSnThirdPartyModel *)third_partyModel inTag:(NsSnTagModel *)tag usingCb:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagInviteThirdParty], tag._id, third_partyModel.third_party_id, third_partyModel.third_party_key];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (cb_rep)
        {
            if (rep && [rep getXpathBool:@"ok" defaultValue:NO])
                cb_rep(YES, error);
            else
                cb_rep(NO, error);
        }
    } cache:NO];
}

-(void)inviteDirect:(NsSnUserModel *)user inTag:(NsSnTagModel *)tag usingCb:(void (^)(BOOL ok, NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagDirectInvite], tag._id, user._id];
    
    if ([url isSubString:@"(null)"])
        return cb_rep(NO,NsSnUserErrorValueUnknown);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (cb_rep)
        {
            if (rep && [rep getXpathBool:@"ok" defaultValue:NO])
                cb_rep(YES, error);
            else
                cb_rep(NO, error);
        }
    } cache:NO];
    
}

@end
