//
//  UILabel+UILabel_Tool.h
//  Extends
//
//  Created by bigmac on 05/10/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UILabel_Tool)

-(CGRect)setTexteRecadre:(NSString*)texte width:(int)width;
-(CGRect)setTexteRecadre:(NSString*)texte height:(int)height;
-(void)autoAccessibility:(NSString*)name;
-(CGRect)setTexteRecadre:(NSString*)texte width:(int)width hmax:(NSInteger)hmax;
-(CGRect)setTexteRecadre:(NSString*)texte width:(int)width hmin:(NSInteger)hmin;
-(CGRect)setAttributedTexteRecadre:(NSAttributedString *)texte width:(CGFloat)width;
-(CGRect)setAttributedTexteRecadre:(NSAttributedString *)texte height:(CGFloat)height;

@end
