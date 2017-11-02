//
//  GCBadgeViewController.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/27/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "Extends+Libs.h"
#import "GCPushInfoViewController.h"
#import "GCProcessQuestionManager.h"
#import "GCProcessPushManager.h"
#import "GCProcessProfileManager.h"

@interface GCPushInfoViewController ()
{
    NSMutableArray *itemsPushInfo;
    BOOL hasAppeared;
    NSInteger preselectedIndex;
}
@end

@implementation GCPushInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        preselectedIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    hasAppeared = NO;
    
    self.ic_view.delegate = self;
    self.ic_view.dataSource = self;
    self.ic_view.type = iCarouselTypeCoverFlow;
    self.ic_view.vertical = NO;
    
    itemsPushInfo = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (itemsPushInfo && self.ic_view.numberOfItems < [itemsPushInfo count])
    {
        [self.ic_view reloadData];
        [self.ic_view scrollToItemAtIndex:preselectedIndex animated:TRUE];
    }
    hasAppeared = YES;
}

-(void) preselectItemAtIndex:(NSInteger)preselectedItemIndex
{
    preselectedIndex = preselectedItemIndex;
    
    if (hasAppeared)
        [self.ic_view scrollToItemAtIndex:preselectedIndex animated:TRUE];
}

-(void) addPushInfos:(NSArray *)questionsAndTrophies
{
    if (questionsAndTrophies && [questionsAndTrophies count] > 0)
    {
        [itemsPushInfo addObjectsFromArray:questionsAndTrophies];
        itemsPushInfo = [[itemsPushInfo reversedArray] ToMutable];

        if (hasAppeared)
        {
            for (NSUInteger i = 0; i < [questionsAndTrophies count]; i++)
            {
                NSInteger index = MAX(0, self.ic_view.numberOfItems-1);
                [self.ic_view insertItemAtIndex:index animated:YES];
            }
                NSInteger index = MAX(0, self.ic_view.numberOfItems-1);
            [self.ic_view scrollToItemAtIndex:index animated:YES];
        }
    }
    else
        DLog(@"PushInfos don't exist!");
}

#pragma GCPushInfoViewDelegate
-(void) GCDidRequestToShare:(GCModel *)modelToShare fromSender:(GCView *)senderView
{
    if (modelToShare && [modelToShare isKindOfClass:[GCQuestionModel class]])
    {
        GCQuestionModel *questionModel = (GCQuestionModel *)modelToShare;
        [[GCProcessQuestionManager sharedManager] shareQuestion:questionModel fromViewController:self];
    }
    if (modelToShare && [modelToShare isKindOfClass:[GCTrophyModel class]])
    {
        GCTrophyModel *trophyModel = (GCTrophyModel *)modelToShare;
        [[GCProcessProfileManager sharedManager] shareTrophy:trophyModel fromViewController:self];
    }
}

#pragma iCarouselDataSource
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (itemsPushInfo)
        return [itemsPushInfo count];
    else
        return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    GCPushInfoView *pushInfoView = nil;
    if (view == nil)
    {
        pushInfoView = [[[NSBundle mainBundle] loadNibNamed:@"GCPushInfoViewLarge" owner:nil options:nil] getObjectsType:[GCPushInfoView class]];
        [pushInfoView setFrame:CGRectMake(0, 0, carousel.frame.size.width, carousel.frame.size.height)];
        pushInfoView.delegate = self;
    }
    else if ([view isKindOfClass:[GCPushInfoView class]])
    {
        pushInfoView = (GCPushInfoView *) view;
    }
    
    if (itemsPushInfo && [itemsPushInfo count] > index && pushInfoView)
    {
//        id itemPushInfo = [itemsPushInfo objectAtIndex:index];
        
        if ([[itemsPushInfo objectAtIndex:index] isKindOfClass:[GCTrophyModel class]])
            [pushInfoView updateWithTrophyModel:(GCTrophyModel *)[itemsPushInfo objectAtIndex:index]];
        
        else if ([[itemsPushInfo objectAtIndex:index] isKindOfClass:[GCQuestionModel class]])
            [pushInfoView updateWithQuestionModel:(GCQuestionModel *)[itemsPushInfo objectAtIndex:index]];
    }
    pushInfoView.autoresizingMask = UIViewAutoresizingNone;
    return pushInfoView;
}

#pragma iCarouselDelegate
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.ic_view.frame.size.width - 20;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
