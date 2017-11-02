//
//  GCAPPLoginViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLoginViewController.h"
#import "Extends+Libs.h"
#import "GCBluredImageSingleton.h"

#import "GCAPPNavigationManager.h"
#import "GCConfManager.h"

@interface GCAPPLoginViewController ()
{
    UIBarButtonItem *cancelBarButton;
}
@end

@implementation GCAPPLoginViewController

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
    
    [self setCancelBarButton];
    [self setUpLogin];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [login.sv_loginElements setContentSize:CGSizeMake(login.sv_loginElements.frame.size.width, login.v_loginContent.frame.origin.y + login.v_loginContent.frame.size.height)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view resignAllResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)setUpLogin
{
    login = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCLoginVCIdentifier];
    [self.v_containerLogin addSubviewToBonce:login.view autoSizing:YES];
    [self addChildViewController:login];
    //[login insertSocialNetworkConnect:eNsSnThirdPartyConnectionFB];
}

-(void)setCancelBarButton
{
     cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:[NSLocalizedString(@"gc_cancel", nil) capitalizedString]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(clickCancelBarButton)];
}

-(void)clickCancelBarButton
{
    [login.view resignAllResponder];
}

#pragma Keyboard Notifications
- (void)keyboardWillShow: (NSNotification *)notification
{
//    self.navigationItem.rightBarButtonItem = cancelBarButton;
}

- (void)keyboardDidShow: (NSNotification *)notification
{
}

- (void)keyboardWillHide: (NSNotification *)notification
{
//    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
