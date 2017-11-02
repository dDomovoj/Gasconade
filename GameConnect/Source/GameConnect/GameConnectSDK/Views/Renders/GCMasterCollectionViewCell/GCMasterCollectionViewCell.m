//
//  GCMasterCollectionViewCell.m
//  FFF
//
//  Created by Édouard Richard on 25/09/2014.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "GCMasterCollectionViewCell.h"

@implementation GCMasterCollectionViewCell

-(void) layoutSubviews{
    [super layoutSubviews];
    
    BOOL contentViewIsAutoresized = CGSizeEqualToSize(self.frame.size, self.contentView.frame.size);
    
    if (!contentViewIsAutoresized) {
        CGRect contentViewFrame = self.contentView.frame;
        contentViewFrame.size = self.frame.size;
        self.contentView.frame = contentViewFrame;
    }
}

@end
