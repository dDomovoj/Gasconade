//
//  UITableViewCellSlide.m
//  traceSport
//
//  Created by bigmac on 20/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCellSlide.h"


@implementation UITableViewCellSlide
@synthesize t;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
}

@end
