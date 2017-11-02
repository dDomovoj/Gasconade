//
//  NSDataManager.h
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDataManager : NSObject
{
	NSMutableDictionary *callbacks;
	NSMutableArray *listcall;
	NSMutableArray *waitingURL;
	
	NSTimer *timer;
	NSMutableArray *renderdatas;
    NSMutableArray *customHeadersForUrl;
}

+(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
        post:(NSDictionary*)post
     cb_send:(void (^)(long long total , long long current))cb_send
      cb_rcv:(void (^)(long long total , long long current))cb_rcv
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
       cache:(BOOL)cache;

+(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
		post:(NSData*)post
  postLength:(NSString *) postLength
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache;

+(id)request:(NSString *)url
        post:(NSDictionary*)post
     cb_send:(void (^)(long long total , long long current))cb_send
      cb_rcv:(void (^)(long long total , long long current))cb_rcv
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data))cb_rep
  credential:(NSDictionary*)credential
       cache:(BOOL)cache;

-(id)requestPut:(NSString *)url
        headers:(NSArray*)headers
   autovarspost:(BOOL)autovarspost
           post:(NSDictionary*)post
        cb_send:(void (^)(long long total , long long current))cb_send
         cb_rcv:(void (^)(long long total , long long current))cb_rcv
         cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
     credential:(NSDictionary*)credential
          cache:(BOOL)cache;

-(id)requestDelete:(NSString *)url
           headers:(NSArray*)headers
           cb_send:(void (^)(long long total , long long current))cb_send
            cb_rcv:(void (^)(long long total , long long current))cb_rcv
            cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
        credential:(NSDictionary*)credential
             cache:(BOOL)cache;

+(id)request:(NSString *)url
        post:(NSDictionary*)post
      cb_rcv:(void (^)(long long total , long long current))cb_rcv
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data))cb_rep
       cache:(BOOL)cache;

+(id)request:(NSString *)url
      cb_rcv:(void (^)(long long total , long long current))cb_rcv
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data))cb_rep
       cache:(BOOL)cache;

+(id)request:(NSString *)url
      cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data))cb_rep
       cache:(BOOL)cache;

+(id)request:(NSString *)url
     headers:(NSArray*)headers
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
	   cache:(BOOL)cache;

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data))cb_rep
	   cache:(BOOL)cache;

+(id)request:(NSString *)url
		post:(NSDictionary*)post
     headers:(NSArray*)headers
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data))cb_rep
	   cache:(BOOL)cache;

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache;

+(id)requestDelete:(NSString *)url
            cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
        credential:(NSDictionary*)credential
             cache:(BOOL)cache;
/**
 *  Singleton pattern
 *
 *  @return Pointer of instancetype (Here NSDataManager)
 */
+(NSDataManager*)getInstance;

-(void)addRenderData:(void (^)(NSDictionary *rep))cb_render;
+(void) clearCache:(NSString*)url;

/**
 *  String encoding to create proper urls
 *
 *  @param str String to encode
 *
 *  @return Encoded string of str
 */
+ (NSString *)encodeString:(NSString *)str;

/**
 *  Generation of HTTP Headers for Netco Url Signature System
 *
 *  @param clientId     ClientID of platform
 *  @param clientSecret ClientSECRET of platform
 *  @param url          Url designed for signature processing
 *  @param queryParams  QueryParams if used in the url
 *  @param postParams   PostParams if the url is using in a HTTP POST method (Multipart only)
 *
 *  @return Array of Dictionaries describing headers
 */
+(NSArray *)genSignatureHeaders:(NSString *)clientId
                   clientSecret:(NSString *)clientSecret
                         forUrl:(NSString *)url
                withQueryParams:(NSDictionary *)queryParams
                  andPostParams:(NSDictionary *)postParams;

/**
 *  Custom HTTP Headers Contol => ADD
 *
 *  @param headers  Array of Dictionaries describing headers
 *  @param regExUrl Url pattern describing urls of requests in which the headers should be injected
 */
-(void) addCustomHeaders:(NSArray *)headers forUlrMatchingRegEx:(NSString *)regExUrl;

/**
 *  Custom HTTP Headers Contol => GET
 *
 *  @param url Url called
 *
 *  @return Array of Dictionaries describing headers that should be injected in the request of the url
 *  because it matches one of the pattern added previously in the NSDataManager (see
 *  addCustomHeaders:forUlrMatchingRegEx: for more information)
 */
-(NSArray *) getCustomHeadersForUrl:(NSString *)url;

/**
 *  Unit Tests
 */
-(void) unitTextInjectHeaders;
+ (void)unitTestForEncoding;

@end
