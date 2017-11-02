//
//  NSObject+NSObject_Xpath.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_Xpath)

-(id)getXpath:(NSString*)xpath type:(Class)type def:(id)def;
-(NSString *)getXpathEmptyString:(NSString*)xpath;
-(NSString *)getXpathIntegerToString:(NSString*)xpath;
-(int)getXpathInteger:(NSString*)xpath;
-(long)getXpathLong:(NSString*)xpath;
-(id)getXpathNil:(NSString*)xpath type:(Class)type;
-(NSString *)getXpathNilString:(NSString*)xpath;
-(NSDictionary *)getXpathNilDictionary:(NSString*)xpath;
-(NSArray*)getXpathNilArray:(NSString*)xpath;
-(BOOL)getXpathBool:(NSString*)xpath defaultValue:(BOOL)defaultValue;

-(id)ToMutable;
-(id)ToUnMutable;
@end
