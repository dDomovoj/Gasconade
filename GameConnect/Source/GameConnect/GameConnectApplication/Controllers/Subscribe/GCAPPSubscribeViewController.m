//
//  GCAPPSubscribeViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPSubscribeViewController.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCAPPSubscribeViewController ()

@end

@implementation GCAPPSubscribeViewController

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
//    self.title = [NSLocalizedString(@"gc_subscribe", nil) capitalizedString];

    [self setCancelBarButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpSubscribe];
    
    [subscribe.sc_scroll setContentSize:CGSizeMake(subscribe.sc_scroll.frame.size.width, subscribe.v_subscribeContent.frame.origin.y + subscribe.v_subscribeContent.frame.size.height)];
    
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

-(void)setUpSubscribe
{
    subscribe = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCSubscribeVCIdentifier];
    [self.v_containerSubscribe addSubviewToBonce:subscribe.view autoSizing:YES];
    [self addChildViewController:subscribe];
    
//    [subscribe.tf_dateOfBirth setHidden:YES];
//    [subscribe.v_checkingDateOfBirth setHidden:YES];
//    [subscribe.iv_bgDateOfBirth setHidden:YES];
    
//    [subscribe setMandatoryInfoType:NSProfileInfoGender];
//    [subscribe setMandatoryInfoType:NSProfileInfoFirstName];
//    [subscribe setMandatoryInfoType:NSProfileInfoLastName];
//    [subscribe setMandatoryInfoType:NSProfileInfoDoB];
}

-(void)setCancelBarButton
{
    cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:[NSLocalizedString(@"gc_cancel", nil) capitalizedString] style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelBarButton)];
}

-(void)clickCancelBarButton
{
    [subscribe.view resignAllResponder];
}

#pragma Keyboard Notifications
- (void)keyboardWillShow: (NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = cancelBarButton;
}

- (void)keyboardDidShow: (NSNotification *)notification
{
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = nil;
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
