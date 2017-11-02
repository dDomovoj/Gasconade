//
//  GCAPPDefines.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 15/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#ifndef GameConnectV2_GCAPPDefines_h
#define GameConnectV2_GCAPPDefines_h

#import "GCConfManager.h"
#import "GCFontManager.h"
#import "GCColorManager.h"

/*
 ** GameConnect Application DEFINES
 */
#define GCAPPDEBUG 0

// Storyboards File Name
#define GCAPPStoryBoardFileIphone @"GCAPP_iPhone"
#define GCAPPStoryBoardFileIpad @"GCAPP_iPad"

// Accessing Storyboard object
#define GCAPPSTORYBOARDIPHONE [UIStoryboard storyboardWithName:GCAPPStoryBoardFileIphone bundle:nil]
#define GCAPPSTORYBOARDIPAD [UIStoryboard storyboardWithName:GCAPPStoryBoardFileIpad bundle:nil]

// ViewControllers Identifier in Storyboards
#define GCAPPIdentifierForDevice(IDENTIFIER) SWF(@"%@%@", IDENTIFIER , @"iPhone")
//#define GCAPPIdentifierForDevice(IDENTIFIER) SWF(@"%@%@", IDENTIFIER , [UIDevice isIPAD] ? @"iPad" : @"iPhone")
#define GCAPPGameVCIdentifier GCAPPIdentifierForDevice (@"GCAPPGameViewController")
#define GCAPPRankingsCVIdentifier GCAPPIdentifierForDevice (@"GCAPPRankingsViewController")
#define GCAPPLeaguesVCIdentifier GCAPPIdentifierForDevice (@"GCAPPLeaguesViewController")
#define GCAPPLeagueRankingsVCIdentifier @"GCAPPLeagueRankingsViewController"
#define GCAPPLeagueEditionVCIdentifier GCAPPIdentifierForDevice(@"GCAPPLeagueEditionViewController")
#define GCAPPProfileVCIdentifier GCAPPIdentifierForDevice(@"GCAPPProfileViewController")
#define GCAPPProfileEditionVCIdentifier GCAPPIdentifierForDevice(@"GCAPPProfileEditionViewController")
#define GCAPPAnswersVCIdentifier GCAPPIdentifierForDevice(@"GCAPPAnswersViewController")
#define GCAPPLoginVCIdentifier GCAPPIdentifierForDevice(@"GCAPPLoginViewController")
#define GCAPPSubscribeVCIdentifier GCAPPIdentifierForDevice(@"GCAPPSubscribeViewController")
#define GCAPPPushInfoVCIdentifier GCAPPIdentifierForDevice(@"GCAPPPushInfoViewController")
#define GCAPPLoadingVCIdentifier @"GCAPPLoadingViewController"

// Keys for blured image storage
#define GCAPPBluredBackground @"bg_app_blured_full"
#define GCAPPBluredBackgroundWithLogo @"bg_app_blured_under_logo"
#define GCAPPBluredBackgroundWithNavbar @"gc_app_background"

#define GCAPPBluredBackground2Columns @"bg_app_blured_2columns"
#define GCAPPBluredBackground2ColumnsLeagues @"bg_app_blured_2columns_leagues"

// Notifications emit by the GameConnect App
#define CGAPPNotificationBluredDone @"GCAPPNotificationBluredDone"

// Colors Used in Application

#define APPLE_STORE_SHARING_URL [NSURL URLWithString:@"https://itunes.apple.com/app/psg-officiel/id515968212"]

#define GC_DARK_BLUE_COLOR [UIColor colorWithRGB:0x090e19]
#define GC_BLUE_COLOR [UIColor colorWithRGB:0x1a2434]
#define GC_RED_COLOR [UIColor colorWithRGB:0xff1541]

#define GCAPPColorButtonBG [UIColor whiteColor]
#define GCAPPColorButtonLB [UIColor blackColor]
#define GCAPPHeaderBG [UIColor colorWithRGBString:@"ffffffff" alpha:0.3f]



#endif
