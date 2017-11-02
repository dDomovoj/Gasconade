//
//  NSDataManager.m
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>
#import "NSDataManager.h"
#import "NSNetcoRequest.h"
#import "NSObject+NSObject_File.h"
#import "NSObject+NSObject_Xpath.h"
#import "NSObject+NSObject_Tool.h"
#import "NSString+NSString_File.h"
#import "NSString+NSString_Tool.h"

#define HEADER_X_API_CLIENT_ID  @"X-Api-Client-Id"
#define HEADER_X_API_SIG        @"X-Api-Sig"

/**
 *  These defines used to be included in the generation of http headers for
 *  Netco Url Signature System. Now, they must be passed as parameters of
 *  method genSignatureHeaders:clientSecret:forUrl:withQueryParams:andPostParams:
 */
/*
#ifndef CLIENT_ID
#define CLIENT_ID               @"a366c46b-ccf5-4583-a681-8c819ede64fc"
#endif

#ifndef CLIENT_SECRET
#define CLIENT_SECRET           @"29113a661772583261db287788522d796cd908c4"
#endif
 */

#ifndef DLog
#define DLog(...) NSLog(@"%s [line %d] : %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#endif

//static NSDataManager* NSDataManager_instance = nil;
@interface NSDataManager (Private)

-(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
		post:(NSDictionary*)post
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache;

+(NSDataManager *) getInstance;

@end;



@implementation NSDataManager

//+(NSDataManager*)getInstance{
//	if (!NSDataManager_instance){
//		NSDataManager_instance = [[NSDataManager alloc] init];
//	}
//	return NSDataManager_instance;
//}
+(NSDataManager *) getInstance{
    static NSDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
		post:(NSDictionary*)post
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
	if ([url isSubString:@"(null)"]){
        NSLog(@"URL ERROR : %@", url);
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
	}
	
	[NSObject mainThreadBlock:^{
		
		
		
		NSString *key = [url md5]; // todo + post
		
		@synchronized(self){
			
			
			if ([self isloading:key] && !post){ // NO POST HERE
				/*void (^cb_rep_dataManager)(NSDictionary*rep, BOOL cache, NSData* data) = ^(NSDictionary *rep, BOOL cache, NSData *data) {
				 //				[self removeRequest:key];
				 cb_rep(rep,cache,data);
				 };*/
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep}
				[self addRequest:ar forkey:key];
				if (cache){
					NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:url];
                    [NSObject backGroundBlockDownload:^{
                        [NSObject mainThreadBlock:^{
                            if (cb_rep)
                                cb_rep(theDictionary, YES, nil, 0);
                        }];
                    }];
				}
				//		return nil;
			}else{
				NSNetcoRequest *r = [[NSNetcoRequest alloc] init];
				__weak NSNetcoRequest *r_block = r;
				// add cache
				__weak NSMutableArray *renderdatas2 = renderdatas;
				__weak NSMutableArray *listcall2 = listcall;
				__weak NSDataManager *selff = self;
				void (^cb_rep_dataManager)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) = ^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
					if (!cache){
						for (id elt in renderdatas2) {
							void(^cba) (NSDictionary*rep)= elt;
							cba(rep);
						}
						/*
						[renderdatas2 each:^(int index, id elt) {
							void(^cba) (NSDictionary*rep)= elt;
							cba(rep);
						}];*/
					}
					[selff respondOtherWaiting:key rep:rep data:data httpcode:httpcode cache:cache];
					
					//cb_rep(rep,cache,data);
					if (r_block){
						[listcall2 removeObject:r_block];
						
					}
				};
				
				void (^cb_rcv_dataManager)(long long total , long long current) = ^(long long total , long long current){
					[NSObject mainThreadBlock:^{
						[selff rcvOtherWaiting:key total:total current:current];
					}];
				};
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//[self addRequest:@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep} forkey:key];
				[self addRequest:ar forkey:key];
				
                NSArray *mergedHeaders = [[NSArray alloc]init];
                NSArray *preSepcifiedHeaders = [self getCustomHeadersForUrl:url];
                if (preSepcifiedHeaders && [preSepcifiedHeaders count] > 0)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:preSepcifiedHeaders];
                if (headers)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:headers];

				[r request:url headers:mergedHeaders autovarspost:autovarspost post:post cb_send:cb_send cb_rcv:cb_rcv_dataManager cb_rep:cb_rep_dataManager credential:credential cache:cache];
				if (!listcall)
					listcall = [@[] ToMutable];
				[listcall addObject:r];
				//return r;
			}
		}
	}];
	return nil;
}

