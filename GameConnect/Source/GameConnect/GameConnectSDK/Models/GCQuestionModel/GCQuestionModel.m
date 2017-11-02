//
//  GCQuestionModel.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCQuestionModel.h"
#import "GCAnswerModel.h"
#import "Extends+Libs.h"
#import "GCConfManager.h"

@implementation GCQuestionModel

-(id)init
{
    self = [super init];
    if (self)
    { }
    return self;
}

+(id) fromJSON:(NSDictionary*)data
{
    GCQuestionModel *question = [[GCQuestionModel alloc] init];
    
    if (data)
    {
        question._id = [data getXpathEmptyString:@"id"];
        question.event_id = [data getXpathEmptyString:@"event_id"];
        question.competition_id = [data getXpathEmptyString:@"competition_id"];
        question.question = [data getXpathEmptyString:@"question"];
        
        NSString *type = [data getXpathEmptyString:@"type"];
        if ([type isEqualToString:@"PREDICTION"])
            question.type = eGCQuestionTypePrediction;
        else if ([type isEqualToString:@"FORECAST"])
            question.type = eGCQuestionTypeForecast;
        else if ([type isEqualToString:@"MCQ"])
            question.type = eGCQuestionTypeMCQ;
        else if ([type isEqualToString:@"POLL"])
            question.type = eGCQuestionTypePoll;
        else
            question.type = eGCQuestionTypeUnknown;
        
        question.start_date = [GCConfManager ISO8601StringToNSDate:[data getXpathEmptyString:@"start_date"]];
        question.end_date = [GCConfManager ISO8601StringToNSDate:[data getXpathEmptyString:@"end_date"]];
        question.points_earned = [[data getXpath:@"points_earned" type:[NSNumber class] def:0]integerValue];
        question.score = [[data getXpath:@"score" type:[NSNumber class] def:0]integerValue];
        
        NSString *status = [data getXpathEmptyString:@"status"];
        if ([status isEqualToString:@"IN_PROGRESS"])
            question.status = eGCQuestionStatusInProgress;
        else if ([status isEqualToString:@"FINISHED"])
            question.status = eGCQuestionStatusFinished;
        else if ([status isEqualToString:@"UPCOMING"])
            question.status = eGCQuestionStatusUpComing;
        else
        {
            DLog(@"BAD STATUS FOR QUESTION /!\\");
            question.status = eGCQuestionStatusUnknown;
        }
        
        question.my_answers = [data getXpathNilArray:@"my_answers"];
        question.answers = [GCAnswerModel fromJSONArray:[data getXpathNilArray:@"answers"]];
        
        if (!question.my_answers)
            question.my_answers = @[];
        
        if (!question.answers)
            question.answers = @[];
    }
    return  question;
}

+(id) fromJSONArray:(NSArray *)data
{
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[data count]];
    [data each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[GCQuestionModel fromJSON:elt]];
    }];
    return [ret ToUnMutable];
}

-(NSUInteger) calculateNumberOfPersonAnswers
{
    NSUInteger nbOfAnswers = 0;
    for (GCAnswerModel *answers in self.answers)
        nbOfAnswers += answers.total_answers;
    return nbOfAnswers;
}

-(BOOL) addMyAnswersOnTotalCount
{
    for (NSString *myAnswersId in self.my_answers)
    {
        BOOL found = NO;
        for (GCAnswerModel *answerModel in self.answers)
        {
            if ([myAnswersId isEqualToString:answerModel._id])
            {
                answerModel.total_answers += 1;
                found = YES;
            }
        }
        if (found == NO)
            return NO;
    }
    return YES;
}

- (NSTimeInterval)getRemainingSeconds
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timestampEndDate = [self.end_date timeIntervalSince1970];
    return timestampEndDate - now;
}

- (NSTimeInterval)getInitialSeconds
{
    return [self.end_date timeIntervalSinceDate:self.start_date];
}

-(BOOL) isQuestionActive
{
    if (self.status == eGCQuestionStatusInProgress && [self getRemainingSeconds] > 0.0)
        return YES;
    else
        return NO;
}

+(void) sortArrayOfQuestions:(NSArray *)allQuestions cb_sorted:(void(^)(NSArray *questionsWithResults, NSArray *theOthers))cb_sorted
{
    NSMutableArray *arrayOfOpenedQuestions = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfClosedQuestions = [[NSMutableArray alloc] init];
    
    for (GCQuestionModel *questionModel in allQuestions)
    {
        if (questionModel.status == eGCQuestionStatusUpComing)
            continue;
        
        if ([questionModel.my_answers count] > 0 && [questionModel hasRightAnswerAvailable] == YES)
            [arrayOfClosedQuestions addObject:questionModel];
        else
            [arrayOfOpenedQuestions addObject:questionModel];
    }
    cb_sorted([GCQuestionModel sortQuestionsByStartDate:[arrayOfClosedQuestions ToUnMutable]],
              [GCQuestionModel sortQuestionsByStartDate:[arrayOfOpenedQuestions ToUnMutable]]);
}

