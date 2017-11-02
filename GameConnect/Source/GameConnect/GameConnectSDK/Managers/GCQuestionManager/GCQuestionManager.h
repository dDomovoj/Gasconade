//
//  NSLEEventManager.h
//  PepsiLiveGaming
//
//  Created by Derivery Guillaume on 9/12/13.
//  Copyright (c) 2013 Seb Jallot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCQuestionModel.h"

@interface GCQuestionManager : NSObject

+(void) postAnswersQuestion:(NSString *)questionID forEvent:(NSString *)evendID inCompetition:(NSString *)competitionID withAnswers:(NSArray *)answersIDs cb_response:(void (^)(BOOL ok))cb_response;

+(void) getQuestionsForEvent:(NSString *)eventID inCompetition:(NSString *)competitionID cb_response:(void (^)(NSArray *questions))cb_response;

+(void) getQuestion:(NSString *)questionID forEvent:(NSString *)eventID inCompetition:(NSString *)competitionID cb_response:(void (^)(GCQuestionModel *question))cb_response;

@end