-(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
		post:(NSData*)post
  postLength:(NSString *) postLength
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
	if ([url isSubString:@"(null)"]){
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
		NSLog(@"/*********************************ERROR*********************************/");
	}
	
	[NSObject mainThreadBlock:^{
		
		
		
		NSString *key = [url md5]; // todo + post
		
		@synchronized(self){
			
			
			if ([self isloading:key] && !post){ // NO POST HERE
				/*void (^cb_rep_dataManager)(NSDictionary*rep, BOOL cache, NSData* data) = ^(NSDictionary *rep, BOOL cache, NSData *data) {
				 //				[self removeRequest:key];
				 cb_rep(rep,cache,data);
				 };*/
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep}
				[self addRequest:ar forkey:key];
				if (cache){
					NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:url];
                    [NSObject backGroundBlockDownload:^{
                        [NSObject mainThreadBlock:^{
                            if (cb_rep)
                                cb_rep(theDictionary, YES, nil, 0);
                        }];
                    }];
				}
				//		return nil;
			}else{
				NSNetcoRequest *r = [[NSNetcoRequest alloc] init];
				__weak NSNetcoRequest *r_block = r;
				// add cache
				__weak NSMutableArray *renderdatas2 = renderdatas;
				__weak NSMutableArray *listcall2 = listcall;
				__weak NSDataManager *selff = self;
				void (^cb_rep_dataManager)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) = ^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
					if (!cache){
						for (id elt in renderdatas2) {
							void(^cba) (NSDictionary*rep)= elt;
							cba(rep);
						}
						/*
                         [renderdatas2 each:^(int index, id elt) {
                         void(^cba) (NSDictionary*rep)= elt;
                         cba(rep);
                         }];*/
					}
					[selff respondOtherWaiting:key rep:rep data:data httpcode:httpcode cache:cache];
					
					//cb_rep(rep,cache,data);
					if (r_block){
						[listcall2 removeObject:r_block];
						
					}
				};
				
				void (^cb_rcv_dataManager)(long long total , long long current) = ^(long long total , long long current){
					[NSObject mainThreadBlock:^{
						[selff rcvOtherWaiting:key total:total current:current];
					}];
				};
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//[self addRequest:@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep} forkey:key];
				[self addRequest:ar forkey:key];
				
                
                NSArray *mergedHeaders = [[NSArray alloc]init];
                NSArray *preSepcifiedHeaders = [self getCustomHeadersForUrl:url];
                if (preSepcifiedHeaders && [preSepcifiedHeaders count] > 0)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:preSepcifiedHeaders];
                if (headers)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:headers];
                
                [r request:url headers:mergedHeaders
                            autovarspost:autovarspost
                                    post:post
                                    postLength:postLength
                                    cb_send:cb_send
                                    cb_rcv:cb_rcv_dataManager
                                    cb_rep:cb_rep_dataManager
                                    credential:credential
                                    cache:cache];
                if (!listcall)
					listcall = [@[] ToMutable];
				[listcall addObject:r];
				//return r;
			}
		}
	}];
	return nil;
}


