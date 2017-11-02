//
//  GCAPPLeagueEdition.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLeagueEditionViewController.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCAPPLeagueEditionViewController ()
{
    UIBarButtonItem *cancelBarButton;
    eLeagueEditionState editionState;
}
@end

@implementation GCAPPLeagueEditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        editionState = eLeagueEditionNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"gc_league_edition", nil);
    
    [self setCancelBarButton];
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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidChangeFrameNotification
//                                               object:nil];

    [self setUpLeagueModification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [leagueEdition.sv_leagueContent setContentSize:CGSizeMake(leagueEdition.sv_leagueContent.frame.size.width, leagueEdition.v_containerLeagueEdition.frame.origin.y + leagueEdition.v_containerLeagueEdition.frame.size.height)];
}

-(void)setCancelBarButton
{
    cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"gc_cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelBarButton)];
}

-(void)clickCancelBarButton
{
    [leagueEdition.view resignAllResponder];
}

-(void)setUpLeagueModification
{
    leagueEdition = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCLeagueEditionVCIdentifier];
    leagueEdition.leagueEditing = self.leagueToEdit;
    [self.v_containerLeagueEdition addSubviewToBonce:leagueEdition.view autoSizing:YES];
    [self addChildViewController:leagueEdition];
    
    [leagueEdition initWithLeagueEditionState:editionState];
}

-(void) goToLeagueCreation
{
    editionState = eLeagueEditionBoth;
    if (leagueEdition)
        [leagueEdition initWithLeagueEditionState:eLeagueEditionName];
}

-(void) goToLeagueNameModification
{
    editionState = eLeagueEditionName;
    if (leagueEdition)
    {
        [leagueEdition initWithLeagueEditionState:eLeagueEditionName];
    }
}

-(void) goToLeagueInvitation
{
    editionState = eLeagueEditionInvitation;
    if (leagueEdition)
    {
        [leagueEdition initWithLeagueEditionState:eLeagueEditionInvitation];
    }
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
