//
//  UIMasterApplication.m
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UIMasterApplication.h"
#import "CDataScanner.h"
#import "CJSONScanner.h"
#import "NSDataManager.h"
#import "OLGhostAlertView.h"
#import "NSObject+NSObject_File.h"
#import "NSObject+NSObject_Xpath.h"
#import "NSObject+NSObject_Tool.h"
#import "NSString+NSString_File.h"
#import "NSString+NSString_Tool.h"
#import "NSDictionary+NSDictionary_File.h"
#import "UIDevice+UIDevice_Tool.h"
#import "GCPlatformConnection.h"

#define AUTO_REFRESH_GET_VERSION 60

#ifndef SHOW_NO_CONNEXION_ALERT
#define SHOW_NO_CONNEXION_ALERT NO
#endif

#ifndef BASE_URL
#define BASE_URL @"http://www.thefanclub.com"
#endif


// -- New API

#ifndef USE_NEW_NSAPI_SERVICES
#define USE_NEW_NSAPI_SERVICES NO
#endif

// --



//__strong static UIMasterApplication *UIMasterApplication_instance = nil;
@implementation UIMasterApplication
@synthesize token;
@synthesize pushData;
@synthesize hasAlreadyAskForApnsToken;

-(id)init{
	self = [super init];
    if (self) {
        // Initialization code
        hasAlreadyAskForApnsToken = NO;
        self.show_alert = YES;
		self.autoReload = YES;
		self.versionURL = nil;
        token = nil;
		NSString* filePath = [[NSBundle mainBundle] pathForResource:@"init_conf" ofType:@"ijson"];
		NSError *e = nil;
		NSData *data = nil;
		if(filePath)
			data = [NSData dataWithContentsOfFile:filePath options:(NSDataReadingMappedIfSafe) error:&e];
		CJSONScanner *theScanner = nil;
		NSDictionary *theDictionary = nil;
 		if ([data length])
			theScanner = [[CJSONScanner alloc] initWithData:data];
		if (![data length] || [theScanner scanJSONDictionary:&theDictionary error:&e] != YES){
			NSLog(@"%@", @"Pas de fichier de conf");
		}else{
 			theDictionary = [[NSDictionary alloc] initWithDictionary:theDictionary];
			if (!_conf){
				NSLog(@"%@", @"Fichier de conf");
				_conf = theDictionary;
			}
            
		}
		theDictionary = [NSDictionary getDataFromFile:@"init_conf.ijson" temps:(3*365*24*60*60)];
		if (theDictionary){
			_conf = theDictionary;
		}
		type_of_net = 0;
		old_type_of_net = -1;
		// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
		// method "reachabilityChanged" will be called.
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
		
		//Change the host name here to change the server your monitoring
		hostReach = [Reachability reachabilityWithHostname:@"www.netcosports.com"];
		[hostReach startNotifier];
		[self updateInterfaceWithReachability: hostReach];
		
		internetReach = [Reachability reachabilityForInternetConnection];
		[internetReach startNotifier];
		[self updateInterfaceWithReachability: internetReach];
		
		wifiReach = [Reachability reachabilityForLocalWiFi];
		[wifiReach startNotifier];
		[self updateInterfaceWithReachability: wifiReach];
 		// get Reachablility
    }
    return self;
}


+(UIMasterApplication*)getInstance{
    static UIMasterApplication *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIMasterApplication alloc] init];
    });
    return sharedInstance;
    //	if (!UIMasterApplication_instance)
    //		UIMasterApplication_instance = [[UIMasterApplication alloc] init];
    //
    //	return UIMasterApplication_instance;
}
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
		[self configureTextField:&host_type  reachability: curReach];
    }
	if(curReach == internetReach)
	{
		[self configureTextField:&internet_type  reachability: curReach];
	}
	if(curReach == wifiReach)
	{
		[self configureTextField:&wifi_type  reachability: curReach];
	}
	
	if(wifi_type >= 1 && internet_type >= 1 && host_type >= 1){
		type_of_net = 2;
	}else if (wifi_type == 0 && (internet_type >= 1 || host_type >= 1)){
		type_of_net = 1;
	}else if(wifi_type == 0 && internet_type == 0 && host_type == 0){
		type_of_net = 0;
	}else {
		type_of_net = 0;
	}
    NSLog(@"type of net %d",type_of_net);
	[self displayAlert];
}