-(id)requestPut:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
		post:(NSDictionary*)post
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
	if ([url isSubString:@"(null)"])
    {
        NSLog(@"URL ERROR : %@", url);
	}
	
	[NSObject mainThreadBlock:^{
		NSString *key = [url md5]; // todo + post
		@synchronized(self)
        {
			if ([self isloading:key] && !post){ // NO POST HERE
				/*void (^cb_rep_dataManager)(NSDictionary*rep, BOOL cache, NSData* data) = ^(NSDictionary *rep, BOOL cache, NSData *data) {
				 //				[self removeRequest:key];
				 cb_rep(rep,cache,data);
				 };*/
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep}
				[self addRequest:ar forkey:key];
				if (cache){
					NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:url];
                    [NSObject backGroundBlockDownload:^{
                        [NSObject mainThreadBlock:^{
                            if (cb_rep)
                                cb_rep(theDictionary, YES, nil, 0);
                        }];
                    }];
				}
				//		return nil;
			}else{
				NSNetcoRequest *r = [[NSNetcoRequest alloc] init];
				__weak NSNetcoRequest *r_block = r;
				// add cache
				__weak NSMutableArray *renderdatas2 = renderdatas;
				__weak NSMutableArray *listcall2 = listcall;
				__weak NSDataManager *selff = self;
				void (^cb_rep_dataManager)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) = ^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
					if (!cache){
						for (id elt in renderdatas2) {
							void(^cba) (NSDictionary*rep)= elt;
							cba(rep);
						}
						/*
                         [renderdatas2 each:^(int index, id elt) {
                         void(^cba) (NSDictionary*rep)= elt;
                         cba(rep);
                         }];*/
					}
					[selff respondOtherWaiting:key rep:rep data:data httpcode:httpcode cache:cache];
					
					//cb_rep(rep,cache,data);
					if (r_block){
						[listcall2 removeObject:r_block];
						
					}
				};
				
				void (^cb_rcv_dataManager)(long long total , long long current) = ^(long long total , long long current){
					[NSObject mainThreadBlock:^{
						[selff rcvOtherWaiting:key total:total current:current];
					}];
				};
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//[self addRequest:@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep} forkey:key];
				[self addRequest:ar forkey:key];
				
                NSArray *mergedHeaders = [[NSArray alloc]init];
                NSArray *preSepcifiedHeaders = [self getCustomHeadersForUrl:url];
                if (preSepcifiedHeaders && [preSepcifiedHeaders count] > 0)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:preSepcifiedHeaders];
                if (headers)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:headers];

                [r requestPut:url headers:mergedHeaders autovarspost:autovarspost post:post cb_send:cb_send cb_rcv:cb_rcv_dataManager cb_rep:cb_rep_dataManager credential:credential cache:cache];
				if (!listcall)
					listcall = [@[] ToMutable];
				[listcall addObject:r];
				//return r;
			}
		}
	}];
	return nil;
}

-(id)requestDelete:(NSString *)url
     headers:(NSArray*)headers
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
	if ([url isSubString:@"(null)"]){
	}

	[NSObject mainThreadBlock:^{

		NSString *key = [url md5]; // todo + post
		@synchronized(self){

			if ([self isloading:key]){
				/*void (^cb_rep_dataManager)(NSDictionary*rep, BOOL cache, NSData* data) = ^(NSDictionary *rep, BOOL cache, NSData *data) {
				 //				[self removeRequest:key];
				 cb_rep(rep,cache,data);
				 };*/
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep}
				[self addRequest:ar forkey:key];
				if (cache){
					NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:url];
					if (cb_rep)
						cb_rep(theDictionary, YES, nil, 0);
				}
				//		return nil;
			}else{
				NSNetcoRequest *r = [[NSNetcoRequest alloc] init];
				__weak NSNetcoRequest *r_block = r;
				// add cache
				__weak NSMutableArray *renderdatas2 = renderdatas;
				__weak NSMutableArray *listcall2 = listcall;
				__weak NSDataManager *selff = self;
				void (^cb_rep_dataManager)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) = ^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
					if (!cache){
						for (id elt in renderdatas2) {
							void(^cba) (NSDictionary*rep)= elt;
							cba(rep);
						}
						/*
                         [renderdatas2 each:^(int index, id elt) {
                         void(^cba) (NSDictionary*rep)= elt;
                         cba(rep);
                         }];*/
					}
					[selff respondOtherWaiting:key rep:rep data:data httpcode:httpcode cache:cache];
					
					//cb_rep(rep,cache,data);
					if (r_block){
						[listcall2 removeObject:r_block];
						
					}
				};
				
				void (^cb_rcv_dataManager)(long long total , long long current) = ^(long long total , long long current){
					[NSObject mainThreadBlock:^{
						[selff rcvOtherWaiting:key total:total current:current];
					}];
				};
				NSArray *ar = [NSArray arrayWithObjects:[cb_send copy],[cb_rcv copy],[cb_rep copy], nil];
				//[self addRequest:@{@"cb_send":cb_send,@"cb_rcv":cb_rcv,@"cb_rep":cb_rep} forkey:key];
				[self addRequest:ar forkey:key];
				
                NSArray *mergedHeaders = [[NSArray alloc]init];
                NSArray *preSepcifiedHeaders = [self getCustomHeadersForUrl:url];
                if (preSepcifiedHeaders && [preSepcifiedHeaders count] > 0)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:preSepcifiedHeaders];
                if (headers)
                    mergedHeaders = [mergedHeaders arrayByAddingObjectsFromArray:headers];
                
				[r requestDelete:url headers:mergedHeaders cb_send:cb_send cb_rcv:cb_rcv_dataManager cb_rep:cb_rep_dataManager credential:credential cache:cache];
				if (!listcall)
					listcall = [@[] ToMutable];
				[listcall addObject:r];
				//return r;
			}
		}
	}];
	return nil;
}

