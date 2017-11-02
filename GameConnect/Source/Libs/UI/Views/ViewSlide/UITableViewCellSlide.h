//
//  UITableViewCellSlide.h
//  traceSport
//
//  Created by bigmac on 20/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIItemViewSlide.h"

@interface UITableViewCellSlide : UITableViewCell {
    UIItemViewSlide *t;
}
@property (nonatomic, strong)UIItemViewSlide *t;

@end
