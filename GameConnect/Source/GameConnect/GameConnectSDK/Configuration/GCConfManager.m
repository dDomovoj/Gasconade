//
//  GCConfManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCConfManager.h"
#import "GCFayeWorker.h"

@interface GCConfManager()
{
    BOOL shouldBroadcastExternalNotifications;
}
@end

@implementation GCConfManager

#pragma mark - Singleton & Init
+(GCConfManager *) getInstance
{
    static GCConfManager *confManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        confManager = [[self alloc] init];
    });
    return confManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        shouldBroadcastExternalNotifications = YES;
        [self shouldBroadcastExternalNotifications];
        [self shouldPlaySound];
        [self shouldVibrate];

        self.TRACKING_GA_ID = GC_GOOGLE_TAG;
    }
    return self;
}

-(void)initialize
{
    [[GCPlatformConnection getInstance] initialize];
}

#pragma mark - Default Value & URLS
-(id)getValue:(GCConfigValue)value
{
    switch (value)
    {
        case GCConfigValueImageTTL:
            return @(20*60);
            break;

        case GCConfigValueWebsocketDelayAutoReconnection:
            return @(2);

        case GCConfigValueColorJSONFile:
            return @"GCColors";
            break;

        case GCConfigDefaultBackgroundImage:
            return SWF(@"%@%@", @"background_live_gaming", [UIDevice isIPAD] ? @"_ipad" : @"_iphone");
            break;

        case GCConfigAutorefreshEvents:
            return @(30);
            break;

        case GCConfigAutorefreshQuestions:
            return @(15);
            break;

        case CGConfigDelayDisplayingStats:
            return @(5);
            break;

        case CGConfigDelayDisplayingPushInfo:
            return @(5);
            break;

        case GCConfigGoogleTag:
            return self.TRACKING_GA_ID;
            break;

        default:
            break;
    }
}

+(NSString*)getURL:(GCConfigURLType)urlType
{
    return [[GCPlatformConnection getInstance] getURL:urlType];
}

#pragma mark - Tools - UseFull Methods
+(NSString *) getSuffixPosition:(NSString *)string_
{
    if (string_ && [string_ length] > 0)
    {
        char last = [string_ characterAtIndex:([string_ length]-1)];

        if ([string_ length] > 1)
        {
            char beforelast = [string_ characterAtIndex:([string_ length]-2)];
            if ((beforelast == '1' && last == '1') ||
                (beforelast == '1' && last == '2') ||
                (beforelast == '1' && last == '3'))
                return NSLocalizedString(@"gc_th", @"");
        }
        if (last == '1')
            return NSLocalizedString(@"gc_st", @"");

        else if (last == '2')
            return NSLocalizedString(@"gc_nd", @"");

        else if (last == '3')
            return NSLocalizedString(@"gc_rd", @"");

        else if (last == '0' && [string_ length] == 1)
            return @"";

        else
            return NSLocalizedString(@"gc_th", @"");
    }
    return string_;
}

+(NSString *)getFormatedStringForRemainingSeconds:(NSInteger)totalsecondsRemaining
{
    NSInteger hoursRemaining = totalsecondsRemaining / 3600;
    NSInteger remainder = totalsecondsRemaining % 3600;

    NSInteger minutesRemaining = remainder / 60;
    NSInteger secondsRemaining = remainder % 60;

    if (hoursRemaining != 0)
        return [NSString stringWithFormat:@"%ld%@", (long)hoursRemaining, NSLocalizedString(@"gc_hour_abbrev", @"")];

    else if (minutesRemaining != 0)
        return [NSString stringWithFormat:@"%ld\' %02ld\"", (long)minutesRemaining, (long)secondsRemaining];

    else
        return [NSString stringWithFormat:@"%02ld\"", (long)totalsecondsRemaining];
}

+(NSDate *) ISO8601StringToNSDate:(NSString *)dateTimeZFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2013-11-18T23:00:00.324Z
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.locale = [NSLocale systemLocale];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    return [formatter dateFromString:dateTimeZFormat];
}

+(NSString *) NSDateToISO8601String:(NSDate *)dateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2013-11-18T23:00:00.324Z
    formatter.locale = [NSLocale systemLocale];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    return [formatter stringFromDate:dateTime];
}

+(void) notImplementedYetAlert
{
  NSLog(@"This section has not been implemented yet. Waiting for new content on the server side...");
}

#pragma mark - Application Preferences - External panel
-(void) setGameConnectExternalNotificationsEnabled:(BOOL)shouldEnableExternalNotification
{
    shouldBroadcastExternalNotifications = shouldEnableExternalNotification;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:shouldBroadcastExternalNotifications] forKey:GCUSERDEFAULTS_EXTERNAL_NOTIFICATIONS];
    [defaults synchronize];
}

-(BOOL) shouldBroadcastExternalNotifications
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id preference = [defaults objectForKey:GCUSERDEFAULTS_EXTERNAL_NOTIFICATIONS];
    if (preference && [preference isKindOfClass:[NSNumber class]])
    {
        shouldBroadcastExternalNotifications = [preference boolValue];
        return shouldBroadcastExternalNotifications;
    }
    else
    {
        [self setGameConnectExternalNotificationsEnabled:YES];
        return [self shouldBroadcastExternalNotifications];
    }
}

-(BOOL) hasAlreadyShutdownExternalNotifications
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id preference = [defaults objectForKey:GCUSERDEFAULTS_EXTERNAL_NOTIFICATIONS];
    if (preference && [preference isKindOfClass:[NSNumber class]] && [preference boolValue] == NO)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark Application Preferences - Sound
-(BOOL) shouldPlaySound
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id preference = [defaults objectForKey:GCUSERDEFAULTS_SOUND_STATUS];
    if (preference && [preference isKindOfClass:[NSNumber class]])
    {
        return [preference boolValue];
    }
    else
    {
        [self setSoundEnabled:YES];
        return [self shouldPlaySound];
    }
}

-(void) setSoundEnabled:(BOOL)shouldEnableSound
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:shouldEnableSound] forKey:GCUSERDEFAULTS_SOUND_STATUS];
    [defaults synchronize];
}

-(BOOL) isSoundEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id preference = [defaults objectForKey:GCUSERDEFAULTS_SOUND_STATUS];
    if (preference && [preference isKindOfClass:[NSNumber class]] && [preference boolValue] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark Application Preferences - Vibration
-(BOOL) shouldVibrate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id preference = [defaults objectForKey:GCUSERDEFAULTS_VIBRATE_STATUS];
    if (preference && [preference isKindOfClass:[NSNumber class]])
    {
        return [preference boolValue];
    }
    else
    {
        [self setVibrationEnabled:NO];
        return [self shouldVibrate];
    }
}

-(void) setVibrationEnabled:(BOOL)shouldEnableVibration
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:shouldEnableVibration] forKey:GCUSERDEFAULTS_VIBRATE_STATUS];
    [defaults synchronize];
}

-(BOOL) isVibrationEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id preference = [defaults objectForKey:GCUSERDEFAULTS_VIBRATE_STATUS];
    if (preference && [preference isKindOfClass:[NSNumber class]] && [preference boolValue] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