-(BOOL)isloading:(NSString*)key{
	return !![(callbacks) getXpathNilArray:key];
}

-(void)removeRequest:(NSString*)key{
//	NSLog(@"Remove key => %@",key);
	[callbacks removeObjectForKey:key];
}

-(void)addRequest:(NSArray*)cbs forkey:(NSString*)key{
	
	if (!callbacks) {
		callbacks = [@{} ToMutable];
	}
	NSMutableArray *ar = callbacks[key];
//	NSLog(@"addRequest callbacks => %@ nb => %d main => %@",key, [ar count],([NSThread isMainThread] ? @"OUI" : @"NON"));
	if (!ar)
		ar = [@[] ToMutable];
	[ar addObject:cbs];
	callbacks[key] = ar; 
	
}
-(void)respondOtherWaiting:(NSString*)key
					   rep:(NSDictionary*)rep
					  data:(NSData*)data
                  httpcode:(NSInteger)httpcode
					 cache:(BOOL)cache
{
	
	NSArray *ar = [[callbacks getXpathNilArray:key] ToMutable];
	if (!cache)
		[self removeRequest:key];
//	if ([key isEqualToString:@"2F25BF9DB352285F7D6DC3A242B25BBD"]){
//		NSLog(@"DATA => %@",[rep description]);
//	}
//	NSLog(@"START call callbacks => %@ nb => %d main => %@",key, [ar count],([NSThread isMainThread] ? @"OUI" : @"NON"));

	for (id elt in ar) {
		void (^cb)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode) = ((elt)[2]); //@"cb_rep"
		if (cb)
			cb(rep,cache,data, httpcode);
	}
	
	/*[ar each:^(int index, id elt) {
		void (^cb)(NSDictionary*rep, BOOL cache, NSData* data) = ((elt)[2]); //@"cb_rep"
		if (cb)
			cb(rep,cache,data);
		//cb = nil;
	}];*/
//	NSLog(@"END call callbacks => %@ nb => %d",key, [ar count]);
}

-(void)rcvOtherWaiting:(NSString*)key
				 total:(long long)total
			   current:(long long)current
{
	NSArray *ar = [[callbacks getXpathNilArray:key] ToMutable];
//	NSLog(@"call rcvOtherWaiting => %@ nb => %d",key, [ar count]);
	
	for (id elt in ar) {
		void (^cb)(long long total , long long current) = ((elt)[1]);//[@"cb_rcv"]);
		if (cb)
			cb(total,current);
	}
	/*
	[ar each:^(int index, id elt) {
		void (^cb)(long long total , long long current) = ((elt)[1]);//[@"cb_rcv"]);
		if (cb)
			cb(total,current);
		//cb = nil;
	}];
	 
	 */
}

-(void)addRenderData:(void (^)(NSDictionary *rep))cb_render{
	if(!renderdatas){
		renderdatas = [@[] ToMutable];
	}
	[renderdatas addObject:cb_render];
}

-(void)dealloc{
//	NSLog(@"end");
}

#pragma mark

+(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
		post:(NSDictionary*)post
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
    
	return [[NSDataManager getInstance] request:url headers:headers autovarspost:autovarspost post:post cb_send:cb_send cb_rcv:cb_rcv cb_rep:cb_rep credential:credential cache:cache];
}

+(id)request:(NSString *)url
     headers:(NSArray*)headers
