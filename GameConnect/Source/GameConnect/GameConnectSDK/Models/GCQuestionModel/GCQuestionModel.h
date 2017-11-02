//
//  GCQuestionModel.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/25/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCModel.h"
#import "GCEventModel.h"

typedef enum
{
    eGCQuestionStatusInProgress,
    eGCQuestionStatusFinished,
    eGCQuestionStatusUpComing,
    eGCQuestionStatusUnknown,
} eGCQuestionStatus;

typedef enum
{
    eGCQuestionTypePrediction, // Score => Answers
    eGCQuestionTypeForecast,   // Score => Question
    eGCQuestionTypeMCQ,        // Score => Question
    eGCQuestionTypePoll,       // Score => Question
    eGCQuestionTypeUnknown,    // Score => Question
    
} eGCQuestionType;

@interface GCQuestionModel : GCModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *competition_id;
@property (nonatomic, strong) NSString *question;

@property (nonatomic) NSDate *start_date;
@property (nonatomic) NSDate *end_date;
@property (nonatomic) NSInteger points_earned;
@property (nonatomic) NSInteger score;

@property (nonatomic) eGCQuestionStatus status;
@property (nonatomic) eGCQuestionType type;

@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) NSArray *my_answers;

+(void) sortArrayOfQuestions:(NSArray *)allQuestions cb_sorted:(void(^)(NSArray *questionsWithResults, NSArray *theOthers))cb_sorted;
+(NSArray *) sortQuestionsByStartDate:(NSArray *)questions;

-(BOOL) isQuestionActive;

-(NSUInteger) calculateNumberOfPersonAnswers;
-(BOOL) addMyAnswersOnTotalCount;

- (NSTimeInterval)getRemainingSeconds;
- (NSTimeInterval)getInitialSeconds;

-(NSString *) getStringQuestionType;

-(BOOL) hasRightAnswerAvailable;
-(NSArray *) getMyAnswersModel;
-(NSArray *) getRightAnswersModel;
-(NSArray *) getMyRightAnswersModel;

-(NSString *) formatMyAnswers;
-(NSString *) formatRightAnswers;

- (BOOL)isMyAnswerCorrect;

@end
