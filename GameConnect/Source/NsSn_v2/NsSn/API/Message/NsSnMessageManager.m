//
//  NsSnMessageManager.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnMessageManager.h"
#import "NsSnConfManager.h"
#import "NsSnMessageModel.h"
#import "Extends+Libs.h"

@implementation NsSnMessageManager

+(void)post_users:(NsSnMessageModel *)message cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLMessagePostUsers];
    NSDictionary *post = [message toDictionaryPost];
    [NsSnRequester request:url post:post cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (cb_rep)
            cb_rep(rep,error);
    } cache:NO];
}

+(void)post_thread:(NsSnMessageModel *)message cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLMessagePostThread];
    NSDictionary *post = [message toDictionary];
    [NsSnRequester request:url post:post cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        if (cb_rep)
            cb_rep(rep,error);
    } cache:NO];
}

+(void)thread_history_by_user:(NSString *)thread_id orUserIds:(NSString *)user_ids cb_rep:(void (^)(NSArray *messages, NsSnUserErrorValue error))cb_rep{
    NSDictionary *dicPost = nil;
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLMessageHistory], thread_id];
    if (user_ids){
        dicPost = @{@"user_ids": user_ids};
        url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLMessageGetThreadByUsers];
        
        [NsSnRequester request:url post:dicPost cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
            NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLMessageHistory], [rep getXpathEmptyString:@"threads[0]id"]];
            [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
                NSArray *ar = [NsSnMessageModel fromJSONArray:[rep getXpathNilArray:@"thread/messages"]];
                if (cb_rep)
                    cb_rep(ar,error);
            } cache:NO];
        } cache:NO];
    }
    else {
        [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
            NSArray *ar = [NsSnMessageModel fromJSONArray:[rep getXpathNilArray:@"messages"]];
            if (cb_rep)
                cb_rep(ar,error);
        } cache:NO];
    }
}

+(void)autorized:(void(^)(NSDictionary *rep))cb{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLMessageJastAuthorized];
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb(rep);
    } cache:NO];
}


@end
