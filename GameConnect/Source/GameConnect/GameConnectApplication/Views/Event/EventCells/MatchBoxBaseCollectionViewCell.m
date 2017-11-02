//
//  MatchBoxBaseCollectionViewCell.m
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 7/12/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

#import "MatchBoxBaseCollectionViewCell.h"
#import "GCFontManager.h"

//#import <SDW>
//@import SDWebImage;

@implementation MatchBoxBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self constructUI];
  return self;
}

- (void)constructUI
{
//  [super constructUI];

  self.backgroundColor = [UIColor clearColor];

  self.contentContainer = [UIView new];
  [self.contentView addSubview:self.contentContainer];

  self.teamHomeContainer = [UIView new];
  [self.contentContainer addSubview:self.teamHomeContainer];

  self.teamAwayContainer = [UIView new];
  [self.contentContainer addSubview:self.teamAwayContainer];

  // Container
  self.matchDateContainer = [UIView new];
  self.matchDateContainer.backgroundColor = [UIColor clearColor];
  [self.contentContainer addSubview:self.matchDateContainer];

  // Labels
  self.scoreLabel = [UILabel new];
  self.scoreLabel.textColor = [UIColor whiteColor];
  self.scoreLabel.textAlignment = NSTextAlignmentCenter;
  self.scoreLabel.font = [[GCFontManager getInstance] alternateFontWithSize:38];
  [self.contentContainer addSubview:self.scoreLabel];

  self.penaltiesLabel = [UILabel new];
  self.penaltiesLabel.textColor = [UIColor whiteColor];
  self.penaltiesLabel.textAlignment = NSTextAlignmentCenter;
  self.penaltiesLabel.font = [[GCFontManager getInstance] getFontRegularWithSize:16];
  [self.contentContainer addSubview:self.penaltiesLabel];

  self.matchDateLabel = [UILabel new];
  self.matchDateLabel.textColor = [UIColor whiteColor];
  self.matchDateLabel.textAlignment = NSTextAlignmentCenter;
  self.matchDateLabel.font = [[GCFontManager getInstance] getFontBoldWithSize:15];
  [self.matchDateContainer addSubview:self.matchDateLabel];

  self.matchDateTimeLabel = [UILabel new];
  self.matchDateTimeLabel.textColor = [UIColor whiteColor];
  self.matchDateTimeLabel.textAlignment = NSTextAlignmentCenter;
  self.matchDateTimeLabel.font = [[GCFontManager getInstance] getFontRegularWithSize:15];
  [self.matchDateContainer addSubview:self.matchDateTimeLabel];

  self.teamHomeLabel = [UILabel new];
  self.teamHomeLabel.textColor = [UIColor whiteColor];
  self.teamHomeLabel.textAlignment = NSTextAlignmentCenter;
  self.teamHomeLabel.numberOfLines = 0;
  self.teamHomeLabel.font = [[GCFontManager getInstance] getFontBoldWithSize:15];
  [self.contentContainer addSubview:self.teamHomeLabel];

  self.teamAwayLabel = [UILabel new];
  self.teamAwayLabel.textColor = [UIColor whiteColor];
  self.teamAwayLabel.textAlignment = NSTextAlignmentCenter;
  self.teamAwayLabel.numberOfLines = 0;
  self.teamAwayLabel.font = [[GCFontManager getInstance] getFontBoldWithSize:15];
  [self.contentContainer addSubview:self.teamAwayLabel];

  // Image Views
  self.teamHomeImage = [UIImageView new];
  self.teamHomeImage.backgroundColor = [UIColor clearColor];
  self.teamHomeImage.contentMode = UIViewContentModeScaleAspectFit;
  [self.contentContainer addSubview:self.teamHomeImage];

  self.teamAwayImage = [UIImageView new];
  self.teamAwayImage.backgroundColor = [UIColor clearColor];
  self.teamAwayImage.contentMode = UIViewContentModeScaleAspectFit;
  [self.contentContainer addSubview:self.teamAwayImage];

  self.topSeparator = [UIView new];
  self.topSeparator.alpha = 0.5f;
  self.topSeparator.backgroundColor = [UIColor whiteColor];
  [self.contentContainer addSubview:self.topSeparator];
}

-(void)prepareForReuse
{
  [super prepareForReuse];

#warning UARENA
//  [self.teamHomeImage sd_cancelCurrentAnimationImagesLoad];
  self.teamHomeImage.image = nil;

//  [self.teamAwayImage sd_cancelCurrentAnimationImagesLoad];
  self.teamAwayImage.image = nil;
}

@end
