//
//  GCAPPLeaguesViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/1/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLeaguesViewController.h"
#import "Extends+Libs.h"

@interface GCAPPLeaguesViewController ()
@end

@implementation GCAPPLeaguesViewController

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
    self.title = NSLocalizedString(@"gc_my_leagues", nil);
    [self setUpLeaguesList];
}

-(void)setUpLeaguesList
{
    leagues = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCLeaguesVCIdentifier];

    [self.v_containerLeaguesList addSubviewToBonce:leagues.view autoSizing:YES];
    [self addChildViewController:leagues];
    
    [leagues.cv_leagues setDynamicFlowLayoutEnable:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    NSLog(@">>>>> DEACLLO APP Leagues");
}

@end
