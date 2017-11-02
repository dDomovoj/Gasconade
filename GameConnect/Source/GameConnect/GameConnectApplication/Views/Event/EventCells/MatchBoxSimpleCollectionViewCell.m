//
//  MatchBoxSimpleCollectionViewCell.m
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 7/12/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

#import "MatchBoxSimpleCollectionViewCell.h"

#import <Masonry/Masonry.h>

static const CGFloat MatchBoxSimpleCollectionViewCellScoreWidth = 70.f;

static const CGFloat MatchBoxSimpleCollectionViewCellLogoIphoneWidth = 25.f;
static const CGFloat MatchBoxSimpleCollectionViewCellLogoIpadWidth = 50.f;
static const CGFloat MatchBoxSimpleCollectionViewCellHeight = 145.f;


@interface MatchBoxSimpleCollectionViewCell ()

@property (nonatomic, readwrite) UILabel *penalties;
@property (nonatomic, readwrite) UILabel *startDateLabel;

@property (nonatomic) MASConstraint *scoreCenterConstraint;

@end

@implementation MatchBoxSimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self constructUI];
  return self;
}

- (void)constructUI { }

- (void)updateConstraints {

  [self.contentContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
  }];

  [self.scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.centerX.offset(0);
    make.centerY.offset(-20);
  }];

  [self.penaltiesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.scoreLabel.mas_bottom).offset(0);
    make.centerX.equalTo(self.scoreLabel.mas_centerX);
    make.width.equalTo(@(MatchBoxSimpleCollectionViewCellScoreWidth));
  }];

  [self.teamHomeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@110);
    make.width.equalTo(@120);
    make.left.equalTo(@(0.0f));
    make.centerY.equalTo(self.mas_centerY);
  }];

  [self.teamAwayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@110);
    make.width.equalTo(@120);
    make.right.equalTo(@(0.0f));
    make.centerY.equalTo(self.mas_centerY);
  }];
  // Teams images

  [self.teamHomeImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@55);
    make.width.equalTo(@55);
    make.top.equalTo(self.teamHomeContainer.mas_top).offset(0.f);
    make.centerX.equalTo(self.teamHomeContainer.mas_centerX);
  }];

  [self.teamAwayImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@55);
    make.width.equalTo(@55);
    make.top.equalTo(self.teamAwayContainer.mas_top).offset(0.f);
    make.centerX.equalTo(self.teamAwayContainer.mas_centerX);
  }];

  // Teams names

  [self.teamHomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.teamHomeImage.mas_bottom).offset(5.f);
    make.left.equalTo(self.teamHomeContainer.mas_left).offset(0.f);
    make.right.equalTo(self.teamHomeContainer.mas_right).offset(0.f);
    make.bottom.equalTo(self.teamHomeContainer.mas_bottom).offset(0.f);
  }];

  [self.teamAwayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.teamAwayImage.mas_bottom).offset(5.f);
    make.left.equalTo(self.teamAwayContainer.mas_left).offset(0.f);
    make.right.equalTo(self.teamAwayContainer.mas_right).offset(0.f);
    make.bottom.equalTo(self.teamAwayContainer.mas_bottom).offset(0.f);
  }];

  //    // Score
  //
  //    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
  //        make.centerY.equalTo(self.mas_centerY);
  //        make.centerX.equalTo(self.mas_centerX);
  //    }];

  // Match date container

  [self.matchDateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.matchDateContainer);
    make.top.equalTo(self.matchDateLabel.mas_bottom).offset(0.f);
  }];

  [self.matchDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.matchDateContainer);
    make.top.equalTo(self.matchDateContainer.mas_top).offset(0.f);
  }];

  [self.matchDateContainer mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@40.f);
    make.width.equalTo(@100.f);
    make.center.equalTo(self.scoreLabel);
  }];

  [self.topSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(self.contentView.frame.size.width);
    make.height.equalTo(@(1));
    make.top.equalTo(@0.f);
  }];

  [super updateConstraints];
}

@end
