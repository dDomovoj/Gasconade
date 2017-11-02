//
//  GCNotificationView.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 11/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCNotificationView.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCNotificationView()
{
    NSMutableArray *questionsPending;
    NSMutableArray *questionsResultsAndTrophies;
}
@end

@implementation GCNotificationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.7f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    return ;
    
    // Drawing code
    CGRect b = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGPathRef circlePath = CGPathCreateWithEllipseInRect(b, 0);
    CGMutablePathRef inverseCirclePath = CGPathCreateMutableCopy(circlePath);
    CGPathAddRect(inverseCirclePath, nil, CGRectInfinite);
    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
        //        [_image drawInRect:b];
    } CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
        
//        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3.0f, [UIColor colorWithRed:0.994 green:0.989 blue:1.000 alpha:1.0f].CGColor);
        
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, inverseCirclePath);
        CGContextEOFillPath(ctx);
    } CGContextRestoreGState(ctx);
    
    CGPathRelease(circlePath);
    CGPathRelease(inverseCirclePath);
    
    CGContextRestoreGState(ctx);
}

-(void) myInit
{
    self.layer.cornerRadius = self.frame.size.width/2;
    self.v_numberOfNotifications.layer.cornerRadius = self.v_numberOfNotifications.frame.size.width/2;
    [self.v_numberOfNotifications setBackgroundColor:CONFCOLORFORKEY(@"notification_nb_bg")];
    [self.lb_numberOfNotifications setTextColor:CONFCOLORFORKEY(@"notification_nb_lb")];
}

-(NSArray *) getAvailableQuestions
{
    NSMutableArray *pendingQuestions = [[NSMutableArray alloc] init];
    
    for (GCQuestionModel *questionModel in questionsPending)
    {
        if ([questionModel isQuestionActive])
            [pendingQuestions addObject:questionModel];
    }
    questionsPending = pendingQuestions;
    [self setNumberOfNotifications:[questionsPending count]];
    return questionsPending;
}


-(NSArray *) getAllQuestions
{
    return questionsPending;
}

-(NSArray *) getAvailablePushInfo
{
    return questionsResultsAndTrophies;
}

-(void) updateWithTrophy:(GCTrophyModel *)trophyModel
{
    if (questionsPending && [questionsPending count])
    {
        DLog(@"Cannot be a trophy notif, i am a pending question notif");
        return;
    }
    if (!questionsResultsAndTrophies)
        questionsResultsAndTrophies = [NSMutableArray new];
    
    [questionsResultsAndTrophies addObject:trophyModel];
    [self.iv_notificationPicture setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Notification/Bubble/picto_notif_trophy"]];
    
    [self setNumberOfNotifications:[questionsResultsAndTrophies count]];
}


-(void) updateWithQuestionResult:(GCQuestionModel *)questionModel
{
    if (questionsPending && [questionsPending count])
    {
        DLog(@"Cannot be a question results notif, i am a pending question notif");
        return;
    }
    if (!questionsResultsAndTrophies)
        questionsResultsAndTrophies = [NSMutableArray new];
    
    [questionsResultsAndTrophies addObject:questionModel];
    [self.iv_notificationPicture setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Notification/Bubble/picto_notif_trophy"]];

    [self setNumberOfNotifications:[questionsResultsAndTrophies count]];
}

-(void) updateWithNewQuestion:(GCQuestionModel *)questionModel
{
    if (questionsResultsAndTrophies && [questionsResultsAndTrophies count])
    {
        DLog(@"Cannot be a pending question notif, i am a pending question results notif");
        return;
    }

    if (!questionsPending)
        questionsPending = [NSMutableArray new];

    [questionsPending addObject:questionModel];
    [self.iv_notificationPicture setImage:[UIImage imageNamed:@"GCBundleRessources.bundle/Notification/Bubble/picto_notif_question"]];
    
    self.v_numberOfNotifications.layer.cornerRadius = self.v_numberOfNotifications.frame.size.width/2;
    
    [self setNumberOfNotifications:[questionsPending count]];
}

-(void) removeAQuestion:(GCQuestionModel *)questionModel
{
   NSIndexSet *indexOfQuestion = nil;
    for (id object in questionsPending)
    {
        if ([questionModel._id isEqualToString:((GCQuestionModel *)object)._id])
            indexOfQuestion = [NSIndexSet indexSetWithIndex:[questionsPending indexOfObject:object]];
    }
    if (indexOfQuestion)
        [questionsPending removeObjectsAtIndexes:indexOfQuestion];

    [self setNumberOfNotifications:[questionsPending count]];
}

-(void) removeAllQuestions
{
    if (questionsPending)
        [questionsPending removeAllObjects];
    [self.v_numberOfNotifications setHidden:YES];
}

-(void) removeAllPuhsInfo
{
    if (questionsResultsAndTrophies)
        [questionsResultsAndTrophies removeAllObjects];
    [self.v_numberOfNotifications setHidden:YES];
}

-(void) setNumberOfNotifications:(NSUInteger)numberOfNotifications
{
    [self.lb_numberOfNotifications setText:SWF(@"%ld", (unsigned long)numberOfNotifications)];
    [self.v_numberOfNotifications setHidden:NO];
}

@end
