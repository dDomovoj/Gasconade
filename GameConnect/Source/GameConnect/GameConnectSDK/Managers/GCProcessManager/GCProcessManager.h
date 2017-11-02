//
//  GCProcessManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonManager.h"

#import "GCTrophyModel.h"
#import "GCLeagueModel.h"
#import "GCQuestionModel.h"

@protocol GCProcessManagerDelegate <NSObject>
@end

@interface GCProcessManager : SingletonManager
-(BOOL) checkDelegate:(id)delegate;
@end