autovarspost:(BOOL)autovarspost
		post:(NSData*)post
  postLength:(NSString *) postLength
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
    return [[NSDataManager getInstance] request:url headers:headers autovarspost:autovarspost post:post postLength:postLength cb_send:cb_send cb_rcv:cb_rcv cb_rep:cb_rep credential:credential cache:cache];
}

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	 cb_send:(void (^)(long long total , long long current))cb_send
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:nil autovarspost:YES post:post cb_send:cb_send cb_rcv:cb_rcv cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:credential cache:cache];
}

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:nil autovarspost:YES post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:cb_rcv cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:nil cache:cache];
}

+(id)request:(NSString *)url
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:nil autovarspost:YES post:nil cb_send:^(long long total, long long current) {
		
	} cb_rcv:cb_rcv cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:nil cache:cache];
}

+(id)request:(NSString *)url
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:nil autovarspost:YES post:nil cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:nil cache:cache];
}

+(id)request:(NSString *)url
     headers:(NSArray*)headers
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:headers autovarspost:YES post:nil cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:nil cache:cache];
}

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:nil autovarspost:YES post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:nil cache:cache];
}

+(id)request:(NSString *)url
		post:(NSDictionary*)post
     headers:(NSArray*)headers
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:headers autovarspost:YES post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:nil cache:cache];
}

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] request:url headers:nil autovarspost:YES post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:credential cache:cache];
}

+(id)requestPut:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache
{
	return [[NSDataManager getInstance] requestPut:url headers:nil autovarspost:YES post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:credential cache:cache];
}


+(id)requestDelete:(NSString *)url
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
	return [[NSDataManager getInstance] requestDelete:url headers:nil cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
        if (cb_rep)
            cb_rep(rep, cache, data);
    } credential:credential cache:cache];
}

+(void) clearCache:(NSString*)url{
	[NSNetcoRequest removeCache:url];
}


#pragma mark - New Netco Auth

-(void) addCustomHeaders:(NSArray *)headers forUlrMatchingRegEx:(NSString *)regExUrl
{
    if (!customHeadersForUrl)
        customHeadersForUrl = [NSMutableArray new];
    [customHeadersForUrl addObject:@{@"headers" : headers, @"urlRegEx" : regExUrl}];
}

-(NSArray *) getCustomHeadersForUrl:(NSString *)url
{
    if (!customHeadersForUrl)
    {
        //DLog(@"No Custom header specified in NSDataManager. Terminating here...");
        return nil;
    }
    
    for (NSDictionary *element in customHeadersForUrl)
    {
        NSArray *headers = [element getXpathNilArray:@"headers"];
        NSString *urlRegEx = [element getXpathNilString:@"urlRegEx"];

        // DLog(@"[REGEX] %@", urlRegEx);
        if (element && headers && urlRegEx)
        {
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:NSRegularExpressionCaseInsensitive error:&error];
            if ([regex numberOfMatchesInString:url options:0 range:NSMakeRange(0, [url length])] > 0)
            {
                //DLog(@"[MATCH] URL: %@", url);
                return headers;
            }
//            else
//                DLog(@"[DOENST MATCH] URL: %@", url);
        }
    }
    // DLog(@"No headers found for url : %@", url);
    return nil;
}

+(NSArray *)genSignatureHeaders:(NSString *)clientId
                   clientSecret:(NSString *)clientSecret
                         forUrl:(NSString *)url
                    withQueryParams:(NSDictionary *)queryParams
                      andPostParams:(NSDictionary *)postParams
{
    if (!clientId) {
        return @[];
    }
    NSMutableString *signature = [[NSMutableString alloc] init];
    [signature appendString:url];
    if ([url hasSubstring:@"?"])
        [signature appendString:@"&"];
    else
        [signature appendString:@"?"];
    
    if (queryParams)
        [signature appendString:[NSDataManager generateParamsStringFromDictionary:queryParams]];
    if (postParams)
        [signature appendString:[NSDataManager generateParamsStringFromDictionary:postParams]];
    
    [signature appendFormat:@"@%@:%@", clientId, [[NSString stringWithFormat:@"netcosports%@", clientSecret] sha1]];
    
    return @[@{HEADER_X_API_CLIENT_ID: clientId}, @{HEADER_X_API_SIG: [signature sha1]}];
}

