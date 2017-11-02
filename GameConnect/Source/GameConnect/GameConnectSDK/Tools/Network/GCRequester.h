//
//  GCRequester
//  GameConnectV2
//
//  Created by Guillaume Derivery on 07/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSDataManager.h"

@interface GCRequester : NSObject // NSDataManager

//+(GCRequester*)getInstance;

+(id)requestGET:(NSString *)url
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
       cache:(BOOL)cache;

//+(id)requestPOST:(NSString *)url
//    post:(NSDictionary*)post
//    cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
//     cache:(BOOL)cache;
//
//+(id)requestPUT:(NSString *)url
//            post:(NSDictionary*)post
//          cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
//           cache:(BOOL)cache;
//
//+(id)requestDELETE:(NSString *)url
//            cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
//             cache:(BOOL)cache;

/*
 
 +(id)request:(NSString *)url
 post:(NSDictionary*)post
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 cache:(BOOL)cache;
 
 +(id)request:(NSString *)url
 post:(NSDictionary*)post
 cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 credential:(NSDictionary*)credential
 cache:(BOOL)cache;
 
 +(id)request:(NSString *)url
 post:(NSDictionary*)post
 cb_send:(void (^)(long long total , long long current))cb_send
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 credential:(NSDictionary*)credential
 cache:(BOOL)cache;
 
 +(id)request:(NSString *)url
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 cache:(BOOL)cache;
 
 +(id)request:(NSString *)url
 headers:(NSArray*)headers
 autovarspost:(BOOL)autovarspost
 post:(NSDictionary*)post
 cb_send:(void (^)(long long total , long long current))cb_send
 cb_rcv:(void (^)(long long total , long long current))cb_rcv
 cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
 credential:(NSDictionary*)credential
 cache:(BOOL)cache;

 
 */

@end
