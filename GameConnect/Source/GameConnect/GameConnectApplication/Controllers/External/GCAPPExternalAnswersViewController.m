//
//  GCAPPExternalAnswersViewController.m
//  TVA Sports Second Screen
//
//  Created by Guillaume on 05/08/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "GCConfManager.h"
#import "GCAPPExternalAnswersViewController.h"
#import "NSObject+NSObject_Xpath.h"
#import "NSObject+NSObject_Tool.h"
#import "GCAnswersViewController.h"
#import "UIView+UIView_Tool.h"
#import "GCAPPExternalPopupView.h"
#import "NSArray+NSArray_Bundle.h"
#import "GCPushInfoView.h"
#import "GCFayeWorker.h"
#import "GCAPPDefines.h"

@interface GCAPPExternalAnswersViewController()
{
    NSMutableArray *arrayOfElements;
    NSMutableArray *arrayOfNewQuestion;
    
    BOOL isAnimatingDeletionOfElements;
}
@end

@implementation GCAPPExternalAnswersViewController

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
    self.heightSeparator = 1;
    isAnimatingDeletionOfElements = NO;
    
    [self initBackground];
    [self initHeader];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initShadow];
    
    if (arrayOfNewQuestion && [arrayOfNewQuestion count] > 0)
    {
        __weak GCAPPExternalAnswersViewController *weak_self = self;
        [arrayOfNewQuestion enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            [weak_self insertNewQuestion:obj];
        }];
    }
}

