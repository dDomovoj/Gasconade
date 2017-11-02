//
//  NsSnFeedManager.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnRequester.h"
#import "NsSnTagModel.h"
#import "NsSnFeedModel.h"

@interface NsSnFeedManager : NSObject

+(NsSnFeedManager*)getInstance;

-(void)getFeed:(NsSnFeedModel*)feed cb_rep:(void (^)(NsSnFeedModel *rep,NsSnUserErrorValue error,BOOL cache))cb_rep;

-(void)deleteFeed:(NSString *)feedId cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)getFeedsAPI:(NSString*)x_id page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnTagModel *tag,NsSnUserErrorValue error,BOOL cache))cb_rep;
-(void)getFeeds:(NsSnTagModel*)tag page:(int)page limit:(int)limit cb_rep:(void (^)(NSArray *rep,NsSnUserErrorValue error,BOOL cache))cb_rep;

-(void)sendFeed:(NsSnTagModel*)tagTo text:(NSString*)text medias:(NSArray*)medias cb_send:(void (^)(long long total, long long current))cb_send  cb_rep:(void (^)(NSDictionary*rep,NsSnUserErrorValue error))cb_rep;

-(void)Like:(NsSnFeedModel*)feed cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)unLike:(NsSnFeedModel*)feed cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)reportAbuseOnFeed:(NsSnFeedModel *)feed cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

@end
