//
//  GCAnswerModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCModel.h"

@interface GCAnswerModel : GCModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger total_answers;
@property (nonatomic) BOOL is_right_answer;

+(NSArray *)arrayOfAnswersIdsFromArrayOfAnswers:(NSArray *)answers;

@end


@interface GCPostAnswerModel : NSObject

@property (nonatomic) NSDate *device_timestamp;
@property (nonatomic, strong) NSArray *answers;

+(NSDictionary *) createPostAnswerModel:(NSArray *)arrayOfAnswerIds;

@end

