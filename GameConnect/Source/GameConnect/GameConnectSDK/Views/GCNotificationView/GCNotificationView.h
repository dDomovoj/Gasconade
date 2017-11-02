//
//  GCNotificationView.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 11/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCQuestionModel.h"
#import "GCTrophyModel.h"
#import "CHDraggableView.h"

@interface GCNotificationView : CHDraggableView

@property (weak, nonatomic) IBOutlet UIImageView *iv_notificationPicture;
@property (weak, nonatomic) IBOutlet UIView *v_numberOfNotifications;
@property (weak, nonatomic) IBOutlet UILabel *lb_numberOfNotifications;

-(void) myInit;
-(void) updateWithTrophy:(GCTrophyModel *)trophyModel;
-(void) updateWithQuestionResult:(GCQuestionModel *)questionModel;
-(void) updateWithNewQuestion:(GCQuestionModel *)questionModel;

-(NSArray *) getAllQuestions;
-(NSArray *) getAvailablePushInfo;
-(NSArray *) getAvailableQuestions;

-(void) removeAllQuestions;
-(void) removeAllPuhsInfo;

-(void) removeAQuestion:(GCQuestionModel *)questionModel;

-(void) setNumberOfNotifications:(NSUInteger)numberOfNotifications;

@end
