//
//  GCAPPLoginViewControlleriPad.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLoginViewControlleriPad.h"
#import "GCBluredImageSingleton.h"

@interface GCAPPLoginViewControlleriPad ()

@end

@implementation GCAPPLoginViewControlleriPad

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
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

#pragma Keyboard Notifications
- (void)keyboardDidShow:(NSNotification *) notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat diffBottom = self.view.frame.size.height - (self.v_containerLogin.superview.frame.origin.y + self.v_containerLogin.superview.frame.size.height) + (self.v_containerLogin.superview.frame.size.height - (self.v_containerLogin.frame.origin.y + self.v_containerLogin.frame.size.height));

    [self.v_containerLogin setFrame:CGRectMake(self.v_containerLogin.frame.origin.x,
                                               self.v_containerLogin.frame.origin.y,
                                               self.v_containerLogin.frame.size.width,
                                               self.v_containerLogin.frame.size.height - (([[[UIDevice currentDevice]systemVersion]floatValue] >= 8) ? keyboardSize.height : keyboardSize.width) + diffBottom)];
    [login.sv_loginElements setContentSize:CGSizeMake(login.sv_loginElements.frame.size.width, login.v_loginContent.frame.origin.y + login.v_loginContent.frame.size.height)];
}

- (void)keyboardWillHide:(NSNotification *) notification
{
    self.navigationItem.rightBarButtonItem = nil;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.v_containerLogin setFrame:CGRectMake(self.v_containerLogin.frame.origin.x,
                                               self.v_containerLogin.frame.origin.y,
                                               self.v_containerLogin.frame.size.width,
                                               self.v_containerLogin.frame.size.height + keyboardSize.height)];

    [login.sv_loginElements setContentSize:CGSizeMake(login.sv_loginElements.frame.size.width, login.v_loginContent.frame.origin.y + login.v_loginContent.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
