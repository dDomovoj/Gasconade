//
//  GCBadgeViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "UIImageViewJA.h"
#import "GCTrophyModel.h"
#import "GCQuestionModel.h"
#import "GCAnswerModel.h"
#import "GCPushInfoView.h"
#import "iCarousel.h"

@interface GCPushInfoViewController : GCConnectViewController <GCPushInfoViewDelegate, iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *ic_view;

-(void) addPushInfos:(NSArray *)questionsAndTrophies;
-(void) preselectItemAtIndex:(NSInteger)preselectedItemIndex;

@end
