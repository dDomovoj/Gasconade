//
//  UILabel+UILabel_Xpath.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UILabel+UILabel_Xpath.h"
#import "NSObject+NSObject_Xpath.h"


@implementation UILabel (UILabel_Xpath)
-(void)setXpathText:(NSString*)xpath elt:(id)elt{
	NSString *s = [elt getXpathEmptyString:xpath];
	if (!s || !elt){
		s = @"";
	}
	self.text = s;
}
@end
