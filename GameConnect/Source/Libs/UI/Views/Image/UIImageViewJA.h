//
//  UIImageViewJA.h
//  Extends
//
//  Created by bigmac on 04/10/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol UIImageViewJADelegate;


@class  NSDLClassJA;
@class NSIOCheckImage;

@interface UIImageViewJA : UIImageView {
	NSDLClassJA *c_download;
    NSIOCheckImage *c_io;
    
	NSString *dist_url;
	UIViewContentMode my_UIViewContentModeScaleAspectFit;
	
	__weak id<UIImageViewJADelegate> my_responder;
    __weak id<UIImageViewJADelegate> delegate;
	void(^callback)(UIImageViewJA *image);
	BOOL isJpeg;
	UIActivityIndicatorView *ac_activity;
	
    
    UIImage *def_placeHolder;
}

@property (assign, nonatomic) BOOL clear_image;
@property (assign, nonatomic) BOOL show_activity;
@property (assign, nonatomic) UIViewContentMode my_UIViewContentModeScaleAspectFit;

@property (nonatomic,copy)NSString* dist_url;
@property (weak,nonatomic)  id<UIImageViewJADelegate> my_responder;
@property (assign) BOOL loaded;

-(NSString*) getLocaleFile:(NSString *)str;
-(void)write:(NSData*)urldata tofile:(NSString*)file;
-(void)setupimage:(UIImage*)i;

-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl;
-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl clean:(BOOL)clear;
-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl endblock:(void(^)(UIImageViewJA *image))cb;

-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl withPlaceholder:(UIImage *)pholder;
-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl clean:(BOOL)clear withPlaceholder:(UIImage *)pholder;
-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl endblock:(void(^)(UIImageViewJA *image))cb withPlaceholder:(UIImage *)pholder;

-(void)loadavatar:(NSString*)str;
-(NSString *)getF1CarsUrl:(NSString *)idcar;
-(NSString *)getFlagsUrlWithIso3:(NSString *)iso;
-(NSString *)getPilotById:(NSString *)idpilot;
-(void)loadFlag:(NSString *)flag;
-(void)loadCar:(NSString *)car;
-(void)loadCircuit:(NSString *)circuit;
-(void)loadRacePics:(NSString *)racepics;
-(void)getClubById:(NSString *)idclub;

-(void)getPlayerC10:(NSString *)idplayer;
-(void)getPlayerC10Bulle:(NSString *)idplayer;
-(void)getClubRugbyById:(NSString *)idclub;
-(void)getClubById:(NSString *)idclub withSize:(NSString *)size;
-(void)getCompLfpByKey:(NSString *)compKey;
-(void)getCompLfpFiligraneByKey:(NSString *)compKey;

-(void)getGSMcompByIdHDG:(NSString *)idTeam;
-(void)getGSMcompById:(NSString *)idComp;
-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic;
-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic ttl:(unsigned)ttl;
-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format;
-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format ttl:(unsigned)ttl;
-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format endblock:(void(^)(UIImageViewJA *image))cb;
-(void)getGSMpersonById:(NSString *)idPerson hasPic:(id)hasPic;

-(void) getRoundTeamPictoById :(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format endblock:(void(^)(UIImageViewJA *image))cb;

-(NSString *)getDirectoryGSMpics:(NSString *)idPic;

-(void)getPlaceById:(NSString*)idPlace hasPic:(id)hasPic;

/*
 -(void)getWCteamFlag:(NSString *)teamShortName;
 -(void)getWCteamFlag:(NSString *)teamShortName withFormat:(NSString *)format;
 -(void)getWCteamFedFlag:(NSString *)teamShortName;
 -(void)getWCteamBigFlag:(NSString *)teamShortName;
 -(void)getWCteamBigFlagGrad:(NSString *)teamShortName;
 */
-(void)getWCteamFlag:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl;
-(void)getWCteamFlag:(NSString *)teamShortName withFormat:(NSString *)format withBaseUrl:(NSString *)baseUrl;
-(void)getWCteamFedFlag:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl;
-(void)getWCteamBigFlag:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl;
-(void)getWCteamBigFlagGrad:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl;

+(void)freepool;

@end

@protocol UIImageViewJADelegate <NSObject>

@optional

-(void) finchargement:(UIImageViewJA*)sender;
-(void) recivingdata:(long long)nbbytes totalbytes:(long long)totalbytes;
-(void) recivingdata:(UIImageViewJA*)sender nbbytes:(long long)nbbytes totalbytes:(long long)totalbytes;

@end


@interface NSDLClassJA : NSObject{
    NSURLConnection* connection;
	NSMutableData* data;
    NSString *dist_url;
	NSString *local_file;
    long long recived;
}

@property (nonatomic, readonly) long long total;
@property (nonatomic,weak) id<UIImageViewJADelegate> delegate;
@property (nonatomic,weak) id delegate_image;
@property (nonatomic,copy) void(^callback)(NSData *data);


-(void)cancel;
-(void)runDL:(NSString*)localurl dist:(NSString*)disturl;
@end

@interface NSIOCheckImage : NSObject


@property (nonatomic,weak) UIImageViewJA* delegate;
-(void)run:(NSString*)url locf:(NSString*)locf ttl:(int)ttl;

@end