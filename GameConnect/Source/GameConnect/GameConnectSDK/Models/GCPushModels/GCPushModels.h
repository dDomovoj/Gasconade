//
//  GCPushModels.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCModel.h"
#import "GCQuestionModel.h"

typedef enum
{
    // Event Questions
    eGCPushTypeStartQuestion,
    eGCPushTypeEndQuestion,
    eGCPushTypeStatsQuestion,
    
    // Gamer
    eGCPushTypeEarnedTrophy,
    eGCPushTypeScoreQuestion,
    eGCPushTypeRankingEvent,
    
    // Competition Events
    eGCPushTypeStartEvent,
    eGCPushTypeEndEvent,
    
    eGCPushTypeNone,
} eGCPushType;

@interface GCPushModel : GCModel
@property (nonatomic) eGCPushType type;
@property (strong, nonatomic) NSDate *gc_timestamp;

+(eGCPushType) pushTypeFromString:(NSString *)type;

@end

// Question Channel
@interface GCPushQuestionModel : GCModel
@property (strong, nonatomic) GCPushModel *pushInfo;
@property (strong, nonatomic) GCQuestionModel *question;
@end

// User Channel
@interface GCPushTrophyModel : GCModel
@property (strong, nonatomic) GCPushModel *pushInfo;
@property (strong, nonatomic) NSString *trophy_id;
@end

@interface GCPushScoreQuestionModel : GCModel
@property (strong, nonatomic) GCPushModel *pushInfo;
@property (strong, nonatomic) NSString *question_id;
@property (strong, nonatomic) NSString *event_id;
@property (strong, nonatomic) NSString *competition_id;
@property (assign, nonatomic) NSUInteger score;
@end

@interface GCPushRankingEventModel : GCModel
@property (strong, nonatomic) GCPushModel *pushInfo;
@property (strong, nonatomic) NSString *event_id;
@property (strong, nonatomic) NSString *competition_id;
@property (assign, nonatomic) NSUInteger score;
@property (assign, nonatomic) NSUInteger rank;
@end

@interface GCPushEventModel : GCModel
@property (strong, nonatomic) GCPushModel *pushInfo;
@property (strong, nonatomic) GCEventModel *event;
@end