#pragma mark - Custom Pop Up
-(void)insertCustomPopUpWithData:(id)data andBlockOnceSelected:(void(^)())completion
{
    __weak GCAPPExternalAnswersViewController *weak_self = self;

    if (data && [data isKindOfClass:[NSDictionary class]])
    {
        GCAPPExternalPopupView *popUp = [[[NSBundle mainBundle] loadNibNamed:@"GCAPPExternalPopupView" owner:nil options:nil] getObjectsType:[GCAPPExternalPopupView class]];
        [popUp setFrame:CGRectMake(0, 0, self.sv_stackOfQuestions.frame.size.width, popUp.frame.size.height)];
        [popUp setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [popUp updatePopupWithData:data];
        [self.sv_stackOfQuestions addSubview:popUp];

        popUp.callBackClickPopup = ^{
            [weak_self closeEntirePanel];
            if (completion)
                completion();
        };

        if (!arrayOfElements)
            arrayOfElements = [[NSMutableArray alloc] init];
        [arrayOfElements addObject:popUp];

        
        [self.sv_stackOfQuestions setContentSize:CGSizeMake(self.sv_stackOfQuestions.frame.size.width, [self getHeightOfScrollSubviews])];
        
        if (self.showPanelWithCallBack)
        {
            self.showPanelWithCallBack(weak_self, ^{
                CGPoint bottomOffset = CGPointMake(0, self.sv_stackOfQuestions.contentSize.height - self.sv_stackOfQuestions.bounds.size.height);
                [self.sv_stackOfQuestions setContentOffset:bottomOffset animated:YES];
            });
        }
    }
}

#pragma mark - Notifications
-(void)insertNewQuestion:(GCQuestionModel *)questionModel
{
    __weak GCAPPExternalAnswersViewController *weak_self = self;
    
    if (![self isViewLoaded] && self.view.window)
    {
        if (!arrayOfNewQuestion)
            arrayOfNewQuestion = [[NSMutableArray alloc] init];
        [arrayOfNewQuestion addObject:questionModel];

        if (self.showPanelWithCallBack)
            self.showPanelWithCallBack(weak_self, ^{});
        return;
    }
    
    if (questionModel && [questionModel isKindOfClass:[GCQuestionModel class]])
    {
        GCAnswersViewController *answersViewController = [GCSTORYBOARD instantiateViewControllerWithIdentifier:GCExternalAnswerVCIdentifier];
        CGFloat subviewsOffset = [self getHeightOfScrollSubviews];
        if (arrayOfElements && [arrayOfElements count] > 0)
        {
            // Add Separator
            UIView *v_separator = [[UIView alloc] initWithFrame:CGRectMake(0, subviewsOffset, self.view.frame.size.width, self.heightSeparator)];
            [v_separator setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.1]];
            [v_separator setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//            [self.sv_stackOfQuestions addSubview:v_separator];
            subviewsOffset += v_separator.frame.size.height;
        }
//        if (questionModel.type == eGCQuestionTypeMCQ)
//            [answersViewController.view setFrame:CGRectMake(0, subviewsOffset, self.sv_stackOfQuestions.frame.size.width, 440)];
//        else
        [answersViewController.view setFrame:CGRectMake(0, subviewsOffset, self.sv_stackOfQuestions.frame.size.width, 340)];
        [self.sv_stackOfQuestions addSubview:answersViewController.view];
        [self addChildViewController:answersViewController];

        [answersViewController updateNewQuestion:questionModel];
        answersViewController.callBackClosingViewController = ^{
            [weak_self removeQuestion:questionModel];
        };

        if (!arrayOfElements)
            arrayOfElements = [[NSMutableArray alloc] init];
        [arrayOfElements addObject:answersViewController];

        [self.sv_stackOfQuestions setContentSize:CGSizeMake(self.sv_stackOfQuestions.frame.size.width, [self getHeightOfScrollSubviews])];
        
        if (self.showPanelWithCallBack)
        {
            self.showPanelWithCallBack(weak_self, ^{
                CGPoint bottomOffset = CGPointMake(0, self.sv_stackOfQuestions.contentSize.height - self.sv_stackOfQuestions.bounds.size.height);
                [self.sv_stackOfQuestions setContentOffset:bottomOffset animated:YES];
            });
        }
    }
}

-(void)insertResultQuestion:(GCQuestionModel *)questionModel
{
    __weak GCAPPExternalAnswersViewController *weak_self = self;
    if (questionModel && [questionModel isKindOfClass:[GCQuestionModel class]])
    {
        GCPushInfoView *pushInfoView = [[[NSBundle mainBundle] loadNibNamed:@"GCPushInfoViewSmall" owner:nil options:nil] getObjectsType:[GCPushInfoView class]];

        CGFloat subviewsOffset = [self getHeightOfScrollSubviews];
        if (arrayOfElements && [arrayOfElements count] > 0)
        {
            // Add Separator
            UIView *v_separator = [[UIView alloc] initWithFrame:CGRectMake(0, subviewsOffset, self.view.frame.size.width, self.heightSeparator)];
            [v_separator setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.1]];
            [v_separator setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//            [self.sv_stackOfQuestions addSubview:v_separator];
            subviewsOffset += v_separator.frame.size.height;
        }
        [pushInfoView setFrame:CGRectMake(0, subviewsOffset, self.sv_stackOfQuestions.frame.size.width, pushInfoView.frame.size.height)];
        
        [self.sv_stackOfQuestions addSubview:pushInfoView];
        [pushInfoView updateWithQuestionModel:questionModel];
        
        __weak GCPushInfoView *weak_pushInfoView = pushInfoView;
        pushInfoView.callBackClosingView = ^{
            [weak_self removeCustomView:weak_pushInfoView];
        };
        
        if (!arrayOfElements)
            arrayOfElements = [[NSMutableArray alloc] init];
        [arrayOfElements addObject:pushInfoView];

        [self.sv_stackOfQuestions setContentSize:CGSizeMake(self.sv_stackOfQuestions.frame.size.width, [self getHeightOfScrollSubviews])];
        
        if (self.showPanelWithCallBack)
        {
            self.showPanelWithCallBack(weak_self, ^{
                CGPoint bottomOffset = CGPointMake(0, self.sv_stackOfQuestions.contentSize.height - self.sv_stackOfQuestions.bounds.size.height);
                [self.sv_stackOfQuestions setContentOffset:bottomOffset animated:YES];
            });
        }
    }
}

-(void)removeQuestion:(GCQuestionModel *)questionModel
{
    if (!questionModel || !questionModel._id || [questionModel._id length] == 0)
    {
        //GCLog(@"Trying to remove from external answers view controller a bad question /!\\");
        return ;
    }
    
    if (!arrayOfElements || [arrayOfElements count] == 0)
    {
        //GCLog(@"No questions are stored in this external view controller for the moment");
        return ;
    }
    
    NSMutableIndexSet *indexSetOfElementToRemove = [[NSMutableIndexSet alloc] init];
    [arrayOfElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if (obj && [obj isKindOfClass:[GCAnswersViewController class]])
         {
             GCQuestionModel *questionStored = ((GCAnswersViewController *)obj).questionModel;
             if ([questionStored._id isEqualToString:questionModel._id])
             {
                 [indexSetOfElementToRemove addIndex:idx];
                 *stop = YES;
             }
         }
         else if (obj && [obj isKindOfClass:[GCPushInfoView class]])
         {
             GCQuestionModel *questionStored = ((GCPushInfoView *)obj).questionModel;
             if ([questionStored._id isEqualToString:questionModel._id])
             {
                 [indexSetOfElementToRemove addIndex:idx];
                 *stop = YES;
             }
         }
     }];
    if (isAnimatingDeletionOfElements == YES)
    {
        __weak GCAPPExternalAnswersViewController *weak_self = self;
        [self performWithDelay:1 block:^{
            [weak_self removeQuestion:questionModel];
        }];
    }
    else
        [self removeElementsAtIndexes:indexSetOfElementToRemove animated:YES];
}

