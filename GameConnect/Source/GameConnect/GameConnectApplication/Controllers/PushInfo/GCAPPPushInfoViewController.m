//
//  GCAPPPushInfoViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 22/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPPushInfoViewController.h"
#import "GCBluredImageSingleton.h"

@interface GCAPPPushInfoViewController ()
{
    NSMutableArray *pushInfos;
    NSInteger preselectedIndex;
}
@end

@implementation GCAPPPushInfoViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpPushInfo];
}

-(void)setUpPushInfo
{
    if (!pushInfoViewController)
    {
        pushInfoViewController = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCPushInfoVCIdentifier];
        [self.v_containerPushInfo addSubviewToBonce:pushInfoViewController.view autoSizing:YES];
        [self addChildViewController:pushInfoViewController];
        [pushInfoViewController addPushInfos:pushInfos];
        [pushInfoViewController preselectItemAtIndex:preselectedIndex];
    }
}

-(void) preselectItemAtIndex:(NSInteger)preselectedItemIndex
{
    if (pushInfoViewController)
    {
        if ([pushInfoViewController isViewLoaded])
            [pushInfoViewController.ic_view scrollToItemAtIndex:preselectedItemIndex animated:TRUE];
    }
    preselectedIndex = preselectedItemIndex;
}

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

-(void)addPushInfos:(NSArray *)questionsAndTrophies
{
    if (questionsAndTrophies && [questionsAndTrophies count] > 0)
    {
        if (!pushInfos)
            pushInfos = [NSMutableArray new];
        [pushInfos addObjectsFromArray:questionsAndTrophies];
    }
    if (pushInfoViewController)
        [pushInfoViewController addPushInfos:questionsAndTrophies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
