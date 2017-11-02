//
//  GCAnswerModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAnswerModel.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"

@implementation GCAnswerModel

+(id) fromJSON:(NSDictionary*)data
{
    GCAnswerModel *answer = [[GCAnswerModel alloc] init];
    if (data)
    {
        answer._id = [data getXpathEmptyString:@"id"];
        answer.answer = [data getXpathEmptyString:@"answer"];
        answer.score = [data getXpathInteger:@"score"];
        answer.total_answers = [data getXpathInteger:@"count"];
        answer.is_right_answer = [data getXpathBool:@"is_right_answer" defaultValue:NO];
    }
    return answer;
}

+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCAnswerModel fromJSON:elt]];
    }];
    return ret;
}

+(NSArray *)arrayOfAnswersIdsFromArrayOfAnswers:(NSArray *)answers
{
    NSMutableArray *arrayOfIds = [[NSMutableArray alloc] initWithCapacity:[answers count]];
    for (GCAnswerModel *answerModel in answers)
    {
        if (answerModel && [answerModel isKindOfClass:[GCAnswerModel class]])
        {
            if (answerModel._id)
                [arrayOfIds addObject:answerModel._id];
        }
    }
    return [arrayOfIds ToUnMutable];
}

@end


@implementation GCPostAnswerModel

+(NSDictionary *) createPostAnswerModel:(NSArray *)arrayOfAnswerIds
{
    GCPostAnswerModel *postAnswerModel = [GCPostAnswerModel new];
    postAnswerModel.device_timestamp = [NSDate dateWithTimeIntervalSince1970:floor([[NSDate date] timeIntervalSince1970])];
    postAnswerModel.answers = arrayOfAnswerIds;

    // @"answers" : postAnswerModel.answers
    NSMutableDictionary * postDictionary = [@{@"device_timestamp" : [GCConfManager NSDateToISO8601String:postAnswerModel.device_timestamp]} mutableCopy];
    
    NSInteger count = 0;
    for (NSString *idAnswer in arrayOfAnswerIds)
    {
        [postDictionary setObject:idAnswer forKey:SWF(@"answers[%ld]", (long)count)];
        count++;
    }
    
    return postDictionary;
}

@end
