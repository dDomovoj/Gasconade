//
//  NsSnRequester.m
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnRequester.h"
#import "Extends+Libs.h"
#import "NsSnUserManager.h"
#import "NsSnConfManager.h"

@interface NsSnUserManager (Private)

-(void)setMyUser:(NsSnUserModel*)model;

@end


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

+(NSDataManager*)getInstance;

@end;



@implementation NsSnRequester

+(NsSnUserErrorValue)getError:(NSInteger)value
{
    switch (value)
    {
        case 3:
            return NsSnUserErrorValueUserNotFound;
            
        case 4:
            return NsSnUserErrorValueLoginAlreadyExist;
            
        case 5:
            return NsSnUserErrorValueNotLoggedIn;
            
        case 13:
            return NsSnUserErrorValueNoSearchParam;
            
        default:
            return NsSnUserErrorValueNone;
            break;
    }
}

+(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode))hookResponse:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb
{
    void (^chekConnexion)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode)=
    ^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
//        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"DATA : %@", strData);
        
        NSInteger error_id = [rep getXpathInteger:@"error/code"];
        NsSnUserErrorValue code = [NsSnRequester getError:error_id];
        if (cb)
            cb(rep,cache,data,httpcode,code);
    };
    return chekConnexion;
}
+(NsSnRequester*)getInstance{
    
    static NsSnRequester *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnRequester alloc] init];
    });
    return sharedMyManager;
}

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
	
//    NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:post];
    NSArray *headers = [NSDataManager genSignatureHeaders:[NsSnConfManager getInstance].NSAPI_CLIENT_ID clientSecret:[NsSnConfManager getInstance].NSAPI_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:post];
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
	
//    NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:post];
    NSArray *headers = [NSDataManager genSignatureHeaders:[NsSnConfManager getInstance].NSAPI_CLIENT_ID clientSecret:[NsSnConfManager getInstance].NSAPI_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:post];
	return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:cb_rcv cb_rep:[NsSnRequester hookResponse:cb_rep] credential:nil cache:cache];
}

+(id)request:(NSString *)url
	  cb_rcv:(void (^)(long long total , long long current))cb_rcv
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
	   cache:(BOOL)cache{
	
//    NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:nil];
    NSArray *headers = [NSDataManager genSignatureHeaders:[NsSnConfManager getInstance].NSAPI_CLIENT_ID clientSecret:[NsSnConfManager getInstance].NSAPI_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:nil];
    
	return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:nil cb_send:^(long long total, long long current) {
		
	} cb_rcv:cb_rcv cb_rep:[NsSnRequester hookResponse:cb_rep] credential:nil cache:cache];
}

+(id)request:(NSString *)url
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
	   cache:(BOOL)cache{
	
//    NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:nil];
    NSArray *headers = [NSDataManager genSignatureHeaders:[NsSnConfManager getInstance].NSAPI_CLIENT_ID clientSecret:[NsSnConfManager getInstance].NSAPI_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:nil];
    
	return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:nil cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:[NsSnRequester hookResponse:cb_rep] credential:nil cache:cache];
}

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
	   cache:(BOOL)cache{
	
//    NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:post];
    NSArray *headers = [NSDataManager genSignatureHeaders:[NsSnConfManager getInstance].NSAPI_CLIENT_ID clientSecret:[NsSnConfManager getInstance].NSAPI_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:post];
    
	return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:[NsSnRequester hookResponse:cb_rep] credential:nil cache:cache];
}

+(id)request:(NSString *)url
		post:(NSDictionary*)post
	  cb_rep:(void (^)(NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode,NsSnUserErrorValue error))cb_rep
  credential:(NSDictionary*)credential
	   cache:(BOOL)cache{
	
//    NSArray *headers = [NSDataManager generateHeadersFromUrl:url queryParams:nil andPostParams:post];
    NSArray *headers = [NSDataManager genSignatureHeaders:[NsSnConfManager getInstance].NSAPI_CLIENT_ID clientSecret:[NsSnConfManager getInstance].NSAPI_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:post];
    
	return [[NsSnRequester getInstance] request:url headers:headers autovarspost:NO post:post cb_send:^(long long total, long long current) {
		
	} cb_rcv:^(long long total, long long current) {
		
	} cb_rep:[NsSnRequester hookResponse:cb_rep] credential:credential cache:cache];
}





@end
