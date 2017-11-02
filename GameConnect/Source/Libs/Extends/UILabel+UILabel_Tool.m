//
//  UILabel+UILabel_Tool.m
//  Extends
//
//  Created by bigmac on 05/10/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UILabel+UILabel_Tool.h"
#import "NSObject+NSObject_Tool.h"

@implementation UILabel (UILabel_Tool)

-(CGRect)setTexteRecadre:(NSString*)texte width:(int)width{
	CGSize aSize;
    self.numberOfLines = 100000;
    self.text = texte;
    CGSize expectedSize = [self sizeThatFits:CGSizeMake(width, 10000.0)];
    aSize = expectedSize;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, ceilf(aSize.height));
	return self.frame;
}

-(CGRect)setTexteRecadre:(NSString*)texte height:(int)height{
	CGSize aSize;
    self.numberOfLines = 100000;
    self.text = texte;
    CGSize expectedSize = [self sizeThatFits:CGSizeMake(10000.f, height)];
    aSize = expectedSize;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, ceilf(aSize.width), height);
	return self.frame;
}

-(CGRect)setTexteRecadre:(NSString*)texte width:(int)width hmax:(NSInteger)hmax{
	CGSize aSize;
    self.numberOfLines = 100000;
    self.text = texte;
    CGSize expectedSize = [self sizeThatFits:CGSizeMake(width, 10000.0)];
    aSize = expectedSize;
    
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, ceilf(aSize.height));
	
	if (hmax > aSize.height  || hmax <= self.frame.size.height)
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, ceilf(aSize.height));
	else
		if (hmax > self.frame.size.height)
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, hmax);
	
	return self.frame;
}

-(CGRect)setTexteRecadre:(NSString*)texte width:(int)width hmin:(NSInteger)hmin{
	CGSize aSize;
    self.numberOfLines = 100000;
    self.text = texte;
    CGSize expectedSize = [self sizeThatFits:CGSizeMake(width, 10000.0)];
    aSize = expectedSize;
    
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, ceilf(aSize.height));

	if (self.frame.size.height < hmin)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, hmin);
    }
    
//	if (him < aSize.height  || hmin >= self.frame.size.height)
//		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, ceilf(aSize.height));
//	else
//		if (hmax > self.frame.size.height)
//			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, hmax);
	
	return self.frame;
}


-(CGRect)setAttributedTexteRecadre:(NSAttributedString *)texte width:(CGFloat)width{
	CGSize aSize;
    self.numberOfLines = 100000;
    self.attributedText = texte;
    CGSize expectedSize = [self sizeThatFits:CGSizeMake(width, 10000.0)];
    aSize = expectedSize;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, ceilf(aSize.height));
	return self.frame;
}

-(CGRect)setAttributedTexteRecadre:(NSAttributedString *)texte height:(CGFloat)height{
	CGSize aSize;
    self.numberOfLines = 100000;
    self.attributedText = texte;
    CGSize expectedSize = [self sizeThatFits:CGSizeMake(10000.f, height)];
    aSize = expectedSize;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, ceilf(aSize.width), height);
	return self.frame;
}

-(void)autoAccessibility:(NSString*)name{
    if(!name)
        name = self.text;
    self.accessibilityLabel = name;
}
@end
