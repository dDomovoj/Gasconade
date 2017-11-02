//
//  FFFMatchManager.h
//  FIFA_WC14
//
//  Created by Derivery Guillaume on 10/23/13.
//  Copyright (c) 2013 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSMMatchModel.h"

@interface GCAPPMatchManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *match_event_gc;
+(GCAPPMatchManager *)getInstance;

// GC
+(void)getGCListMatchsHeads:(NSString *)matchIDs rep:(void (^)(GCAPPMatchManager *rep, BOOL cache, NSData *data))cb_rep;
+(GSMMatchModel *)getGCEventMatchFromId:(NSString *)matchId;

@end
