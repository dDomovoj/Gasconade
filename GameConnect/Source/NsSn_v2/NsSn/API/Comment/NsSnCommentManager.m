//
//  NsSnCommentManager.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnCommentManager.h"
#import "NsSnConfManager.h"



@implementation NsSnCommentManager

+(NsSnCommentManager*)getInstance{
    static NsSnCommentManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnCommentManager alloc] init];
    });
    return sharedMyManager;
}

-(void)addComment:(NsSnFeedModel*)feed text:(NSString*)text  cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedCommentAdd],feed._id];
    
    NSDictionary *d = @{@"text": text};
    [NsSnRequester request:url post:d cb_send:^(long long total, long long current) {
        
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } credential:nil cache:NO];
}

-(void)deleteComment:(NSString*)commentId_ feedId:(NSString *)feedId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedCommentDelete], feedId_, commentId_];
   
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep, error);
    } cache:NO];
}

-(void)Like:(NSString*)feedId_ commentId:(NSString *)commentId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedCommentLike],feedId_, commentId_];

    [NsSnRequester request:url post:nil cb_send:^(long long total, long long current) {
        
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } credential:nil cache:NO];
}

-(void)unLike:(NSString*)feedId_ commentId:(NSString *)commentId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedCommentunLike],feedId_, commentId_];
    
    [NsSnRequester request:url post:nil cb_send:^(long long total, long long current)
    {
        
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep,error);
    } credential:nil cache:NO];
}

-(void)reportAbuseFeed:(NSString *)feedID onComment:(NsSnCommentModel *)comment cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep
{
    // TODO GUIGUI WARNING CHECK URL
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLFeedCommentReportAbuse], feedID, comment.comment_xid];

    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error)
     {
         cb_rep(rep,error);
     } cache:NO];
}

@end
