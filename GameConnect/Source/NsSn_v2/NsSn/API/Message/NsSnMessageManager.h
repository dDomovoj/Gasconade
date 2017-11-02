//
//  NsSnMessageManager.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnMessageModel.h"
#import "NsSnRequester.h"

@interface NsSnMessageManager : NSObject


+(void)post_users:(NsSnMessageModel *)message cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep;
+(void)post_thread:(NsSnMessageModel *)message cb_rep:(void (^)(NSDictionary *rep, NsSnUserErrorValue error))cb_rep;


+(void)thread_history_by_user:(NSString *)thread_id orUserIds:(NSString *)user_ids cb_rep:(void (^)(NSArray *messages, NsSnUserErrorValue error))cb_rep;



+(void)autorized:(void(^)(NSDictionary *rep))cb;

@end
