//
//  UINotificationView.h
//  CANALProject
//
//  Created by bigmac on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINotificationView : UIView{
	int last;
}
@property (strong, nonatomic) IBOutlet UILabel *lb_nb;
@property (strong, nonatomic) IBOutlet UIView *v_view;


-(void)setNb:(int)nb;
-(void)clear;

@end
