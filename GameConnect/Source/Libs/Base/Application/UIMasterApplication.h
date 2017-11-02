//
//  UIMasterApplication.h
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface UIMasterApplication : NSObject<UIAlertViewDelegate>{
	void (^callback_push)(BOOL ok);
    void (^callback_push_data)(NSDictionary *data);
	NSString *token;
	NSTimer *timer_alerte;
	NSDictionary *pushData;
	
	
	void (^reponse_version)(BOOL newversion, BOOL Available);

	Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
	int old_type_of_net;
	int type_of_net; // 0 rien 1 3G 2 wifi
	int host_type;
	int internet_type;
	int wifi_type;
	int carrer_type;
	
    BOOL hasAlreadyAskForApnsToken;
}
@property (nonatomic,readonly,strong) NSDictionary *conf;
@property (nonatomic,strong) NSDictionary *pushData;
@property (nonatomic,readonly,strong) NSString *token;
@property (nonatomic,strong) NSString *versionURL;
@property (nonatomic) BOOL show_alert;
@property (nonatomic) BOOL autoReload;
@property (nonatomic, readonly) BOOL hasAlreadyAskForApnsToken;

+(UIMasterApplication*)getInstance;

-(NSString *)getURlUpdate;
-(void)askForRegisterApns:(void (^)(BOOL ok))cb_push;

-(void)saveToken:(NSString *)token_apps withTreatment:(BOOL)isNewFormat;
-(void)registerToken:(NSString *)token_apps;

-(void)reciveNotificationPush:(void (^)(NSDictionary *data))cb;
-(void)setDataPushCallback:(NSDictionary*)d;

-(void)isVersionAvailableAuto:(void (^)(BOOL newversion, BOOL Available))bloc;
-(void)isVersionAvailable:(void (^)(BOOL newversion, BOOL Available ))bloc;

-(int)isTypeOfNet;

-(void)setFlashMessage:(NSString*)message;


@end
