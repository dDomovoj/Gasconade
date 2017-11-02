//
//  CHMatchView.h
//
//  Created by Édouard RICHARD on 18.12.13
//  Copyright (c) 2013 Édouard RICHARD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewJA.h"

@interface CHMatchView : UIView

@property (strong, nonatomic) NSDictionary *match;

@property (weak, nonatomic) IBOutlet UIView *v_content;

@property (weak, nonatomic) IBOutlet UIImageViewJA *im_t1;
@property (weak, nonatomic) IBOutlet UIImageViewJA *im_t2;


-(void)setMyMatch:(NSDictionary *)match;

@end
