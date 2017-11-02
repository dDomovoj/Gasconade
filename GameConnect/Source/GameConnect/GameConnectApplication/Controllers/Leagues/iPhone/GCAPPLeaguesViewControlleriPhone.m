//
//  GCAPPLeaguesViewControlleriPhone.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCBluredImageSingleton.h"
#import "GCAPPLeaguesViewControlleriPhone.h"
#import "GCProcessLeagueManager.h"
#import "GCAPPDefines.h"

@interface GCAPPLeaguesViewControlleriPhone ()

@end

@implementation GCAPPLeaguesViewControlleriPhone

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
    [self setUpNavbarButton];
    
    leagues.leagueSelectionActive = NO;
}

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

-(void)setUpNavbarButton
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_league_icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickAddLeague:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)clickAddLeague:(id)sender
{
    [[GCProcessLeagueManager sharedManager] requestLeagueEdition:nil fromViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
