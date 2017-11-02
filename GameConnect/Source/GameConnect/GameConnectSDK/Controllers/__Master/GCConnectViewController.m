//
//  GCConnectViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCConnectViewController.h"
#import "NsSnUserModel.h"
#import "GCGamerManager.h"
#import "GCProcessAuthentificationManager.h"
#import "GCFayeWorker.h"
#import "GCCompetitionManager.h"
#import "GCProcessLoadingManager.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCMasterViewController.h"

@interface GCConnectViewController()

@property (nonatomic) BOOL isCompetitionsRequested;

@end

@implementation GCConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.isCompetitionsRequested = NO;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

  self.view.backgroundColor = GC_BLUE_COLOR;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initGCFirstRequest) name:GCNOTIF_LOGGEDIN object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnectOrLoadData) name:GCNOTIF_PLATFORM_CHECKED object:nil];
	[self reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self reloadData];
}

- (void)reloadData
{
	if (self.skipAuthentification) {
		return;
	}

	if ([self isPlatformAvailable]) {
		[self reconnectOrLoadData];
	}
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

-(BOOL)isPlatformAvailable
{
	if (([GCGamerManager getInstance].platformsAvailabilityCheckDone == YES) &&
		([GCGamerManager getInstance].isPlatformAvailableToPlay == YES))
		return YES;
	else
	{
		[[GCProcessLoadingManager sharedManager] makePlatformeCheckFromViewController:self];
		return NO;
	}
}

-(void)reconnectOrLoadData
{
	if (![self isPlatformAvailable])
	{
		DLog(@"Platform not available !");
		return ;
	}

	__weak GCConnectViewController *weak_self = self;
	if (![[GCGamerManager getInstance] isLoggedIn] && ![[GCGamerManager getInstance] isLoggingIn])
	{
		if ([[GCGamerManager getInstance] canReconect])
		{
			[[GCProcessLoadingManager sharedManager] startLoadingWithData:@{@"gcLoadingText" : NSLocalizedString(@"gc_try_auto_login", nil)} fromViewController:self];

			[[GCGamerManager getInstance] autologin:nil cb_rep:^(BOOL ok, NsSnUserErrorValue error)
			 {
				 if (!ok)
					 [weak_self runAuthentificationProcess];
			 }];
		}
		else
			[self runAuthentificationProcess];
	}
	else if (![[GCGamerManager getInstance] isLoggingIn])
		[self initGCFirstRequest];
}

#pragma mark -  GameConnect first data request once connected - GetDefaultCompetition
-(void)initGCFirstRequest
{
	__weak GCConnectViewController *weak_self = self;
	[[GCFayeWorker getInstance] runFayeForGamer:[GCGamerManager getInstance].gamer];

	if ([GCCompetitionManager getInstance].competitionDefault)
	{
		[self loadData];
		[[GCProcessLoadingManager sharedManager] stopLoadingWithData:@{@"gcAccessGranted" : @1, @"gcLoadingText" : NSLocalizedString(@"gc_loaded", nil), @"gcSuperText" : NSLocalizedString(@"gc_connected", nil)} fromViewController:weak_self];
	}
	else if (!self.isCompetitionsRequested) {
		self.isCompetitionsRequested = YES;

		[[GCProcessLoadingManager sharedManager] startLoadingWithData:@{@"gcLoadingText" : NSLocalizedString(@"gc_loading_competitions", nil)} fromViewController:weak_self];

		[self startLoader];
		[NSObject backGroundBlock:^{
			[[GCCompetitionManager getInstance] getCompetitionsWithResponse:^(NSArray *competitions)
			 {
				 [NSObject mainThreadBlock:^{
					 weak_self.isCompetitionsRequested = NO;
					 if (!competitions || [competitions count] == 0)
					 {
						 [weak_self performSelector:@selector(initGCFirstRequest) withObject:nil afterDelay:2];
						 return;
					 }

					 [[GCFayeWorker getInstance] runFayeForCompetitions:competitions];

					 if ([weak_self respondsToSelector:@selector(setCompetitionModel:)])
						 [weak_self performSelector:@selector(setCompetitionModel:)withObject:[GCCompetitionManager getInstance].competitionDefault];

					 [[GCProcessLoadingManager sharedManager] stopLoadingWithData:@{@"gcAccessGranted" : @1, @"gcLoadingText" : NSLocalizedString(@"gc_loaded", nil), @"gcSuperText" : NSLocalizedString(@"gc_connected", nil)} fromViewController:weak_self];

					 [weak_self loadData];
					 [weak_self stopLoader];
				 }];
			 }];

		}];
	}
}

-(void)launchPopUpNoCompetition
{
	UIAlertView *alertViewCompetition = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"gc_no_competition", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"gc_popup_ok", nil) otherButtonTitles:nil];

	[alertViewCompetition show];
}

#pragma mark -  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self initGCFirstRequest];
}

#pragma mark - NSAPI DATA AUTHENTIFICATION
-(void)runAuthentificationProcess
{
	[[GCProcessLoadingManager sharedManager] startLoadingWithData:@{@"gcLoadingText" : NSLocalizedString(@"gc_authentification", nil)} fromViewController:self];
	[[GCProcessAuthentificationManager sharedManager] requestAuthentificationFrom:self];
}

-(void)loadData
{
	NSLog(@"[GCConnectViewController] => loadData");
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	//    NSLog(@"DEALLOC connect");
}

@end
