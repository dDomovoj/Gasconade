//
//  GCPushInfoView.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 24/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCView.h"
#import "GCTrophyModel.h"
#import "GCQuestionModel.h"
#import "UIImageViewJA.h"

typedef enum
{
    ePushInfoBadge,
    ePushInfoQuestionResult,
} ePushInfoType;

@protocol GCPushInfoViewDelegate <NSObject>
@optional
-(void) GCDidRequestToShare:(GCModel *)modelToShare fromSender:(GCView *)senderView;
@end

@interface GCPushInfoView : GCView

// General
@property (weak, nonatomic) IBOutlet UIView *v_pushInfoBackground;
@property (weak, nonatomic) IBOutlet UIView *v_pushInfobottomBackground;
@property (weak, nonatomic) IBOutlet UIView *v_pushInfoPoints;
@property (weak, nonatomic) IBOutlet UIImageViewJA *iv_pushInfoImage;
@property (weak, nonatomic) IBOutlet UITextView *tv_mainTitlePushInfo;
@property (weak, nonatomic) IBOutlet UITextView *tv_subTitlePushInfo;
@property (weak, nonatomic) IBOutlet UIButton *bt_sharing;

@property (copy, nonatomic) void(^callBackClosingView)(void);
@property (strong, nonatomic) GCQuestionModel *questionModel;
@property (strong, nonatomic) GCTrophyModel *trophyModel;
@property (weak, nonatomic) id<GCPushInfoViewDelegate> delegate;

-(void) updateWithTrophyModel:(GCTrophyModel *)trophyModel;
-(void) updateWithQuestionModel:(GCQuestionModel *)questionModel;

@end