+ (NSString *)generateParamsStringFromDictionary:(NSDictionary *)params{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSArray *sortedKeys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *key in sortedKeys){
        if ([[params objectForKey:key] isKindOfClass:[NSString class]]){
//            NSString *str = [[params objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *str = [self encodeString:[params objectForKey:key]];
            [result appendFormat:@"%@=%@&", key, str];
        }
    }

    return [result ToUnMutable];
}

+(NSString *)encodeString:(NSString *)str{
    if (![str isKindOfClass:[NSString class]]){
        return str;
    }
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    str = [str strReplace:@"%" to:@"%25"];
//    str = [str strReplace:@" " to:@"%20"];
    str = [str strReplace:@"!" to:@"%21"];
    str = [str strReplace:@"'" to:@"%27"];
    str = [str strReplace:@"(" to:@"%28"];
    str = [str strReplace:@")" to:@"%29"];
    str = [str strReplace:@"\"" to:@"%22"];
    str = [str strReplace:@";" to:@"%3B"];
    str = [str strReplace:@":" to:@"%3A"];
    str = [str strReplace:@"@" to:@"%40"];
    str = [str strReplace:@"&" to:@"%26"];
    str = [str strReplace:@"=" to:@"%3D"];
    str = [str strReplace:@"+" to:@"%2B"];
    str = [str strReplace:@"$" to:@"%24"];
    str = [str strReplace:@"," to:@"%2C"];
    str = [str strReplace:@"/" to:@"%2F"];
    str = [str strReplace:@"?" to:@"%3F"];
    str = [str strReplace:@"#" to:@"%23"];
    str = [str strReplace:@"[" to:@"%5B"];
    str = [str strReplace:@"]" to:@"%5D"];
    str = [str strReplace:@"<" to:@"%3C"];
    str = [str strReplace:@">" to:@"%3E"];
    str = [str strReplace:@"\t" to:@"%09"];
    str = [str strReplace:@"\n" to:@"%0A"];

//    str = [str strReplace:@"é" to:@"%C3%A9"];
//    str = [str strReplace:@"à" to:@"%C3%A0"];
//    str = [str strReplace:@"ç" to:@"%C3%A7"];
//    str = [str strReplace:@"è" to:@"%C3%A8"];
//    str = [str strReplace:@"ù" to:@"%C3%B9"];
//    str = [str strReplace:@"ô" to:@"%C3%B4"];
    
    return str;
}

