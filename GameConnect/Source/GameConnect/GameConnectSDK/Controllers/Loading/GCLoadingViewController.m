//
//  GCLoadingViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 15/05/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCLoadingViewController.h"
#import "GCGamerManager.h"
#import "GCProcessAuthentificationManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCLoadingViewController ()
{
    void (^callBackRefreshing)(void);
}
- (IBAction)clickOnRefresh:(id)sender;
@end

@implementation GCLoadingViewController

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
    [self initFontsAndColors];
}

-(BOOL)checkUpPlatform
{
    __weak GCLoadingViewController *weak_self = self;
    callBackRefreshing = ^{
        [[GCGamerManager getInstance] checkPlatformsAvailability:^(BOOL isPlatformAvailableToPlay) {
            [weak_self checkUpPlatform];
        }];
    };
    
    if (([GCGamerManager getInstance].platformsAvailabilityCheckDone == NO) &&
        [GCGamerManager getInstance].platformsAvailabilityCheckRequested == NO)
    {
        [self startLoading];
        [self setLoadingData:@{@"gcLoadingText" : NSLocalizedString(@"gc_check_game_platform_availability", nil)}];
        if (callBackRefreshing)
            callBackRefreshing();
        return NO;
    }
    else if (([GCGamerManager getInstance].platformsAvailabilityCheckDone == NO) &&
             [GCGamerManager getInstance].platformsAvailabilityCheckRequested == YES)
        return NO;
    else if ([GCGamerManager getInstance].platformsAvailabilityCheckDone == YES &&
             ([GCGamerManager getInstance].isPlatformAvailableToPlay == NO))
    {
        [self endLoading];
        [self setLoadingData:@{@"gcAccessGranted" : @0, @"gcLoadingText" : NSLocalizedString(@"gc_loaded", nil), @"gcSuperText" : NSLocalizedString(@"gc_platform_not_available", nil)}];
        [self.bt_refresh setAlpha:1];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initFontsAndColors
{
    [self.v_background setBackgroundColor:CONFCOLORFORKEY(@"loading_bg")];
    [self.lb_loadingText setTextColor:CONFCOLORFORKEY(@"loading_text_lb")];
    [self.lb_loadingText setFont:CONFFONTREGULARSIZE(17)];
    [self.bt_refresh setAlpha:0];
}

-(void)startLoading
{
    [self.v_loader setLoaderStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.v_loader startLoader];
}

-(void)endLoading
{
    [self.v_loader stopLoader];
}

-(void)setLoadingData:(NSDictionary *)userInfo
{
    NSString *text = [userInfo getXpathNilString:@"gcLoadingText"];
    NSAttributedString *attributedText = [userInfo getXpathNil:@"gcLoadingAttributedText" type:[NSAttributedString class]];

    NSString *superText = [userInfo getXpathNilString:@"gcSuperText"];
    NSAttributedString *superAttributedText = [userInfo getXpathNil:@"gcSuperAttributedText" type:[NSAttributedString class]];
    
    if (userInfo && superText)
        [self setSuperText:superText];
    else if (userInfo && superAttributedText)
        [self setSuperAttributedText:superAttributedText];
    else
    {
        if (userInfo && text)
            [self setLoadingText:text];
        else if (userInfo && attributedText)
            [self setLoadingAttributedText:attributedText];
    }
}

#pragma SUPER TEXT
-(void)setSuperText:(NSString *)superText
{
    [self endLoading];
    [self setText:superText];
    [self.bt_refresh setAlpha:1];
}

-(void)setSuperAttributedText:(NSAttributedString *)superAttributedText
{
    [self endLoading];
    [self setAttributedText:superAttributedText];
    [self.bt_refresh setAlpha:1];
}

#pragma LOADING TEXT
-(void)setLoadingText:(NSString *)text
{
    [self.bt_refresh setAlpha:0];
    [self setText:text];
}

-(void)setLoadingAttributedText:(NSAttributedString *)superAttributedText
{
    [self.bt_refresh setAlpha:0];
    [self setAttributedText:superAttributedText];
}

#pragma TEXT
-(void)setText:(NSString *)text
{
    [self.bt_refresh setAlpha:0];
    [self.lb_loadingText setFont:CONFFONTREGULARSIZE(17)];
    self.lb_loadingText.textAlignment = NSTextAlignmentLeft;

    if (!text || [text length] == 0)
        [self.lb_loadingText setText:@""];
    else
        [self.lb_loadingText setText:text];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [self.bt_refresh setAlpha:0];
    [self.lb_loadingText setFont:CONFFONTREGULARSIZE(17)];
    self.lb_loadingText.textAlignment = NSTextAlignmentLeft;

    if (!attributedText || [attributedText.string length] == 0)
        [self.lb_loadingText setText:@""];
    else
        [self.lb_loadingText setAttributedText:attributedText];
}

- (IBAction)clickOnRefresh:(id)sender
{
    [self.bt_refresh setAlpha:0];
    [self startLoading];
    
    if (callBackRefreshing)
    {
        callBackRefreshing();
    }
    else
    {
        DLog(@"Callback block for refreshing doesn't exist");
        [[GCProcessAuthentificationManager sharedManager]requestAuthentificationFrom:nil];
    }
}

@end