-(void)displayAlert{
	if((old_type_of_net >= -1 || old_type_of_net > -3) && old_type_of_net < 0) {
		// first step
		old_type_of_net--;
		return;
	}
	
	if(old_type_of_net <= -3){
		// first step
		old_type_of_net = type_of_net;
		return;
	}
    
	if(type_of_net >= 1 && old_type_of_net == 0){
		// net
		if (type_of_net == 2){
			// wifi
			//[self setFlashMessage:NSLocalizedString(@"Connexion Wifi", @"")];
		}else{
			// carrer
			//[self setFlashMessage:NSLocalizedString(@"Connexion 3G", @"")];
		}
	}else if (type_of_net == 0 && old_type_of_net >= 1 && self.show_alert && SHOW_NO_CONNEXION_ALERT){
		// plus de net
		[self setFlashMessage:NSLocalizedString(@"Connectez-vous à internet pour mettre à jour les données de l'application", @"")];
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:@"typeOfNetChanged" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:old_type_of_net], @"old_type_net", [NSNumber numberWithInt:type_of_net], @"type_of_net", nil]];
	old_type_of_net = type_of_net;
}
- (void) configureTextField:(int*)status  reachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
			(*status) = 0;
            break;
        }
            
        case ReachableViaWWAN:
        {
			(*status) = 1;
            break;
        }
        case ReachableViaWiFi:
        {
			(*status) = 2;
            break;
		}
    }
}

-(void)askForRegisterApns:(void (^)(BOOL ok))cb_push{
	if (token){
		cb_push(YES);
		return;
	}
	callback_push = cb_push;
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    #endif
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
    
    if (TARGET_IPHONE_SIMULATOR){
        timer_alerte = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(ErrorAlert:) userInfo:nil repeats:NO];
    }
    hasAlreadyAskForApnsToken = YES;
}

-(void)saveToken:(NSString *)token_apps withTreatment:(BOOL)isNewFormat{
    if (token_apps && isNewFormat){
        NSString *dt = [token_apps stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token_apps = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if (!token || token_apps){
        token = token_apps;
    }

    if (token){
        NSLog(@"My TokenID =+=+=+=+=+=+=+=> %@", token);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TokenFound" object:token_apps];
    }
}

-(void)registerToken:(NSString *)token_apps{
    [self saveToken:token_apps withTreatment:YES];
    
    if (callback_push)
        callback_push(!!token);
	callback_push = nil;
	[timer_alerte invalidate];
	timer_alerte = nil;
    
    if (token){
        NSString *baseUrl = BASE_URL;
        
        if (USE_NEW_NSAPI_SERVICES){
            baseUrl = NSSN_API_URL;
            
            NSString *app_bundle = [[NSBundle mainBundle] bundleIdentifier];
            NSString *device_uid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
            
            NSDictionary *d = @{
                                @"token" : token,
                                @"lang" : [NSObject getLangName],
                                @"bundle" : app_bundle,
                                @"device_uid" : device_uid,
                                @"platform_type" : @"ios",
                                };
            NSString *url = [NSString stringWithFormat:@"%@/api/%@/applications/_/register_notification_token", baseUrl, NSSN_API_VERSION];
            NSArray *headers = [NSDataManager genSignatureHeaders:NSSN_API_CLIENT_ID clientSecret:NSSN_API_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:d];

            [NSDataManager request:url headers:headers autovarspost:NO post:d cb_send:^(long long total, long long current) {
                
            } cb_rcv:^(long long total, long long current) {
                
            } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
                
            } credential:nil cache:NO];
        }
        else{
            NSDictionary *d = @{
                                @"data[os_id]" : @1,
                                @"data[alert_token]" : token,
                                @"data[Applis][u_key]" : [[NSBundle mainBundle] bundleIdentifier],
                                };
            NSString *url = [NSString stringWithFormat:@"%@/alerte/rtlnews.ijson", baseUrl];
            [NSDataManager request:url post:d cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data) {
            } cache:NO];
        }
    }
}

