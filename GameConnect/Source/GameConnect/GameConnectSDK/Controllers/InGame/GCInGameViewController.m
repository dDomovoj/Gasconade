//
//  GCInGameViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCInGameViewController.h"
#import "GCQuestionModel.h"
#import "Extends+Libs.h"
#import "DefaultCellRenderGG.h"
#import "GCProcessQuestionManager.h"
#import "GCQuestionRender.h"
#import "GCQuestionManager.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCInGameViewController ()
- (IBAction)changeSegmentedControlValue:(id)sender;
@end

@implementation GCInGameViewController

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
    [self changeSegmentedControlValue:self.sc_questionsResults];

    [self initSegmentedControl];
    [self initQuestionsList];
    [self initResultsList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cv_questionsGame startAutoRefreshWithSeconds:[[[GCConfManager getInstance] getValue:GCConfigAutorefreshQuestions] intValue]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cv_questionsGame endAutoRefresh];
}

-(void)initResultsList
{
    [self.cv_resultsGame setDelegateGG:self];
    [self.cv_resultsGame setParentViewController:self];
    [self.cv_resultsGame setRender:[GCQuestionRender class]];
    [self.cv_resultsGame setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_resultsGame setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_resultsGame setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_results_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
    [self.cv_resultsGame loadConfiguration];
    [self.cv_resultsGame setMinimumLineSpacing:20];

    __weak GCInGameViewController *weak_self = self;
    [self.cv_resultsGame setCallRefresh:^{
        [weak_self loadData];
    }];
}

-(void)initQuestionsList
{
    [self.cv_questionsGame setDelegateGG:self];
    [self.cv_questionsGame setParentViewController:self];
    [self.cv_questionsGame setRender:[GCQuestionRender class]];
    [self.cv_questionsGame setSimpleDataRenderingUsingXpath:@"flux"];
    [self.cv_questionsGame setRefreshControlColor:CONFCOLORFORKEY(@"activity_loaders")];
    [self.cv_questionsGame setAttributedNoDataText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"gc_no_questions_available", nil) attributes:@{NSFontAttributeName: CONFFONTREGULARSIZE(17), NSForegroundColorAttributeName: CONFCOLORFORKEY(@"no_data_list_lb")}]];
    [self.cv_questionsGame loadConfiguration];
    [self.cv_questionsGame setMinimumLineSpacing:20];
    
    __weak GCInGameViewController *weak_self = self;
    [self.cv_questionsGame setCallRefresh:^{
        [weak_self loadData];
    }];
}

-(void)loadData
{
    __weak GCInGameViewController *weak_self = self;
    if (self.eventModel && self.eventModel._id && !self.preloadedQuestions)
    {
        [self.cv_questionsGame beginRefreshing];
        [self.cv_resultsGame beginRefreshing];

        [GCQuestionManager getQuestionsForEvent:self.eventModel._id inCompetition:self.eventModel.competition_id cb_response:^(NSArray *questions)
         {
             [GCQuestionModel sortArrayOfQuestions:questions cb_sorted:^(NSArray *questionsWithResults, NSArray *theOthers)
              {
                  [weak_self.cv_questionsGame setData:@{@"flux" : theOthers}];
                  [weak_self.cv_resultsGame setData:@{@"flux" : questionsWithResults}];
              }];
         }];
    }
    else
    {
        DLog(@"EventModel doesn't exist");
        [GCQuestionModel sortArrayOfQuestions:self.preloadedQuestions cb_sorted:^(NSArray *questionsWithResults, NSArray *theOthers)
         {
             [weak_self.cv_questionsGame setData:@{@"flux" : theOthers}];
             [weak_self.cv_resultsGame setData:@{@"flux" : questionsWithResults}];
         }];
    }
}

-(void)updateNewQuestion:(GCQuestionModel *)question
{
    // TODO: insert new question
    [self loadData];
}

-(void)updateEndQuestion:(GCQuestionModel *)question
{
    // TODO: update end question
    [self loadData];
}

-(void)initSegmentedControl
{
    [self.sc_questionsResults removeAllSegments];
    [self.sc_questionsResults insertSegmentWithTitle:NSLocalizedString(@"gc_tab_questions", nil) atIndex:0 animated:NO];
    [self.sc_questionsResults insertSegmentWithTitle:NSLocalizedString(@"gc_tab_results", nil) atIndex:1 animated:NO];
    [self.sc_questionsResults setSelectedSegmentIndex:0];
    
    [self.sc_questionsResults setTintColor:CONFCOLORFORKEY(@"tab_bg")];
    [self.sc_questionsResults setTitleTextAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"tab_title_lb")} forState:UIControlStateSelected];
    [self.sc_questionsResults setTitleTextAttributes:@{NSFontAttributeName:CONFFONTBOLDSIZE(14), NSForegroundColorAttributeName:CONFCOLORFORKEY(@"tab_title_lb")} forState:UIControlStateNormal];
}

- (IBAction)changeSegmentedControlValue:(id)sender
{
    if (self.sc_questionsResults.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.cv_questionsGame setAlpha:1.0f];
            [self.cv_resultsGame setAlpha:0.0f];
        } completion:^(BOOL finished) { }];
    }
    else if (self.sc_questionsResults.selectedSegmentIndex == 1)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.cv_questionsGame setAlpha:0.0f];
            [self.cv_resultsGame setAlpha:1.0f];
        } completion:^(BOOL finished) { }];
    }
}

#pragma UICollectionViewDelegate
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withData:(id)dataElement inCollectionView:(UICollectionViewGG *)collectionView
{
    if (self.callBackQuestionSelected)
        self.callBackQuestionSelected(dataElement);
    else
        [[GCProcessQuestionManager sharedManager] selectItemInQuestionsList:dataElement fromViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
//    NSLog(@">>>>>>>>>>>> DEALLOC INGAME");
}

@end
