//
//  NsSnCommentManager.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnCommentModel.h"
#import "NsSnRequester.h"
#import "NsSnFeedModel.h"
#import "NsSnCommentModel.h"

@interface NsSnCommentManager : NSObject

+(NsSnCommentManager*)getInstance;

-(void)addComment:(NsSnFeedModel*)feed text:(NSString*)text  cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)deleteComment:(NSString*)commentId_ feedId:(NSString *)feedId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)Like:(NSString*)feedId_ commentId:(NSString *)commentId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)unLike:(NSString*)feedId_ commentId:(NSString *)commentId_ cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

-(void)reportAbuseFeed:(NSString *)feedID onComment:(NsSnCommentModel *)comment cb_rep:(void (^)(NSDictionary *rep,NsSnUserErrorValue error))cb_rep;

@end
