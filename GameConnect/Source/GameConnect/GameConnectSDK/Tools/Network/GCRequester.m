//
//  GCRequester
//  GameConnectV2
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCRequester.h"
#import "GCGamerManager.h"
//#import "GCProcessLoadingManager.h"
#import "GCPlatformConnection.h"

#define HEADER_X_API_USER_ID @"x-api-user-id"
#define HEADER_X_USER_TOKEN @"x-api-user-token"

@implementation GCRequester

+(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))hookResponse:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))cb
{
    void (^chekConnexion)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode) =
    ^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
//        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // NSLog(@"DATA : %@", strData);
        
//        if (httpcode == 401)
//        {
//            NSUInteger code = [rep getXpathInteger:@"error/code"];
//            if (code == 1005)
//            {
//                DLog(@"1005 REJECT");
//                [[GCProcessLoadingManager getInstance] startLoadingWithData:@{@"gcSuperText" : NSLocalizedString(@"gc_user_connected_multiple_devices", nil)} fromViewController:nil];
//                
//                if ([[GCGamerManager getInstance] isLoggedIn])
//                    [[GCGamerManager getInstance] logout:nil];
//            }
//        }
        if (cb)
            cb(rep, cache, data, httpcode);
    };
    return chekConnexion;
}

+(NSArray *) httpHeadersForGameConnectOnUrl:(NSString *)url ansPostParams:(NSDictionary *)postParams
{
    NSArray *headers = [NSDataManager genSignatureHeaders:[GCPlatformConnection getInstance].NSAPI_CLIENT_ID clientSecret:[GCPlatformConnection getInstance].NSAPI_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:postParams];

    if ([GCGamerManager getInstance].gamer._id && [GCGamerManager getInstance].user_generated_token)
        headers = [headers arrayByAddingObjectsFromArray:@[@{HEADER_X_API_USER_ID: [GCGamerManager getInstance].gamer._id}, @{HEADER_X_USER_TOKEN : [GCGamerManager getInstance].user_generated_token}]];
    return headers;
}

+(id)requestGET:(NSString *)url
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))cb_rep
	   cache:(BOOL)cache
{
    NSArray *headers = [GCRequester httpHeadersForGameConnectOnUrl:url ansPostParams:nil];
    return [NSDataManager request:url headers:headers autovarspost:NO post:nil cb_send:^(long long total, long long current) {
        
    } cb_rcv:^(long long total, long long current) {
        
    } cb_rep:[GCRequester hookResponse:cb_rep] credential:nil cache:cache];
}

//+(id)requestPOST:(NSString *)url
//    post:(NSDictionary*)post
//    cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))cb_rep
//     cache:(BOOL)cache
//{
//    NSArray *headers = [GCRequester httpHeadersForGameConnectOnUrl:url ansPostParams:post];
//    return [NSDataManager request:url headers:headers autovarspost:NO post:post cb_send:^(long long total, long long current) {
//
//    } cb_rcv:^(long long total, long long current) {
//
//    } cb_rep:[GCRequester hookResponse:cb_rep] credential:nil cache:cache];
//}
//
//+(id)requestPUT:(NSString *)url
//           post:(NSDictionary*)post
//         cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
//          cache:(BOOL)cache
//{
//    NSArray *headers = [GCRequester httpHeadersForGameConnectOnUrl:url ansPostParams:post];
//    return [[NSDataManager getInstance] requestPut:url headers:headers autovarspost:NO post:post cb_send:^(long long total, long long current) {
//
//    } cb_rcv:^(long long total, long long current) {
//
//    } cb_rep:[GCRequester hookResponse:cb_rep] credential:nil cache:cache];
//}
//
//+(id)requestDELETE:(NSString *)url
//            cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
//             cache:(BOOL)cache
//{
//    NSArray *headers = [GCRequester httpHeadersForGameConnectOnUrl:url ansPostParams:nil];
//    return [[NSDataManager getInstance] requestDelete:url headers:headers cb_send:^(long long total, long long current) {
//
//    } cb_rcv:^(long long total, long long current) {
//
//    } cb_rep:[GCRequester hookResponse:cb_rep] credential:nil cache:cache];
//}


/*
 +(id)request:(NSString *)url
 headers:(NSArray*)headers
 autovarspost:(BOOL)autovarspost
 post:(NSDictionary*)post
 cb_send:(void (^)(long long total , long long current))cb_send
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 credential:(NSDictionary*)credential
 cache:(BOOL)cache{
 
 return [[NsSnRequester getInstance] request:url headers:headers autovarspost:autovarspost post:post cb_send:cb_send cb_rcv:cb_rcv cb_rep:[NsSnRequester hookResponse:cb_rep] credential:credential cache:cache];
 }
 
 +(id)request:(NSString *)url
 post:(NSDictionary*)post
 cb_send:(void (^)(long long total , long long current))cb_send
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 credential:(NSDictionary*)credential
 cache:(BOOL)cache{
 
 NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:post];
 
 return [[NsSnRequester getInstance] request:url
 headers:headers
 autovarspost:NO
 post:post
 cb_send:cb_send
 cb_rcv:cb_rcv
 cb_rep:([NsSnRequester hookResponse:cb_rep])
 credential:credential cache:cache];
 }
 
 
 +(id)request:(NSString *)url
 post:(NSDictionary*)post
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 cache:(BOOL)cache{
 
 NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:post];
 
 return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:post cb_send:^(long long total, long long current) {
 
 } cb_rcv:cb_rcv cb_rep:[NsSnRequester hookResponse:cb_rep] credential:nil cache:cache];
 }
 
 +(id)request:(NSString *)url
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 cache:(BOOL)cache{
 
 NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:nil];
 
 return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:nil cb_send:^(long long total, long long current) {
 
 } cb_rcv:cb_rcv cb_rep:[NsSnRequester hookResponse:cb_rep] credential:nil cache:cache];
 }*/


/*

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
    NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:post];
    
	return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:[NsSnRequester hookResponse:cb_rep] credential:credential cache:cache];
}

 */

@end
