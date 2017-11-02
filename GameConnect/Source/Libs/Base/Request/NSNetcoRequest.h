//
//  NSNetcoRequest.h
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNetcoRequest : NSObject{
	NSString            *_url;
	NSString            *_urlOrigine;
	void                (^_cb_send)(long long total , long long current);
	void                (^_cb_rcv)(long long total , long long current);
	void                (^_cb_rep)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode);
	BOOL                _cache;
	BOOL                _autovarspost;
	NSArray             *_headers;
	NSDictionary        *_credential;
	NSDictionary        *_originalPost;
    NSMutableDictionary *_postData;

	
	// data
	NSMutableData       *_reponse;
	long long           total;
	long long           recived;
	NSURLConnection     *connexion;
    NSDictionary        *r_headers;
    NSArray             *json_parse_ctype_exceptions;
    NSInteger           httpStatusCode;
}

-(void)request:(NSString *)url
       headers:(NSArray*)headers
  autovarspost:(BOOL)autovarspost
		  post:(NSDictionary*)post
	   cb_send:(void (^)(long long total , long long current))cb_send
		cb_rcv:(void (^)(long long total , long long current))cb_rcv
        cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
	credential:(NSDictionary*)credential
		 cache:(BOOL)cache;

-(void)request:(NSString *)url
       headers:(NSArray*)headers
  autovarspost:(BOOL)autovarspost
		  post:(NSData*)post
    postLength:(NSString *) postLength
	   cb_send:(void (^)(long long total , long long current))cb_send
		cb_rcv:(void (^)(long long total , long long current))cb_rcv
        cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
	credential:(NSDictionary*)credential
		 cache:(BOOL)cache;

-(void)requestDelete:(NSString *)url
             headers:(NSArray*)headers
             cb_send:(void (^)(long long total , long long current))cb_send
              cb_rcv:(void (^)(long long total , long long current))cb_rcv
              cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
          credential:(NSDictionary*)credential
               cache:(BOOL)cache;

-(void)requestPut:(NSString *)url
          headers:(NSArray*)headers
     autovarspost:(BOOL)autovarspost
             post:(NSDictionary*)post
          cb_send:(void (^)(long long total , long long current))cb_send
           cb_rcv:(void (^)(long long total , long long current))cb_rcv
           cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
       credential:(NSDictionary*)credential
            cache:(BOOL)cache;

// cache
+(id)getCacheValue:(NSString *)url;
+(void)removeCache:(NSString*)url;


@end