-(void)ErrorAlert:(id)sender{
	[timer_alerte invalidate];
	timer_alerte = nil;
	UIAlertView *a =  [[UIAlertView alloc] initWithTitle:@"Error notification" message:@"Not completly implemented" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
	[a show];
}

-(void)setDataPushCallback:(NSDictionary*)d{
    self.pushData = d;
    if(callback_push_data){
        callback_push_data(pushData);
        pushData = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataPushNotification" object:nil];
}

-(void)reciveNotificationPush:(void (^)(NSDictionary *data))cb{
    callback_push_data = [cb copy];
    if(self.pushData){
        [self performWithDelay:0.5 block:^{
            callback_push_data(pushData);
            pushData = nil;
        }];
    }
}

+(NSDictionary*)jsonFromData:(NSData*)data{
	NSError *e = nil;
	CJSONScanner *theScanner = nil;
	NSDictionary *theDictionary = nil;
	if ([data length])
		theScanner = [[CJSONScanner alloc] initWithData:data];
	if (![data length] || [theScanner scanJSONDictionary:&theDictionary error:&e] != YES){
		NSLog(@"error " );
	}else{
		theDictionary = [[NSDictionary alloc] initWithDictionary:theDictionary];
		return theDictionary;
	}
	return @{};
}
+(NSDictionary*)getDataFromFile:(NSString*)fileBundle ext:(NSString*)ext{
	NSString* filePath = [[NSBundle mainBundle] pathForResource:fileBundle ofType:ext];
	NSError *e = nil;
	NSData *data = [NSData dataWithContentsOfFile:filePath options:(NSDataReadingMappedIfSafe) error:&e];
	CJSONScanner *theScanner = nil;
	NSDictionary *theDictionary = nil;
	if ([data length])
		theScanner = [[CJSONScanner alloc] initWithData:data];
	if (![data length] || [theScanner scanJSONDictionary:&theDictionary error:&e] != YES){
		NSLog(@"Pas de fichier: %@.%@",fileBundle,ext );
	}else{
		theDictionary = [[NSDictionary alloc] initWithDictionary:theDictionary];
		return theDictionary ;
	}
	return @{};
}



-(void)rep:(NSDictionary*)rep{

	if ([[rep getXpathEmptyString:@"feeds/min_version"] isNotEqualToString:@""]){
		_conf = rep;
	}
    if (USE_NEW_NSAPI_SERVICES){
        if ([[rep getXpathEmptyString:@"application/min_version"] isNotEqualToString:@""]){
            _conf = rep ;
        }
    }
	NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
	NSString *min_version = [_conf getXpathEmptyString:@"feeds/min_version"];
	NSString *current_version = [_conf getXpathEmptyString:@"feeds/current_version"];
    
	if (USE_NEW_NSAPI_SERVICES){
        min_version = [_conf getXpathEmptyString:@"application/min_version"];
        current_version = [_conf getXpathEmptyString:@"application/current_version"];
    }
	
//	BOOL available = version >= min_version;
//	BOOL newVersion = version < current_version;
    
//	BOOL mustUpdate = version < min_version;
//	BOOL versionAvailable = version < current_version;

    
    BOOL available = ![self isFirstString:version lowerThanSecond:min_version];
    BOOL newVersion = [self isFirstString:version lowerThanSecond:current_version];

//    [self uniqueTestForVersions];
    
	if (reponse_version)
		reponse_version(newVersion, available);
}

-(BOOL)isFirstString:(NSString *)firstStr lowerThanSecond:(NSString *)secondStr{
    if ([firstStr isKindOfClass:[NSString class]] && [firstStr length] > 0 && [secondStr isKindOfClass:[NSString class]] && [secondStr length] > 0){
        NSArray *firstAr = [firstStr explode:@"."];
        NSArray *secondAr = [secondStr explode:@"."];
        
        NSInteger maxCpt = [firstAr count] > [secondAr count] ? [firstAr count] : [secondAr count];
        
        for (int i = 0; i < maxCpt; i++){
            if ([firstAr[i] floatValue] == [secondAr[i] floatValue]){
                if ([firstAr count] == 1 && [secondAr count] == 1){
                    return NO;
                }
                if ([firstAr count] < [secondAr count]) {
                    firstStr = [NSString stringWithFormat:@"%@.0", firstStr];
                }
                else if ([firstAr count] > [secondAr count]) {
                    secondStr = [NSString stringWithFormat:@"%@.0", secondStr];
                }
                if ([firstAr[i] length] + 1 < [firstStr length]){
                    firstStr = [firstStr substringFromIndex:[firstAr[i] length] + 1];
                }
                if ([secondAr[i] length] + 1 < [secondStr length]){
                    secondStr = [secondStr substringFromIndex:[secondAr[i] length] + 1];
                }
                return [self isFirstString:firstStr lowerThanSecond:secondStr];
            }
            else if ([firstAr[i] floatValue] > [secondAr[i] floatValue]) {
                return NO;
            }
            else {
                return YES;
            }
        }
    }
    return NO;
}

-(void)autoReloadConf:(NSTimer*)timer{
	[self isVersionAvailable:nil];
}

-(void)isVersionAvailable:(void (^)(BOOL newversion, BOOL Available ))bloc{
	reponse_version = bloc;
	__weak UIMasterApplication *selff = self;

    NSString *baseUrl = BASE_URL;
	NSString *url = [NSString stringWithFormat:@"%@/Applications/Config/%@/%@.ijson", baseUrl, [[NSBundle mainBundle] bundleIdentifier], [NSObject getLangName]];
    
    if (USE_NEW_NSAPI_SERVICES){
        baseUrl = NSSN_API_URL;
        url = [NSString stringWithFormat:@"%@/api/%@/applications/_/version", baseUrl, NSSN_API_VERSION];
        if (self.versionURL)
            url = self.versionURL;
        
        NSString *app_bundle = [[NSBundle mainBundle] bundleIdentifier];
        
        NSDictionary *d = @{
                            @"lang" : [NSObject getLangName],
                            @"bundle" : app_bundle,
                            @"platform_type" : @"ios",
                            };
        NSArray *headers = [NSDataManager genSignatureHeaders:NSSN_API_CLIENT_ID clientSecret:NSSN_API_CLIENT_SECRET forUrl:url withQueryParams:nil andPostParams:d];
        
        [NSDataManager request:url headers:headers autovarspost:NO post:d cb_send:^(long long total, long long current) {

        } cb_rcv:^(long long total, long long current) {
        
        } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode) {
            if (cache){
                if (rep)
                    [selff rep:rep];
            }else{
                if(rep)
                    [selff rep:rep];
                else{
                    // pas de net
                }
                // save in cache
                
                // reload timer
                if (self.autoReload)
                    [NSTimer scheduledTimerWithTimeInterval:AUTO_REFRESH_GET_VERSION target:self selector:@selector(autoReloadConf:) userInfo:nil repeats:NO];
            }
        } credential:nil cache:NO];
    }
    else {
        if (self.versionURL)
            url = self.versionURL;
        [NSDataManager request:url cb_rcv:^(long long total, long long current) {
            
        } cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data) {
            if (cache){
                if (rep)
                    [selff rep:rep];
            }else{
                if(rep)
                    [selff rep:rep];
                else{
                    // pas de net
                }
                // save in cache
                
                // reload timer
                if (self.autoReload)
                    [NSTimer scheduledTimerWithTimeInterval:AUTO_REFRESH_GET_VERSION target:self selector:@selector(autoReloadConf:) userInfo:nil repeats:NO];
            }
        } cache:NO];
    }
}