-(void)removeQuestionsFromEvent:(GCEventModel *)eventQuestionToRemove
{
    if (!eventQuestionToRemove || !eventQuestionToRemove._id || [eventQuestionToRemove._id length] == 0)
    {
        //GCLog(@"Trying to remove from external answers view controller a bad event /!\\");
        return ;
    }
    if (!arrayOfElements || [arrayOfElements count] == 0)
    {
        //GCLog(@"No questions are stored in this external view controller for the moment");
        return ;
    }
    NSMutableIndexSet *indexSetOfElementToRemove = [[NSMutableIndexSet alloc] init];
    [arrayOfElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if (obj && [obj isKindOfClass:[GCAnswersViewController class]])
         {
            GCQuestionModel *questionStored = ((GCAnswersViewController *)obj).questionModel;
             
             if ([questionStored.event_id isEqualToString:eventQuestionToRemove._id])
                 [indexSetOfElementToRemove addIndex:idx];
         }
     }];
    if (isAnimatingDeletionOfElements == YES)
    {
        __weak GCAPPExternalAnswersViewController *weak_self = self;
        [self performWithDelay:1 block:^{
            [weak_self removeQuestionsFromEvent:eventQuestionToRemove];
        }];
    }
    else
        [self removeElementsAtIndexes:indexSetOfElementToRemove animated:YES];
}

-(void)removeCustomView:(UIView *)customView
{
    if (!arrayOfElements || [arrayOfElements count] == 0)
    {
        //GCLog(@"No questions are stored in this external view controller for the moment");
        return ;
    }
    
    NSMutableIndexSet *indexSetOfElementToRemove = [[NSMutableIndexSet alloc] init];
    [arrayOfElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if (obj && [obj isKindOfClass:[UIView class]])
         {
             UIView *storedView = obj;
             if (customView == storedView)
                 [indexSetOfElementToRemove addIndex:idx];
         }
     }];
    
    if (isAnimatingDeletionOfElements == YES)
    {
        __weak GCAPPExternalAnswersViewController *weak_self = self;
        [self performWithDelay:1 block:^{
            [weak_self removeCustomView:customView];
        }];
    }
    else
        [self removeElementsAtIndexes:indexSetOfElementToRemove animated:YES];
}

-(void)removeElementsAtIndexes:(NSIndexSet *)indexSet animated:(BOOL)shouldAnimate
{
    __weak GCAPPExternalAnswersViewController *weak_self = self;
    isAnimatingDeletionOfElements = YES;
    
    void (^deletionBlock)(NSIndexSet *, void(^)()) = ^(NSIndexSet *indexes, void(^completionBlock)())
    {
        if (shouldAnimate)
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
                {
                    if ([arrayOfElements count] > idx)
                    {
                        id object = [arrayOfElements objectAtIndex:idx];
                        if (object && [object isKindOfClass:[UIViewController class]])
                        {
                            UIViewController *viewController = object;
                            viewController.view.alpha = 0.0f;
                        }
                        else if (object && [object isKindOfClass:[UIView class]])
                        {
                            UIView *view = object;
                            view.alpha = 0.0f;
                        }
                    }
                }];
                
            }completion:^(BOOL finished) {
                
                [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
                 {
                     if ([arrayOfElements count] > idx)
                     {
                         id object = [arrayOfElements objectAtIndex:idx];
                         if (object && [object isKindOfClass:[UIViewController class]])
                         {
                             UIViewController *viewController = object;
                             [viewController.view removeFromSuperview];
                             [viewController removeFromParentViewController];
                         }
                         else if (object && [object isKindOfClass:[UIView class]])
                         {
                             UIView *view = object;
                             [view removeFromSuperview];
                         }
                     }
                 }];
                
                [arrayOfElements removeObjectsAtIndexes:indexes];
                if (completionBlock)
                    completionBlock();
            }];
        }
        else
        {
            [arrayOfElements removeObjectsAtIndexes:indexes];
            if (completionBlock)
                completionBlock();
        }
    };

    if (arrayOfElements && [arrayOfElements count] - [indexSet count] > 0)
    {
        deletionBlock(indexSet, ^{
            
            if (arrayOfElements && [arrayOfElements count] > 0)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    [weak_self renderScrollSubviews];
                } completion:nil];
                
                if (arrayOfElements && [arrayOfElements count] > 0)
                {
                    if (weak_self.showPanelWithCallBack)
                        weak_self.showPanelWithCallBack(weak_self, ^{
                            isAnimatingDeletionOfElements = NO;
                        });
                }
            }
        });
    }
    else
    {
        if (self.hidePanelWithCallBack)
        {
            self.hidePanelWithCallBack(weak_self, ^{
                deletionBlock(indexSet, ^{
                    [weak_self.sv_stackOfQuestions clearSubview];
                    isAnimatingDeletionOfElements = NO;
                });
            });
        }
    }
}

