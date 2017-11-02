//
//  NSNetcoRequest.m
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSNetcoRequest.h"
#import "CDataScanner.h"
#import "CJSONScanner.h"
#import "UIMasterApplication.h"
#import "NSObject+NSObject_File.h"
#import "NSObject+NSObject_Xpath.h"
#import "NSObject+NSObject_Tool.h"
#import "NSString+NSString_File.h"
#import "NSString+NSString_Tool.h"
#import "UIDevice+UIDevice_Tool.h"
#import "NSDictionary+NSDictionary_File.h"
#import "BridgedLanguageManager.h"

//#import <FormatterKit/TTTURLRequestFormatter.h>

static NSString* remote_url = @"www.thefanclub.com";
static NSString* kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";



#ifndef NETCO_REQUEST_TTL
#define NETCO_REQUEST_TTL 10*60
#endif


@implementation NSNetcoRequest


-(id)init{
    self = [super init];
    if(self){
        json_parse_ctype_exceptions = @[@"application/pdf"];
        httpStatusCode = 0;
    }
    return self;
}

+(NSString*)generateUrl:(NSString*)_url{
	NSString *myurl = @"";
	if (![_url isSubString:@"http://"] && ![_url isSubString:@"https://"] )
		myurl = [NSString stringWithFormat:@"http://%@%@.ijson",remote_url,_url];
	else
		myurl = [NSString stringWithFormat:@"%@",_url];
	
	if ([_url rangeOfString:@"users/login" options:NSCaseInsensitiveSearch].location != NSNotFound && ![_url isSubString:@"http://"] && ![_url isSubString:@"https://"] )
		myurl = [NSString stringWithFormat:@"http://%@%@",remote_url,_url];
	
	_url = myurl;
	
	return _url;
}
-(void)request:(NSString *)url
       headers:(NSArray*)headers
  autovarspost:(BOOL)autovarspost
		  post:(NSDictionary*)post
	   cb_send:(void (^)(long long total , long long current))cb_send
		cb_rcv:(void (^)(long long total , long long current))cb_rcv
        cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
	credential:(NSDictionary*)credential
		 cache:(BOOL)cache{
	
	_url = url;
	_urlOrigine = url;
	_cache = cache;
	_headers = headers;
	_autovarspost = autovarspost;
	_cb_rcv = cb_rcv;
	_cb_send = cb_send;
	_cb_rep = cb_rep;
    _originalPost = post;
	_postData = [post ToMutable];
	
	_url = [NSNetcoRequest generateUrl:_url];
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"URL (cache : %d) => %@", cache, _url);
#endif
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
    
	if (_postData){
		// generate post request
		[request setHTTPMethod:@"POST"];
		NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
		[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
		if (_postData[@"X-Requested-With"]){
			[request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
			[_postData removeObjectForKey:@"X-Requested-With"];
		}
		[request setHTTPBody:[self generatePostBody]];
	}
    if (_headers)
    {
        for (NSDictionary *header in _headers)
        {
            NSArray *keys = [header allKeys];
            NSString *key = [keys count] ? [keys objectAtIndex:0] : nil;
            
            if (key)
            {
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
    }
	if(_cache){
        [NSObject backGroundBlock:^{
            NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:_urlOrigine];
            [NSObject mainThreadBlock:^{
                if(_cb_rep)
                    _cb_rep(theDictionary, true, nil, httpStatusCode);
            }];
        }];
	}
    
//    NSLog(@"curl = %@", [TTTURLRequestFormatter cURLCommandFromURLRequest:request]);

	_credential = credential;
	connexion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connexion start];
}

-(void)request:(NSString *)url
       headers:(NSArray*)headers
  autovarspost:(BOOL)autovarspost
		  post:(NSData*)post
    postLength:(NSString *) postLength
	   cb_send:(void (^)(long long total , long long current))cb_send
		cb_rcv:(void (^)(long long total , long long current))cb_rcv
        cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
	credential:(NSDictionary*)credential
		 cache:(BOOL)cache{
	
	_url = url;
	_urlOrigine = url;
	_cache = cache;
	_headers = headers;
	_autovarspost = autovarspost;
	_cb_rcv = cb_rcv;
	_cb_send = cb_send;
	_cb_rep = cb_rep;
	_postData = [post ToMutable];
	
	
	_url = [NSNetcoRequest generateUrl:_url];
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"URL (cache : %d) => %@", cache, _url);
#endif
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
    
	if (_postData){
		// generate post request
		[request setHTTPMethod:@"POST"];
		NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
		[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:post];
	}
    if (_headers)
    {
        for (NSDictionary *header in _headers)
        {
            NSArray *keys = [header allKeys];
            NSString *key = [keys count] ? [keys objectAtIndex:0] : nil;
            
            if (key)
            {
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
    }
	if(_cache){
        [NSObject backGroundBlock:^{
            NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:_urlOrigine];
            [NSObject mainThreadBlock:^{
                if (_cb_rep)
                    _cb_rep(theDictionary, true, nil, httpStatusCode);
            }];
        }];
	}
	_credential = credential;
	connexion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connexion start];
}

