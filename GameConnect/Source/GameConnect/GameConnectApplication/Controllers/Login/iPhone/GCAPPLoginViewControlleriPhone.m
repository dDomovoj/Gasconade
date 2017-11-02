//
//  GCAPPLoginViewControlleriPhone.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLoginViewControlleriPhone.h"

@interface GCAPPLoginViewControlleriPhone ()
{
    CGFloat diffHeightBottom;
}
@end

@implementation GCAPPLoginViewControlleriPhone

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

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:@"gc_main_background"]];
}

#pragma Keyboard Notifications
- (void)keyboardDidShow: (NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    diffHeightBottom = (self.view.frame.size.height - (self.v_containerLogin.frame.origin.y + self.v_containerLogin.frame.size.height));
    
    [self.v_containerLogin setFrame:CGRectMake(self.v_containerLogin.frame.origin.x, self.v_containerLogin.frame.origin.y, self.v_containerLogin.frame.size.width, self.v_containerLogin.frame.size.height - keyboardSize.height + diffHeightBottom)];
    
    [login.sv_loginElements setContentSize:CGSizeMake(login.sv_loginElements.frame.size.width, login.v_loginContent.frame.origin.y + login.v_loginContent.frame.size.height)];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = nil;
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self.v_containerLogin setFrame:CGRectMake(self.v_containerLogin.frame.origin.x, self.v_containerLogin.frame.origin.y, self.v_containerLogin.frame.size.width, self.v_containerLogin.frame.size.height + keyboardSize.height - diffHeightBottom)];
    
    [login.sv_loginElements setContentSize:CGSizeMake(login.sv_loginElements.frame.size.width, login.v_loginContent.frame.origin.y + login.v_loginContent.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
