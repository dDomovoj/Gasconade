//
//  MatchBoxBaseCollectionViewCell.h
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 7/12/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseCollectionViewCell.h"

@interface MatchBoxBaseCollectionViewCell : UICollectionViewCell// BaseCollectionViewCell

@property (nonatomic) UIView *contentContainer;
@property (nonatomic) UIView *matchDateContainer;
@property (nonatomic) UIView *teamHomeContainer;
@property (nonatomic) UIView *teamAwayContainer;
@property (nonatomic) UILabel *matchDateLabel;
@property (nonatomic) UILabel *matchDateTimeLabel;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *penaltiesLabel;

@property (nonatomic) UILabel *teamHomeLabel;
@property (nonatomic) UIImageView *teamHomeImage;

@property (nonatomic) UILabel *teamAwayLabel;
@property (nonatomic) UIImageView *teamAwayImage;

@property (nonatomic) UIView *topSeparator;

@end
