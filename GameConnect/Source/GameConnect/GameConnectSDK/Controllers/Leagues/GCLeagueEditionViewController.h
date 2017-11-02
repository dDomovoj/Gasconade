//
//  GCLeagueEditionViewController.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "GCLeagueModel.h"
#import "UICollectionViewGG.h"

@class FBLoginView;

typedef enum
{
    eLeagueEditionName,
    eLeagueEditionInvitation,
    eLeagueEditionBoth,
    eLeagueEditionNone,
} eLeagueEditionState;

@interface GCLeagueEditionViewController : GCConnectViewController <UITextFieldDelegate, UICollectionViewGGDelegate>

@property (strong, nonatomic) FBLoginView *bt_fb_login;
@property (weak, nonatomic) IBOutlet UIScrollView *sv_leagueContent;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIView *v_background;
@property (weak, nonatomic) IBOutlet UIView *v_containerLeagueEdition;
@property (weak, nonatomic) IBOutlet UIView *v_containerLeagueName;
@property (weak, nonatomic) IBOutlet UIView *v_facebookLogin;
@property (weak, nonatomic) IBOutlet UITextField *tf_leagueName;
@property (weak, nonatomic) IBOutlet UIButton *bt_save;

@property (strong, nonatomic) GCLeagueModel *leagueEditing;

-(void)initWithLeagueEditionState:(eLeagueEditionState)leagueEditionState;

@end
