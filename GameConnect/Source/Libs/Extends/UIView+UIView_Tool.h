//
//  UIView+UIView_Tool.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_Tool)

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) id tagObjective;

-(void)bouingAppear:(BOOL)appear oncomplete:(void (^)(void))oncomplete;
-(void)highlight:(void (^)(void))oncomplete;
-(UIView*)addSubviewToBonce:(UIView*)view autoSizing:(BOOL)autosize;
-(UIView*)addSubviewToBonce:(UIView*)view;
-(UIView*)addSubviewToCenter:(UIView*)view;

-(UIView*)addSubviewToBonceWithConstraint:(UIView*)view;
-(UIView*)addSubviewToBonceWithConstraintWithoutLanguageDirection:(UIView*)view;
-(UIView*)addSubviewToBonceWithConstraint:(UIView*)view options:(NSLayoutFormatOptions)options;

-(void)setCenterJAPaddings:(id)paddings;
-(void)setCenterJA;
-(CGSize)renderRelatifInlineScroll:(BOOL)scroll align:(NSString*)align;
-(CGRect)renderRelativeSubviewsSetMyContentScrollHorizontal;
-(CGRect)renderRelativeSubviewsSetMyContentScrollHorizontalWithPadding:(id)paddings;
-(CGRect)renderRelativeSubviewsSetMyContentScroll:(BOOL)setContent;
-(CGRect)renderRelativeSubviewsSetMyContentScroll:(BOOL)setContent paddings:(id)paddings;
-(CGRect)renderRelativeSubviewsSetMyContentScrollWithoutParent:(BOOL)setContent paddings:(id)paddings;
-(UIView*)roundShadow;
-(UIView*)setBorder:(CGFloat)width color:(UIColor*)color;

-(void)visiteurView:(void(^)(UIView *elt))cbBefore cbAfter:(void(^)(UIView *elt))cbAfter;
-(NSInteger)setId:(NSString*)idview;
-(BOOL)generateId;
-(void)replavesubview:(NSArray*)newView keepOldView:(BOOL)keepOldView;
-(UIView*)getMasterView;
- (UIImage*)screenshot;

-(void)clearSubview;
-(void) resignAllResponder;

@end