-(NSString *) getStringQuestionType
{
    eGCQuestionType questionType = self.type;
    
    if (questionType == eGCQuestionTypePrediction)
        return NSLocalizedString(@"gc_prediction", nil);
    else if (questionType == eGCQuestionTypeForecast)
        return NSLocalizedString(@"gc_forecast", nil);
    else if (questionType == eGCQuestionTypeMCQ)
        return NSLocalizedString(@"gc_mcq", nil);
    else if (questionType == eGCQuestionTypePoll)
        return NSLocalizedString(@"gc_poll", nil);
    else
        return @"";
}

-(BOOL) hasRightAnswerAvailable
{
    if ([[self getRightAnswersModel] count] > 0)
        return YES;
    else
        return NO;
}

-(NSArray *) getMyAnswersModel
{
    NSMutableArray *arrayOfAnswersModel = [NSMutableArray new];
    
    for (NSString *myAnswersId in self.my_answers)
    {
        for (GCAnswerModel *answerModel in self.answers)
        {
            if ([myAnswersId isEqualToString:answerModel._id])
            {
                [arrayOfAnswersModel addObject:answerModel];
                break;
            }
        }
    }
    return [arrayOfAnswersModel ToUnMutable];
}

-(NSArray *) getMyRightAnswersModel
{
    NSMutableArray *arrayOfAnswersModel = [NSMutableArray new];
    
    for (NSString *myAnswersId in self.my_answers)
    {
        for (GCAnswerModel *answerModel in self.answers)
        {
            if ([myAnswersId isEqualToString:answerModel._id])
            {
                if (answerModel.is_right_answer)
                    [arrayOfAnswersModel addObject:answerModel];
                break;
            }
        }
    }
    return [arrayOfAnswersModel ToUnMutable];
}

-(NSArray *) getRightAnswersModel
{
    NSMutableArray *arrayOfAnswersModel = [NSMutableArray new];
    
    for (GCAnswerModel *answerModel in self.answers)
    {
        if (answerModel.is_right_answer == YES)
            [arrayOfAnswersModel addObject:answerModel];
    }
    return [arrayOfAnswersModel ToUnMutable];
}

-(NSString *) formatMyAnswers
{
    NSString *stringFormatMyAnswers = @"";
    NSInteger count = 0;
    NSArray *myAnswersModel = [self getMyAnswersModel];
    
    for (GCAnswerModel *answerModel in myAnswersModel)
    {
        if (count == [myAnswersModel count] - 2)
            stringFormatMyAnswers = [stringFormatMyAnswers stringByAppendingFormat:@"%@ %@ ", answerModel.answer, NSLocalizedString(@"gc_and", nil)];
        else if (count == [myAnswersModel count] - 1)
            stringFormatMyAnswers = [stringFormatMyAnswers stringByAppendingFormat:@"%@", answerModel.answer];
        else
            stringFormatMyAnswers = [stringFormatMyAnswers stringByAppendingFormat:@"%@, ", answerModel.answer];
        count++;
    }
    if (!stringFormatMyAnswers)
        stringFormatMyAnswers = nil;
    return stringFormatMyAnswers;
}

-(NSString *) formatRightAnswers
{
    NSString *stringFormatRightAnswers = @"";
    NSInteger count = 0;
    NSArray *rightAnswersModel = [self getRightAnswersModel];

    for (GCAnswerModel *answerModel in rightAnswersModel)
    {
        if (count == [rightAnswersModel count] - 2)
            stringFormatRightAnswers = [stringFormatRightAnswers stringByAppendingFormat:@"%@ %@ ", answerModel.answer, NSLocalizedString(@"gc_and", nil)];
        else if (count == [rightAnswersModel count] - 1)
            stringFormatRightAnswers = [stringFormatRightAnswers stringByAppendingFormat:@"%@", answerModel.answer];
        else
            stringFormatRightAnswers = [stringFormatRightAnswers stringByAppendingFormat:@"%@, ", answerModel.answer];

        count++;
    }
    if (!stringFormatRightAnswers)
        stringFormatRightAnswers = nil;
    return stringFormatRightAnswers;
}

+(NSArray *) sortQuestionsByStartDate:(NSArray *)questions
{
    if (!questions || [questions count] == 0)
    {
//        DLog(@"Questions cannot be sorted, they don't exist !");
        return @[];
    }
    
    return [questions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                if ((obj1 && [obj1 isKindOfClass:[GCQuestionModel class]]) &&
                    (obj2 && [obj2 isKindOfClass:[GCQuestionModel class]]))
                {
                    GCQuestionModel *question1 = (GCQuestionModel *)obj1;
                    GCQuestionModel *question2 = (GCQuestionModel *)obj2;
                    
                    if ([question1.start_date timeIntervalSince1970] < [question2.start_date timeIntervalSince1970])
                        return (NSComparisonResult)NSOrderedDescending;
                    if ([question1.start_date timeIntervalSince1970] > [question2.start_date timeIntervalSince1970])
                        return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
}

- (BOOL)isMyAnswerCorrect
{
    NSUInteger numberOfGoodAnswer = [self getRightAnswersModel].count;

    BOOL iHaveAllRightAnswers = NO;
    NSArray *rightAnswersModel = [self getMyRightAnswersModel];
    if (self.my_answers.count == rightAnswersModel.count && rightAnswersModel.count == numberOfGoodAnswer) {
        iHaveAllRightAnswers = YES;
    }

    if (self.type == eGCQuestionTypePoll) {
        iHaveAllRightAnswers = YES;
    }

    return iHaveAllRightAnswers;
}

@end

