//
//  PLGStatsBarView.h
//  PepsiLiveGaming
//
//  Created by Quimoune NetcoSports on 20/09/13.
//  Copyright (c) 2013 Édouard Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCAnswerModel.h"
#import "GCQuestionModel.h"
#import "GCView.h"

@interface GCStatsBarView : GCView

@property (strong, nonatomic) IBOutlet UIView *v_bar;
@property (strong, nonatomic) IBOutlet UIView *v_top;
@property (strong, nonatomic) IBOutlet UILabel *lb_is_answer;
@property (strong, nonatomic) IBOutlet UILabel *lb_percent;
@property (strong, nonatomic) IBOutlet UILabel *lb_response;
@property (weak, nonatomic) IBOutlet UIImageView *im_top;

-(void)initColorsAndFonts;
-(void)updateQuestionModel:(GCQuestionModel *)questionModel andIndex:(NSNumber *)index;
-(void)startBarAnimation;

@end