-(void) unitTextInjectHeaders
{
    NSLog(@"<<<<<<<<<<< TEST 1 >>>>>>>>>>>>>");
    [self addCustomHeaders:@[@{@"headerKEY1" : @"headerVALUE1"}, @{@"headerKEY2" : @"headerVALUE2"}, @{@"headerKEY3" : @"headerVALUE3"}] forUlrMatchingRegEx:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"];
    
    NSLog(@"[1] Get Headers %@", [self getCustomHeadersForUrl:@"https://gc-integration.netcodev.com"]);
    [customHeadersForUrl removeAllObjects];
    
    NSLog(@"<<<<<<<<<<< TEST 2 >>>>>>>>>>>>>");
    [self addCustomHeaders:@[@{@"headerKEY1" : @"headerVALUE1"}, @{@"headerKEY2" : @"headerVALUE2"}, @{@"headerKEY3" : @"headerVALUE3"}] forUlrMatchingRegEx:@"(https://gc-integration.netcodev.com)"];
    
    NSLog(@"[2] Get Headers %@", [self getCustomHeadersForUrl:@"https://gc-integration.netcodev.com"]);
    [customHeadersForUrl removeAllObjects];
    
    NSLog(@"<<<<<<<<<<< TEST 3 >>>>>>>>>>>>>");
    [self addCustomHeaders:@[@{@"headerKEY1" : @"headerVALUE1"}, @{@"headerKEY2" : @"headerVALUE2"}, @{@"headerKEY3" : @"headerVALUE3"}] forUlrMatchingRegEx:@"(https://gc-integration.netcodev.com)"];
    
    NSLog(@"[3] Get Headers %@", [self getCustomHeadersForUrl:@"https://nsapi-integration.netcodev.com/qdlzkjqzld/degshseh?@skjdg"]);
    
    [customHeadersForUrl removeAllObjects];
    
    NSLog(@"<<<<<<<<<<< TEST 4 >>>>>>>>>>>>>");
    [self addCustomHeaders:@[@{@"headerKEY1" : @"headerVALUE1"}, @{@"headerKEY2" : @"headerVALUE2"}, @{@"headerKEY3" : @"headerVALUE3"}] forUlrMatchingRegEx:@"(https://nsapi)*$"];
    
    NSLog(@"[3] Get Headers %@", [self getCustomHeadersForUrl:@"https://nsapi-integration.netcodev.com/qdlzkjqzld/degshseh?@skjdg"]);
    
    
    NSLog(@"<<<<<<<<<<< TEST 5 >>>>>>>>>>>>>");
    [self addCustomHeaders:@[@{@"headerKEY1" : @"headerVALUE1"}, @{@"headerKEY2" : @"headerVALUE2"}, @{@"headerKEY3" : @"headerVALUE3"}] forUlrMatchingRegEx:@"(http|https)://www.google.fr"];
    
    NSLog(@"[3] Get Headers %@", [self getCustomHeadersForUrl:@"http://www.google.fr/imgres?imgurl=http://eofdreams.com/data_images/dreams/image/image-07.jpg&imgrefurl=http://eofdreams.com/image.html&h=2188&w=3288&tbnid=dPW8Th-TxyIRCM:&zoom=1&tbnh=90&tbnw=135&usg=__5KOJ67Ou-pDO1sDkexLPVOqXqmg=&docid=V_ytHCiHhkpVLM&sa=X&ei=ElprU_y8E-iM7QaVu4DwBg&ved=0CEwQ9QEwBA&dur=220"]);
}

+(void)unitTestForEncoding{
    NSString *str = @" ";
    NSString *res = @"%20";
    NSLog(@"I : %@", str);
    str = [NSDataManager encodeString:str];
    NSLog(@"O : %@", str);
    NSLog(@"= : %@", res);
    NSLog(@"=> %@", [str isEqualToString:res] ? @"OK" : @"KO");

    str = @"!*\"'();:@&=+$,/?%#[]";
    res = @"%21*%22%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D";
    NSLog(@"I : %@", str);
    str = [NSDataManager encodeString:str];
    NSLog(@"O : %@", str);
    NSLog(@"= : %@", res);
    NSLog(@"=> %@", [str isEqualToString:res] ? @"OK" : @"KO");
    
    str = @"éàçèùô";
    res = @"%C3%A9%C3%A0%C3%A7%C3%A8%C3%B9%C3%B4";
    NSLog(@"I : %@", str);
    str = [NSDataManager encodeString:str];
    NSLog(@"O : %@", str);
    NSLog(@"= : %@", res);
    NSLog(@"=> %@", [str isEqualToString:res] ? @"OK" : @"KO");
    
    str = @"ÙÉÈÇÀÏï€<>^§€`¨ø¶«»…÷≠µπœ¬¨¡¿";
    res = @"%C3%99%C3%89%C3%88%C3%87%C3%80%C3%8F%C3%AF%E2%82%AC%3C%3E%5E%C2%A7%E2%82%AC%60%C2%A8%C3%B8%C2%B6%C2%AB%C2%BB%E2%80%A6%C3%B7%E2%89%A0%C2%B5%CF%80%C5%93%C2%AC%C2%A8%C2%A1%C2%BF";
    NSLog(@"I : %@", str);
    str = [NSDataManager encodeString:str];
    NSLog(@"O : %@", str);
    NSLog(@"= : %@", res);
    NSLog(@"=> %@", [str isEqualToString:res] ? @"OK" : @"KO");
}

//+ (NSString *)calculateSHA1FromString:(NSString *)value{
//    NSMutableString *result = [[NSMutableString alloc] init];
//    
//    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
//    NSData *stringBytes = [value dataUsingEncoding:NSUTF8StringEncoding];
//    if (CC_SHA1([stringBytes bytes], (CC_LONG)[stringBytes length], digest)){
//        for (int i = 0 ; i < CC_SHA1_DIGEST_LENGTH ; ++i){
//            [result appendFormat:@"%02x", digest[i]];
//        }
//    }
//    return [result lowercaseString];
//}

@end
