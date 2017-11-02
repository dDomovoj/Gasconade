//
//  NSLEEventManager.m
//  PepsiLiveGaming
//
//  Created by Derivery Guillaume on 9/12/13.
//  Copyright (c) 2013 Seb Jallot. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCQuestionManager.h"
#import "GCConfManager.h"
#import "GCQuestionModel.h"
#import "GCAnswerModel.h"
#import "GCRequester.h"
//#import "GCLoggerManager.h"

@implementation GCQuestionManager

+(void) postAnswersQuestion:(NSString *)questionID forEvent:(NSString *)evendID inCompetition:(NSString *)competitionID withAnswers:(NSArray *)answersIDs cb_response:(void (^)(BOOL ok))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLPOSTAnswers], competitionID, evendID, questionID);

    NSDictionary *postAnswerModel = [GCPostAnswerModel createPostAnswerModel:answersIDs];
    NSLog(@"POST ANSWER => %@", postAnswerModel);
    [GCRequester requestPOST:url post:postAnswerModel cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
     {
         if (httpcode == 201)
             cb_response(YES);
         else
         {
//             GCLog(GCHTTPResponseLog, (long)httpcode, url);
             cb_response(NO);
         }
    } cache:NO];
}

+(void) getQuestionsForEvent:(NSString *)eventID inCompetition:(NSString *)competitionID cb_response:(void (^)(NSArray *questions))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETAllEventQuestions], competitionID, eventID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
    {
//        GCLog(GCHTTPResponseLog, (long)httpcode, url);
        if (rep)
            cb_response([GCQuestionModel fromJSONArray:[rep getXpathNilArray:@"questions"]]);
        else
            cb_response(@[]);
    } cache:NO];
}

+(void) getQuestion:(NSString *)questionID forEvent:(NSString *)eventID inCompetition:(NSString *)competitionID cb_response:(void (^)(GCQuestionModel *question))cb_response
{
    NSString *url = SWF([GCConfManager getURL:GCURLGETEventQuestion], competitionID, eventID, questionID);
    [GCRequester requestGET:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode)
     {
//         GCLog(GCHTTPResponseLog, (long)httpcode, url);
         cb_response([GCQuestionModel fromJSON:[rep getXpathNilDictionary:@"question"]]);
     } cache:NO];
}

@end
