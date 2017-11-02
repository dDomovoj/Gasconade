//
//  GCAPPAnswersViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCAPPAnswersViewController.h"
#import "GCBluredImageSingleton.h"
#import <Masonry/Masonry.h>

@interface GCAPPAnswersViewController ()
@end

@implementation GCAPPAnswersViewController

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
    self.title = nil;//[NSLocalizedString(@"gc_answers", nil) capitalizedString];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpAnswers];
}

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

-(void)setUpAnswers
{
    if (!answers)
    {
        answers = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCAnswersVCIdentifier];
        [self.v_containerAnswers addSubview:answers.view];
        [answers.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];

        [self addChildViewController:answers];
    }
    [answers updateQuestion:self.questionModelForAnswers];
}

-(void) updateNewQuestion:(GCQuestionModel *)questionModel
{
    _questionModelForAnswers = questionModel;
    
    if (answers && [answers isViewLoaded])
        [answers updateNewQuestion:questionModel];
}

-(void) updateStatsQuestion:(GCQuestionModel *)questionModel
{
    if (_questionModelForAnswers)
        _questionModelForAnswers.answers = questionModel.answers;
    else
        _questionModelForAnswers = questionModel;
    
    if (answers && [answers isViewLoaded])
        [answers updateStatsQuestion:questionModel];
}

-(void) updateEndQuestion:(GCQuestionModel *)questionModel
{
    if (_questionModelForAnswers)
        _questionModelForAnswers.status = questionModel.status;
    else
        _questionModelForAnswers = questionModel;

    if (answers && [answers isViewLoaded])
        [answers updateEndQuestion:questionModel];
}

-(NSTimeInterval)getTimeIntervalSinceIAmDisplayed
{
    if (answers)
        return [answers getTimeIntervalSinceIAmDisplayed];
    return [super getTimeIntervalSinceIAmDisplayed];
}

//-(BOOL)isUpdatingStats
//{
//    return answers.isUpdatingStats;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