-(void)requestDelete:(NSString *)url
             headers:(NSArray*)headers
             cb_send:(void (^)(long long total , long long current))cb_send
              cb_rcv:(void (^)(long long total , long long current))cb_rcv
              cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
          credential:(NSDictionary*)credential
               cache:(BOOL)cache{
	
	_url = url;
	_urlOrigine = url;
	_cache = cache;
	_headers = headers;
	_cb_rcv = cb_rcv;
	_cb_send = cb_send;
	_cb_rep = cb_rep;
	
	_url = [NSNetcoRequest generateUrl:_url];
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"URL (cache : %d) => %@", cache, _url);
#endif
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
    // generate DELETE request
    
    [request setHTTPMethod:@"DELETE"];
    //    NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
    //    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPBody:[self generatePostBody]];
    
    if (_headers)
    {
        for (NSDictionary *header in _headers)
        {
            NSArray *keys = [header allKeys];
            NSString *key = [keys count] ? [keys objectAtIndex:0] : nil;
            
            if (key)
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
	if (_cache)
    {
        [NSObject backGroundBlock:^{
            NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:_urlOrigine];
            [NSObject mainThreadBlock:^{
                if (_cb_rep)
                    _cb_rep(theDictionary, true, nil, httpStatusCode);
            }];
        }];
	}
	_credential = credential;
	connexion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connexion start];
}