-(void)isVersionAvailableAuto:(void (^)(BOOL newVersion, BOOL available))bloc{
	__weak UIMasterApplication *selff = self;
	[[UIMasterApplication getInstance] isVersionAvailable:^(BOOL newVersion, BOOL available) {
		if (bloc)
			bloc(newVersion, available);
        
		if (!available){
			UIAlertView *a =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mise à jour", @"") message:NSLocalizedString(@"Une mise à jour est obligatoire", @"") delegate:selff cancelButtonTitle:NSLocalizedString(@"Mettre à jour", @"") otherButtonTitles: nil];
			[a show];
			return ;
		}
		if (newVersion){
			UIAlertView *a =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mise à jour", @"") message:NSLocalizedString(@"Une mise à jour est disponible", @"") delegate:selff cancelButtonTitle:NSLocalizedString(@"Mettre à jour", @"") otherButtonTitles: NSLocalizedString(@"Passer", @""),nil];
			[a show];
			return;
		}
	}];
}

-(NSString *)getURlUpdate{
	return USE_NEW_NSAPI_SERVICES ? [_conf getXpathEmptyString:@"application/update_url"] : [_conf getXpathEmptyString:@"feeds/url_update"];
}

-(int)getTimeStamp{
	NSTimeZone *tz = [NSTimeZone defaultTimeZone];
	NSInteger r = [tz secondsFromGMT];
	NSDate *d = [NSDate dateWithTimeIntervalSinceNow:r];
	return [d timeIntervalSince1970];
}


