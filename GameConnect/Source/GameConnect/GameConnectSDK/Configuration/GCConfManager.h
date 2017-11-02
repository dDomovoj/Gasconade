//
//  GCConfManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <GameConnect/GCPlatformConnection.h>
#import "GCPlatformConnection.h"
//#import "GCLoggerManager.h"
#import "GCFontManager.h"
#import "GCColorManager.h"

/*
 ** Game Connect Storyboard &
 ** ViewControllers Identifiers from StoryBoard
 */
#pragma mark - Storyboard's identifier defines
#define GCStoryBoardFile @"GCViewControllersStoryboard"
#define GCSubscribeVCIdentifier @"GCSubscribeNSAPIViewController"
#define GCLoginVCIdentifier @"GCLoginNSAPIViewController"
#define GCEventsVCIdentifier @"GCEventsViewController"
#define GCProfileVCIdentifier @"GCProfileViewController"
#define GCRankingsVCIdentifier @"GCRankingsViewController"
#define GCInGameVCIdentifier @"GCInGameViewController"
#define GCLeaguesVCIdentifier @"GCLeaguesViewController"
#define GCAnswersVCIdentifier @"GCAnswersViewController"
#define GCLeagueEditionVCIdentifier @"GCLeagueEditionViewController"
#define GCProfileEditionVCIdentifier @"GCProfileEditionViewController"
#define GCRankingsEventVCIdentifier @"GCRankingsEventViewController"
#define GCPushInfoVCIdentifier @"GCPushInfoViewController"
#define GCLoadingVCIdentifier @"GCLoadingViewController"
#define GCExternalAnswerVCIdentifier @"GCAnswersViewControllerExternal"

/*
 ** Useful defines for GAME CONNECT
 */
#pragma mark - Useful General defines
#define SWF(FORMAT,...) [NSString stringWithFormat:FORMAT,__VA_ARGS__]
#define GCSTORYBOARD [UIStoryboard storyboardWithName:GCStoryBoardFile bundle:nil]

/* Notifications */
#pragma mark - Notifications defines
#define GCUSERINFONOTIF @"GCNotificationUserInfo"
#define GCNOTIF_LOGGEDIN @"GCNotificationLoggedIn"
#define GCNOTIF_LOGGEDOUT @"GCNotificationLoggedOut"
#define GCNOTIF_PLATFORM_CHECKED @"GCNotificationPlatformChecked"
#define GCNOTIF_SELECT_BUBBBLE_QUESTION @"GCNotificationSelectBubbleQuestion"
#define GCNOTIF_SELECT_BUBBBLE_PUSHINFO @"GCNotificationSelectBubblePushInfo"
#define GCNOTIF_NEW_NOTIFICATION @"GCNotification+1"

#define GCNOTIF_NEW_QUESTION @"GCNotificationNewQuestion"
#define GCNOTIF_NEW_RESULT @"GCNotificationNewResult"
#define GCNOTIF_NEW_TROPHY @"GCNotificationNewTrophy"

#define GCNOTIF_END_QUESTION @"GCNotificationEndQuestion"
#define GCNOTIF_END_EVENT @"GCNotificationEndEvent"

/* User defaults */
#pragma mark - User defaults defines
#define GCUSERDEFAULTS_SOUND_STATUS @"GCUserDefaultsSoundStatus"
#define GCUSERDEFAULTS_VIBRATE_STATUS @"GCUserDefaultsVibrateStatus"
#define GCUSERDEFAULTS_EXTERNAL_NOTIFICATIONS @"GCUserDefaultsExternalNotifications"

/* Fonts */
#pragma mark - FontsManager defines
#define CONFFONTBOLDSIZE(_S) [[GCFontManager getInstance] getFontBoldWithSize:_S]
#define CONFFONTMEDIUMSIZE(_S) [[GCFontManager getInstance] getFontMediumWithSize:_S]
#define CONFFONTREGULARSIZE(_S) [[GCFontManager getInstance] getFontRegularWithSize:_S]
#define CONFFONTSIZE(_S) [[GCFontManager getInstance] getFontWithSize:_S]
#define CONFFONTULTRALIGHTSIZE(_S) [[GCFontManager getInstance] getFontUltraLightWithSize:_S]
#define CONFFONTITALICSIZE(_S) [[GCFontManager getInstance] getFontItalicWithSize:_S]

/* Color */
#pragma mark - ColorManager defines
#define CONFCOLORFORKEY(_K) [[GCColorManager getInstance] getColorForKey:_K]

#ifndef GCPICTOPOINTSENABLED
#define GCPICTOPOINTSENABLED NO
#endif

/* Debug define */
#pragma mark - Debug defines
#define FORCE_NOTIFICATIONS NO

//#define GCLog(...) [GCLoggerManager GCLog:[NSString stringWithFormat:@"%s [line %d] : %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]]]

#define GC_GOOGLE_TAG @"UA-12122112-19" // New TFC Mobile"

typedef enum
{
    GCConfigValueImageTTL,
    GCConfigValueColorJSONFile,
    GCConfigDefaultBackgroundImage,
    GCConfigValueWebsocketDelayAutoReconnection,
    GCConfigAutorefreshEvents,
    GCConfigAutorefreshQuestions,
    CGConfigDelayDisplayingStats,
    CGConfigDelayDisplayingPushInfo,
    GCConfigGoogleTag
    
} GCConfigValue;

@interface GCConfManager : NSObject

@property (strong, nonatomic) NSString *TRACKING_GA_ID;

@property (nonatomic, copy) NSString *pmuLogo;
@property (nonatomic, copy) NSString *awardsEnURLString;
@property (nonatomic, copy) NSString *awardsFrURLString;
@property (nonatomic, copy) NSString *regulationsURLString;
@property (nonatomic, copy) NSString *pmuWebsiteURLString;
@property (nonatomic, copy) NSString *pmuPSGWiFiWebsiteURLString;
@property (nonatomic, copy) NSString *pixelURLString;
@property (nonatomic, copy) NSString *pmuPartnershipURLString;

#pragma mark - Singleton & Init
+(GCConfManager *) getInstance;
-(void)initialize;

#pragma mark - Default Value & URLS
-(id) getValue:(GCConfigValue)value;
+(NSString*)  getURL:(GCConfigURLType)urlType;

#pragma mark - Tools - UseFull Methods
+(NSString *) getSuffixPosition:(NSString *)string_;
+(NSString *) getFormatedStringForRemainingSeconds:(NSInteger)totalsecondsRemaining;
+(NSDate *)   ISO8601StringToNSDate:(NSString *)dateTimeZFormat;
+(NSString *) NSDateToISO8601String:(NSDate *)dateTime;

+(void) notImplementedYetAlert;

#pragma mark - Application Preferences - External panel
-(void) setGameConnectExternalNotificationsEnabled:(BOOL)shouldEnableExternalNotification;
-(BOOL) shouldBroadcastExternalNotifications;
-(BOOL) hasAlreadyShutdownExternalNotifications;

#pragma mark Application Preferences - Sound
-(void) setSoundEnabled:(BOOL)shouldEnableSound;
-(BOOL) shouldPlaySound;
-(BOOL) isSoundEnabled;

#pragma mark Application Preferences - Vibration
-(BOOL) shouldVibrate;
-(void) setVibrationEnabled:(BOOL)shouldEnableVibration;
-(BOOL) isVibrationEnabled;

@end
