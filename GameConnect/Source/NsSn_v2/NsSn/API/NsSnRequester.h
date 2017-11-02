//
//  NsSnRequester.h
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDataManager.h"

typedef enum
{
    // Unknown
    NsSnUserErrorValueUnknown,
    
    // Default No error
    NsSnUserErrorValueNone,
    
    // Subscribe
    NsSnUserErrorValueLoginAlreadyExist,
    
    // Login
    NsSnUserErrorValueUserNotFound,
    
    // General
    NsSnUserErrorValueNotLoggedIn,
    
    // Metadata
    NsSnUserErrorValueNoSearchParam,
    
} NsSnUserErrorValue;


@interface NsSnRequester : NSDataManager


+(NSDataManager*)getInstance;


+(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
        post:(NSDictionary*)post
     cb_send:(void (^)(long long total , long long current))cb_send
      cb_rcv:(void (^)(long long total , long long current))cb_rcv
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
        post:(NSDictionary*)post
      cb_rcv:(void (^)(long long total , long long current))cb_rcv
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
       cache:(BOOL)cache;

+(id)request:(NSString *)url
      cb_rcv:(void (^)(long long total , long long current))cb_rcv
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
       cache:(BOOL)cache;

+(id)request:(NSString *)url
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
       cache:(BOOL)cache;

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
	   cache:(BOOL)cache;

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache;


@end
