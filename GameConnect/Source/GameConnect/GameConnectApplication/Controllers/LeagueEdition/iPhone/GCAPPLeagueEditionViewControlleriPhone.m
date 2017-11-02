//
//  GCAPPLeagueEditionViewControlleriPhone.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLeagueEditionViewControlleriPhone.h"

@implementation GCAPPLeagueEditionViewControlleriPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma Keyboard Notifications
- (void)keyboardDidShow: (NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.v_containerLeagueEdition setFrame:CGRectMake(self.v_containerLeagueEdition.frame.origin.x, self.v_containerLeagueEdition.frame.origin.y, self.v_containerLeagueEdition.frame.size.width, self.v_containerLeagueEdition.frame.size.height - keyboardSize.height)];
    
    [leagueEdition.sv_leagueContent setContentSize:CGSizeMake(leagueEdition.sv_leagueContent.frame.size.width, leagueEdition.v_containerLeagueEdition.frame.origin.y + leagueEdition.v_containerLeagueEdition.frame.size.height)];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = nil;
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.v_containerLeagueEdition setFrame:CGRectMake(self.v_containerLeagueEdition.frame.origin.x, self.v_containerLeagueEdition.frame.origin.y, self.v_containerLeagueEdition.frame.size.width, self.v_containerLeagueEdition.frame.size.height + keyboardSize.height)];
    [leagueEdition.sv_leagueContent setContentSize:CGSizeMake(leagueEdition.sv_leagueContent.frame.size.width, leagueEdition.v_containerLeagueEdition.frame.origin.y + leagueEdition.v_containerLeagueEdition.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

@end
