//
//  NsSnFeedManager.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnFeedManager.h"
#import "NsSnConfManager.h"
#import "Extends+Libs.h"


@implementation NsSnFeedManager


+(NsSnFeedManager*)getInstance{
    static NsSnFeedManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnFeedManager alloc] init];
    });
    return sharedMyManager;
}

-(void)getFeed:(NsSnFeedModel*)feed cb_rep:(void (^)(NsSnFeedModel *rep,NsSnUserErrorValue error,BOOL cache))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagGetFeed], feed._id];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSDictionary *a = [rep getXpathNilDictionary:@"feeds/feeds"];
        cb_rep([NsSnFeedModel fromJSON:a],error,cache);
    } cache:YES];
}

-(void)getFeedsAPI:(NSString*)x_id page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnTagModel *tag,NsSnUserErrorValue error,BOOL cache))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagGetFeedsTagAPI], x_id, 1, page, limit];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSDictionary *t = [rep getXpathNilDictionary:@"feeds/tag"];
        NSArray *a = [rep getXpathNilArray:@"feeds/feeds"];
        cb_rep([NsSnFeedModel fromJSONArray:a],[NsSnTagModel fromJSON:t],error,cache);
    } cache:YES];
}

-(void)getFeeds:(NsSnTagModel*)tag page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLTagGetFeedsTag], tag._id,tag.tag_private == 1 ? 0 : 1, page, limit];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSArray *a = [rep getXpathNilArray:@"feeds/feeds"];
        cb_rep([NsSnFeedModel fromJSONArray:a],error,cache);
    } cache:YES];
}

-(void)deleteFeed:(NSString *)feedId cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLDeleteFeeds], feedId];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep, error);
    } cache:NO];

}

-(void)sendFeed:(NsSnTagModel*)tag text:(NSString*)text  medias:(NSArray*)medias  cb_send:(void (^)(long long total, long long current))cb_send cb_rep:(void (^)(NSDictionary*rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedSave];
    NSDictionary *post = @{@"text": text,@"tag_ids":tag._id};
    if ([medias count]){
        post = @{@"text": text,@"tag_ids":tag._id,@"file":medias[0]};
    }
    [NsSnRequester request:url post:post cb_send:^(long long total, long long current) {
        cb_send(total, current);
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } credential:nil cache:NO];
}

-(void)Like:(NsSnFeedModel*)feed cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedLike],feed._id];
    [NsSnRequester request:url post:nil cb_send:^(long long total, long long current) {
        
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } credential:nil cache:NO];
}

-(void)unLike:(NsSnFeedModel*)feed cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedUnLike],feed._id];
    [NsSnRequester request:url post:nil cb_send:^(long long total, long long current) {
        
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } credential:nil cache:NO];
}

-(void)reportAbuseOnFeed:(NsSnFeedModel *)feed cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedReportAbuse], feed._id];
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         cb_rep(rep,error);
     } cache:NO];
}

@end