-(void)requestPut:(NSString *)url
          headers:(NSArray*)headers
     autovarspost:(BOOL)autovarspost
             post:(NSDictionary*)post
          cb_send:(void (^)(long long total , long long current))cb_send
           cb_rcv:(void (^)(long long total , long long current))cb_rcv
           cb_rep:(void (^)(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode))cb_rep
       credential:(NSDictionary*)credential
            cache:(BOOL)cache
{
	_url = url;
	_urlOrigine = url;
	_cache = cache;
	_headers = headers;
	_autovarspost = autovarspost;
	_cb_rcv = cb_rcv;
	_cb_send = cb_send;
	_cb_rep = cb_rep;
    _originalPost = post;
	_postData = [post ToMutable];
    
	_url = [NSNetcoRequest generateUrl:_url];
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"URL (cache : %d) => %@", cache, _url);
#endif
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
    
	if (_postData){
		// generate post request
		[request setHTTPMethod:@"PUT"];
		NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
		[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
		if (_postData[@"X-Requested-With"]){
			[request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
			[_postData removeObjectForKey:@"X-Requested-With"];
		}
		[request setHTTPBody:[self generatePostBody]];
	}
    if (_headers)
    {
        for (NSDictionary *header in _headers)
        {
            NSArray *keys = [header allKeys];
            NSString *key = [keys count] ? [keys objectAtIndex:0] : nil;
            
            if (key)
            {
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
    }
	if(_cache){
        [NSObject backGroundBlock:^{
            NSDictionary *theDictionary = [NSNetcoRequest getCacheValue:_urlOrigine];
            [NSObject mainThreadBlock:^{
                if (_cb_rep)
                    _cb_rep(theDictionary, true, nil, httpStatusCode);
            }];
        }];
	}
	_credential = credential;
	connexion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connexion start];
}

- (NSMutableData*)generatePostBody {
	NSMutableData* body = [NSMutableData data];
	NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
	NSString *endBody = [NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary];
	NSString *idu = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
	NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
	
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
					  dataUsingEncoding:NSUTF8StringEncoding]];
	
    if (_autovarspost){
        _postData[@"ijson"] = @"ijson";
        
        if (_postData[@"Apps_lang[apps_lng_iso2]"] == nil)
            _postData[@"Apps_lang[apps_lng_iso2]"] = [BridgedLanguageManager applicationLanguage];
        
        _postData[@"data[Devices][version]"] = [[UIDevice currentDevice] systemVersion];
        _postData[@"data[Devices][model]"] = [[UIDevice currentDevice] model];
        _postData[@"data[Devices][u_key]"] = idu;
        _postData[@"data[Applis][u_key]"] = bundle;
    }
    
    
    
    NSMutableArray *untypedDatasList = [[NSMutableArray alloc] initWithArray:[_postData getXpathNilArray:@"datas_with_content_type"]];
    
    for (id key in [_postData keyEnumerator]) {
        if (![_postData[key] isKindOfClass:[UIImage class]] && ![_postData[key] isKindOfClass:[NSData class]] && ![_postData[key] isKindOfClass:[NSArray class]]) {
			id obj = [_postData valueForKey:key];
			if ([obj isKindOfClass:[NSNumber class]])
				obj = [obj description];
            
            [untypedDatasList addObject:@{@"name": key, @"datas": [obj dataUsingEncoding:NSUTF8StringEncoding],@"DEBUG_INFO":obj}];
        }
		else if ([_postData[key] isKindOfClass:[UIImage class]]) {
			UIImage *image = _postData[key];
			NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            
            [untypedDatasList addObject:@{@"name": key, @"content_type": @"image/jpeg", @"datas": imageData}];
        }
		else if ([_postData[key] isKindOfClass:[NSData class]]) {
			NSData *videoData = _postData[key];
            
            [untypedDatasList addObject:@{@"name": key, @"content_type": @"video/quicktime", @"datas": videoData}];
        }
    }
    
    int i = 0;
    if (untypedDatasList){
        for (NSDictionary *datas_untyped in untypedDatasList){
            
            NSString *name = [datas_untyped getXpathEmptyString:@"name"];
            NSString *content_type = [datas_untyped getXpathEmptyString:@"content_type"];
            NSData *datas = [datas_untyped getXpath:@"datas" type:[NSData class] def:nil];
            
            if ([content_type isEqualToString:@""]){
                //                NSLog(@"POST : %@ => %@",name,datas_untyped[@"DEBUG_INFO"]);
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else if ([content_type isEqualToString:@"image/jpeg"]){
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"photo.jpg\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else if ([content_type isEqualToString:@"video/quicktime"]){
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"video.mov\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else if ([content_type isEqualToString:@"text/plain"]){
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"datas.txt\"; charset=\"UTF-8\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            if ([content_type length] > 0){
                [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", content_type] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            [body appendData:datas];
            
            [body appendData:[((i < [untypedDatasList count] - 1) ? endLine : endBody) dataUsingEncoding:NSUTF8StringEncoding]];
            i++;
        }
    }
	
    
    
    //    BOOL haveMedias = NO;
    //    for (id key in [_postData keyEnumerator]) {
    //		if ([_postData[key] isKindOfClass:[UIImage class]]) {
    //            haveMedias = YES;
    //        }
    //    }
    //
    //    NSMutableDictionary *postImages = [@{} ToMutable];
    //    NSMutableDictionary *postVars = [@{} ToMutable];
    //    NSMutableDictionary *postDatas = [@{} ToMutable];
    //
    //    for (id key in [_postData keyEnumerator]) {
    //        if ([_postData[key] isKindOfClass:[NSArray class]] && [key isEqualToString:@"datas_with_content_type"]){
    //            [postDatas setObject:_postData[key] forKey:key];
    //        }
    //        else if (![_postData[key] isKindOfClass:[UIImage class]] && ![_postData[key] isKindOfClass:[NSData class]] && ![_postData[key] isKindOfClass:[NSArray class]]) {
    //            [postVars setObject:_postData[key] forKey:key];
    //        }
    //        else{
    //            [postImages setObject:_postData[key] forKey:key];
    //        }
    //    }
    //
    //    int i = 0;
    //	for (id key in [postVars keyEnumerator]) {
    //		if (![postVars[key] isKindOfClass:[UIImage class]] && ![postVars[key] isKindOfClass:[NSData class]]) {
    //
    //			id obj = [postVars valueForKey:key];
    //			if ([obj isKindOfClass:[NSNumber class]])
    //				obj = [obj description];
    //			[body appendData:[[NSString
    //							   stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
    //							  dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //			[body appendData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //            if (i != [postVars count] - 1){
    //                [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
    //			}
    //			NSLog(@"POST : %@ => %@",key,obj);
    //		}
    //
    //        if (i == [postVars count] - 1 && !haveMedias && !haveUntypedDatas){
    //			[body appendData:[endBody dataUsingEncoding:NSUTF8StringEncoding]];
    //        }
    //        else if (i == [postVars count] - 1 && (haveMedias || haveUntypedDatas)){
    //			[body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
    //        }
    //        i++;
    //	}
    //
    //    i = 0;
    //	for (id key in [postImages keyEnumerator]) {
    //		if ([postImages[key] isKindOfClass:[UIImage class]]) {
    //			UIImage* image = postImages[key];
    //			NSData* imageData = UIImageJPEGRepresentation(image, 0.75);
    //
    //
    //			[body appendData:[[NSString
    //							   stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"photo.jpg\"\r\n",key]
    //							  dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //			[body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //			[body appendData:imageData];
    //			//[body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
    //		}
    //        else if ([postImages[key] isKindOfClass:[NSData class]]) {
    //			NSData* videoData = postImages[key];
    //
    //
    //			[body appendData:[[NSString
    //							   stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"video.mov\"\r\n",key]
    //							  dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //			[body appendData:[@"Content-Type: video/quicktime\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //			[body appendData:videoData];
    //			//[body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
    //		}
    //
    //        if (i == [postImages count] - 1 && !haveUntypedDatas){
    //			[body appendData:[endBody dataUsingEncoding:NSUTF8StringEncoding]];
    //        }
    //        else if (i != [postImages count] - 1){
    //            [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
    //        }
    //        i++;
    //	}
    //
    //
    //    for (id key in [_postData keyEnumerator]) {
    //
    //    }
    //
    //    i = 0;
    //    if (untypedDatasList){
    //        for (NSDictionary *datas_untyped in untypedDatasList){
    //
    //            NSString *name = [datas_untyped getXpathEmptyString:@"name"];
    //            NSString *content_type = [datas_untyped getXpathEmptyString:@"content_type"];
    //            NSData *datas = [datas_untyped getXpath:@"datas" type:[NSData class] def:nil];
    //
    //            if ([content_type isEqualToString:@""]){
    //
    //            }
    //            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"datas.txt\"; charset=\"UTF-8\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", content_type] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //            [body appendData:datas];
    //
    //            if (i != [untypedDatasList count] - 1){
    //                [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
    //            }
    //            if (i == [untypedDatasList count] - 1){
    //                [body appendData:[endBody dataUsingEncoding:NSUTF8StringEncoding]];
    //            }
    //            i++;
    //        }
    //    }
    
    
    
    
    //    NSString *myString = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
    //    NSLog(@"BODY POST : %@", myString);
    
	return body;
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"ERROR");
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if (_credential[@"callback"]){
		void (^callback)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) = _credential[@"callback"];
		if (callback)
			callback(connection,challenge);
		return;
	}
	if ([challenge previousFailureCount] == 0 && ![challenge proposedCredential]) {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:[_credential getXpathEmptyString:@"user"] password:[_credential getXpathEmptyString:@"password"]
															  persistence:NSURLCredentialPersistenceForSession];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
	}
}
//Fonction permettant de voir si il s’agit de l’authentification cliente ou serveur
-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]
			|| [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]);
}



- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)responsedata {
	_reponse = [[NSMutableData alloc] init];
	total = [responsedata expectedContentLength];
    r_headers = [((NSHTTPURLResponse*)responsedata) allHeaderFields];
	recived = [_reponse length];
	httpStatusCode = [((NSHTTPURLResponse*)responsedata) statusCode];
	if(_cb_rcv)
		[NSObject mainThreadBlock:^{
			_cb_rcv(total,recived);
		}];
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
	[_reponse appendData:data];
	recived = [_reponse length];
	if(_cb_rcv)
		[NSObject mainThreadBlock:^{
			_cb_rcv(total,recived);
		}];
}
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	long long r = totalBytesWritten ;
	long long t = totalBytesExpectedToWrite;
	if(_cb_send)
		[NSObject mainThreadBlock:^{
			_cb_send(t,r);
		}];
	
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
	[NSObject backGroundBlockDownload:^{
		CJSONScanner *theScanner = nil;
		NSDictionary *theDictionary = nil;
		NSError *e = nil;
		
        NSString *s;
        
#if TARGET_IPHONE_SIMULATOR
        s = [[NSString alloc] initWithData:_reponse encoding:NSUTF8StringEncoding];
        // NSLog(@"%@",s);
#endif
		if ([s isSubString:@"class=\"cake-debug\""]){
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
			NSLog(@"/*********************************ERROR*********************************/");
			NSLog(@"/*********************************ERROR  %@",_url);
			NSLog(@"%@",s);
		}
		//NSLog(@"%@",s);
#if TARGET_IPHONE_SIMULATOR
		//NSLog(@"%@",s);
#endif
        if (![json_parse_ctype_exceptions containsObject:[r_headers getXpathEmptyString:@"Content-Type"]]){
            if ([_reponse length])
                theScanner = [[CJSONScanner alloc] initWithData:_reponse];
            
            if (![_reponse length] || [theScanner scanJSONDictionary:&theDictionary error:&e] != YES){
                theDictionary = [[NSDictionary alloc] init];
            } else{
                theDictionary = [[NSDictionary alloc] initWithDictionary:theDictionary];
                [NSObject backGroundBlock:^{
                    NSString *s = [NSNetcoRequest generateUrl:_urlOrigine];
                    [theDictionary setDataSaveNSDictionaryCache:[s md5]];
                }];
            }
        }
		
		[NSObject mainThreadBlock:^{
			_cb_rep(theDictionary, false, _reponse, httpStatusCode);
			_cb_rep = nil;
		}];
	}];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [NSObject backGroundBlock:^{
        
        
        NSDictionary *theDictionary = nil;
        if (!_originalPost || ![[_originalPost allKeys] count])
            theDictionary = [NSNetcoRequest getCacheValue:_urlOrigine];
        
        [NSObject mainThreadBlock:^{
            if (_cb_rep)
                _cb_rep(theDictionary, false, nil, httpStatusCode);
            _cb_rep = nil;
        }];
    }];
}


+(id)getCacheValue:(NSString *)url{
	url = [NSNetcoRequest generateUrl:url];
	return [NSDictionary getDataFromFileCache:[url md5] temps:(NETCO_REQUEST_TTL) del:NO];
}
+(void)removeCache:(NSString*)url{
	url = [NSNetcoRequest generateUrl:url];
	[NSObject removeFileCache:[url md5]];
}

-(void)dealloc{
	//NSLog(@"Dealloc url :%@ %@",_url,[self description]);
}

@end
