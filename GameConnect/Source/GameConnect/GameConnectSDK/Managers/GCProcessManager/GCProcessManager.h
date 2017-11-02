//
//  GCProcessManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCConnectViewController.h"
#import "GCLoginNSAPIViewController.h"
#import "GCEventsViewController.h"
#import "GCProfileViewController.h"
#import "GCProfileEditionViewController.h"
#import "GCLeaguesViewController.h"
#import "GCProfileEditionViewController.h"
#import "GCLeagueEditionViewController.h"
#import "GCRankingsViewController.h"
#import "GCInGameViewController.h"
#import "GCAnswersViewController.h"
#import "GCPushInfoViewController.h"
#import "SingletonManager.h"

#import "GCTrophyModel.h"
#import "GCLeagueModel.h"
#import "GCQuestionModel.h"

@protocol GCProcessManagerDelegate <NSObject>
@end

@interface GCProcessManager : SingletonManager
-(BOOL) checkDelegate:(id)delegate;
@end
