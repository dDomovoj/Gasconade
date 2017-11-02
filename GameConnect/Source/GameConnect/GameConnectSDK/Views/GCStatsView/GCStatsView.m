//
//  PLGStatsBarManagerViews.m
//  PepsiLiveGaming
//
//  Created by ; ; on 20/09/13.
//  Copyright (c) 2013 Édouard Richard. All rights reserved.
//

#import "GCStatsView.h"
#import "GCStatsBarView.h"
#import "Extends+Libs.h"
#import "GCAnswerModel.h"

@interface GCStatsView()
{
    NSMutableArray *answerStatsViews;
    GCQuestionModel *questionForStats;
}
@end

@implementation GCStatsView

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
    [self reDraw];
}

-(void)initWithQuestion:(GCQuestionModel *)questionModel
{
    questionForStats = questionModel;
    if (answerStatsViews)
    {
        [answerStatsViews removeAllObjects];
        [self clearSubview];
    }
    answerStatsViews = nil;

    if (questionModel.answers && [questionModel.answers count] > 0)
    {
        CGFloat nbAnswer = [questionModel.answers count];
        CGFloat theWidth = (self.frame.size.width / nbAnswer);
        answerStatsViews = [[NSMutableArray alloc] initWithCapacity:nbAnswer];

        for (NSUInteger i = 0; i < [questionModel.answers count]; i++)
        {
            GCStatsBarView *statBarView = [[[NSBundle mainBundle] loadNibNamed:@"GCStatsBarView" owner:self options:nil] getObjectsType:[GCStatsBarView class]];
            [statBarView setFrame:CGRectMake(i * theWidth, self.frame.size.height - statBarView.frame.size.height, theWidth, statBarView.frame.size.height)];
            [self addSubview:statBarView];
            [statBarView initColorsAndFonts];
            [statBarView updateQuestionModel:questionModel andIndex:[NSNumber numberWithInteger:i]];
            [answerStatsViews addObject:statBarView];
            [statBarView startBarAnimation];
        }
    }
}

-(void)reDraw
{
    if (questionForStats)
    {
        [self clearSubview];
        [answerStatsViews removeAllObjects];
        [self initWithQuestion:questionForStats];
    }
}

-(void)startBarsAnimations
{
    NSUInteger i = 0;
    for (GCStatsBarView *statBarView in answerStatsViews)
    {
        [statBarView performSelectorOnMainThread:@selector(startBarAnimation) withObject:nil waitUntilDone:NO];

//        [self performWithDelay:1 block:^{
//            if (statBarView.frame.origin.y + statBarView.frame.size.height > self.frame.size.height)
//            {
//                CGFloat diffHeight = statBarView.frame.origin.y + statBarView.frame.size.height - self.frame.size.height;
//                [statBarView setFrame:CGRectMake(statBarView.frame.origin.x, statBarView.frame.origin.y - diffHeight, statBarView.frame.size.width, statBarView.frame.size.height)];
//            }
//        }];
        i++;
    }
}

-(void)updateAnswersWithQuestionModel:(GCQuestionModel *)questionModel;
{
    for (NSUInteger i = 0; i < [questionModel.answers count]; i++)
    {
        if (i < [answerStatsViews count])
        {
            __weak GCStatsBarView *statBarView = [answerStatsViews objectAtIndex:i];
            if (statBarView && [statBarView isKindOfClass:[GCStatsBarView class]])
            {
                [statBarView updateQuestionModel:questionModel andIndex:[NSNumber numberWithInteger:i]];
                [statBarView performSelectorOnMainThread:@selector(startBarAnimation) withObject:nil waitUntilDone:NO];
            }
            else
                DLog(@"StatsBarBView doens't exist!");
        }
        else
            break;
    }
}


@end