-(id)getObjectForKey:(NSString*)key{
	return [_conf getXpath:key type:[NSObject class] def:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *titre = [alertView buttonTitleAtIndex:buttonIndex];
	if ([titre isEqualToString:NSLocalizedString(@"Mettre à jour", @"")]){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[UIMasterApplication getInstance] getURlUpdate]]];
	}
}
-(int)isTypeOfNet{
	return type_of_net;
}

-(void)setFlashMessage:(NSString*)message{
	[NSObject mainThreadBlock:^{
		[[[OLGhostAlertView alloc] initWithTitle:message] show];
	}];
}





#pragma mark - Unit Tests

-(void)uniqueTestForVersions{
	NSString *version = @"";
	NSString *min_version = @"";
    BOOL newVersion = NO;
    
    NSLog(@"+++++++++++++++++++++++++++++++++++++");
    
    version = @"0.9";
    min_version = @"0.9";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (0)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"0.9";
    min_version = @"0.9.1";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"1.0";
    min_version = @"1.0.0";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (0)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"1.0.1";
    min_version = @"1.0.9";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"12.0.2";
    min_version = @"12.1.9";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"2.2.9";
    min_version = @"3";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"1.2.3";
    min_version = @"1.3";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"2.0.1";
    min_version = @"2.0";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (0)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"3.0.1";
    min_version = @"3.0.1.1";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"3.0.1";
    min_version = @"3.0.1.0";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (0)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"1.0.1";
    min_version = @"1.0.124 - 2014-03-13_19-26-38";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"1.0.124";
    min_version = @"1.0.124 - 2014-03-13_19-26-38";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (0)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"1.0.123";
    min_version = @"1.0.124 - 2014-03-13_19-26-38";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (1)", newVersion);
    NSLog(@"-------------------------------------");
    
    version = @"1.0.125";
    min_version = @"1.0.124 - 2014-03-13_19-26-38";
    NSLog(@"version : %@ -- min_version : %@", version, min_version);
    newVersion = [self isFirstString:version lowerThanSecond:min_version];
    NSLog(@"is version < min_version : %d (0)", newVersion);
    NSLog(@"-------------------------------------");
    
    
    NSLog(@"+++++++++++++++++++++++++++++++++++++");
}

@end
