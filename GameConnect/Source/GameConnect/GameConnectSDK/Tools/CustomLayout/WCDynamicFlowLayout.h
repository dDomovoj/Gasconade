//
//  WCDynamicFlowLayout.h
//  FIFA_WC14
//
//  Created by Mathieu Lanoy on 19/02/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCDynamicFlowLayout : UICollectionViewFlowLayout

@property (strong, nonatomic) UIDynamicAnimator     *dynamicAnimator;
@property (strong, nonatomic) NSMutableSet          *visibleIndexPathsSet;
@property (strong, nonatomic) NSMutableSet          *visibleHeaderAndFooterSet;
@property (assign, nonatomic) CGFloat               latestDelta;
@property (assign, nonatomic) CGFloat               spring_resistance;
@property (assign, nonatomic) BOOL                  animationEnabled;

@end
 