#pragma mark - User Interactions
- (IBAction)clickOnClosePanel:(id)sender
{
    if (arrayOfElements && [arrayOfElements count] > 0)
    {
        id object = [arrayOfElements lastObject];
        if (object && [object isKindOfClass:[GCAPPExternalPopupView class]])
        {
            [self closeEntirePanel];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gc_popup_info_title", nil) message:NSLocalizedString(@"gc_popup_message_close_forever", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"gc_cancel", nil) otherButtonTitles:NSLocalizedString(@"gc_popup_ok", nil), nil] show];
        }
    }
    else
    {
        [self closeEntirePanel];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [[GCConfManager getInstance] setGameConnectExternalNotificationsEnabled:NO];
        [[GCConfManager getInstance] setSoundEnabled:NO];
        [[GCConfManager getInstance] setVibrationEnabled:NO];
        [[GCFayeWorker getInstance] shutdownFayeClient];
        
        [self closeEntirePanel];
    }
}

-(void)closeEntirePanel
{
    if (arrayOfElements && [arrayOfElements count] > 0)
    {
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [arrayOfElements count])];
        [self removeElementsAtIndexes:indexes animated:NO];
    }
}

#pragma mark - UI
-(void)initBackground
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.v_background addSubviewToBonce:imgView autoSizing:YES];
}

-(void)initHeader
{
    [self.bt_closePanel setTitle:NSLocalizedString(@"gc_close_external_panel", nil) forState:UIControlStateNormal];
    [self.bt_closePanel setTitleColor:CONFCOLORFORKEY(@"external_panel_header_bt") forState:UIControlStateNormal];

    [self.v_header setBackgroundColor:CONFCOLORFORKEY(@"external_panel_header_bg")];
}

-(void)initShadow
{
//    self.view.layer.shadowColor = [UIColor redColor].CGColor;
//    self.view.layer.shadowOffset = CGSizeMake(50, 50);
//    self.view.layer.shadowRadius = 2;
//    self.view.layer.shadowOpacity = 1;
}

-(void)renderScrollSubviews
{
    if (arrayOfElements)
    {
        __weak GCAPPExternalAnswersViewController *weak_self = self;
        __block CGFloat heightPreviousElement = 0;
        [arrayOfElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if (obj && [obj isKindOfClass:[GCAnswersViewController class]])
             {
                 GCAnswersViewController *answersViewController = obj;
                 [answersViewController.view setFrame:CGRectMake(answersViewController.view.frame.origin.x, (idx * heightPreviousElement) + (idx * weak_self.heightSeparator), answersViewController.view.frame.size.width, answersViewController.view.frame.size.height)];

                 heightPreviousElement = 320;//answersViewController.questionModel.type == eGCQuestionTypeMCQ ? 440 : 320;
                 NSLog(@"RESET Frame Controller %@", answersViewController.view);
             }
             else if (obj && ([obj isKindOfClass:[GCAPPExternalPopupView class]] || [obj isKindOfClass:[GCPushInfoView class]]))
             {
                 UIView *customView = obj;
                 [customView setFrame:CGRectMake(customView.frame.origin.x, (idx * heightPreviousElement) + (idx * weak_self.heightSeparator), customView.frame.size.width, customView.frame.size.height)];

                 heightPreviousElement = customView.frame.size.height;
                 NSLog(@"RESET Frame PushInfoView %@", customView);
             }
         }];
        [self.sv_stackOfQuestions setContentSize:CGSizeMake(self.sv_stackOfQuestions.frame.size.width, [self getHeightOfScrollSubviews])];
    }
}

#pragma mark - Tools
-(NSUInteger) numberOfElementsInPanel
{
    if (arrayOfElements)
        return [arrayOfElements count];
    else
        return 0;
}

-(CGFloat) getHeightOfHeader
{
    return self.v_header.frame.size.height;
}

-(CGFloat)getHeightOfScrollSubviews
{
    __block CGFloat heightOfAllSubviews = 0;
    
    if (arrayOfElements && [arrayOfElements count] > 0)
    {
        id object = [arrayOfElements lastObject];
        if (object && [object isKindOfClass:[UIViewController class]])
        {
            UIViewController *lastViewController = object;
            heightOfAllSubviews = lastViewController.view.frame.origin.y + lastViewController.view.frame.size.height;
        }
        else if (object && [object isKindOfClass:[UIView class]])
        {
            UIView *lastView = object;
            heightOfAllSubviews = lastView.frame.origin.y + lastView.frame.size.height;
        }
    }
    return heightOfAllSubviews;
}

@end
