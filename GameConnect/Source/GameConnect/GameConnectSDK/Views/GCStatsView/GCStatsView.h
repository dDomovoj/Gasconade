//
//  PLGStatsBarManagerViews.h
//  PepsiLiveGaming
//
//  Created by Quimoune NetcoSports on 20/09/13.
//  Copyright (c) 2013 Édouard Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCView.h"
#import "GCQuestionModel.h"

@interface GCStatsView : GCView

-(void)initWithQuestion:(GCQuestionModel *)questionModel;
-(void)startBarsAnimations;
-(void)updateAnswersWithQuestionModel:(GCQuestionModel *)questionModel;
-(void)reDraw;

@end
