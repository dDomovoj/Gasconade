//
//  NSObject+NSObject_Xpath.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSObject+NSObject_Xpath.h"
#import "NSString+NSString_Tool.h"

@implementation NSObject (NSObject_Xpath)


#if TARGET_IPHONE_SIMULATOR
#define MYLOG(a) NSLog(@"%@",a);
#else
//	#ifdef DEBUG
#define MYLOG(a) NSLog(@"%@",a);
//	#else
//		#define MYLOG(a)
//	#endif
#endif
-(id)getXpath:(NSString*)xpath type:(Class)type def:(id)def obj:(NSObject*)obj restXpath:(NSString**)restXpath{
	if ([xpath length] == 0){
		if ([self isKindOfClass:type]  && ![self isKindOfClass:[NSNull class]])
			return self;
		else{
#if TARGET_IPHONE_SIMULATOR
			//NSLog(@"BAD TYPE FOUND : WANT %@ FOUND => %@" , [type description], [self description]);
#endif
            
			return def;
		}
	}
	
	NSString *c = [xpath substringToIndex:1];
	if ([c isEqualToString:@"/"]){
		NSString *p = [xpath substringFromIndex:1];
		*restXpath = p;
		return [self getXpath:p type:type def:def obj:obj restXpath:restXpath];
	}
	if ([c isEqualToString:@"["]){
		NSString *s = [[xpath substringToIndex:2] substringFromIndex:1];
		// sub XPATH
		if ([s isEqualToString:@"/"]){
			NSString *xp = [xpath substringFromIndex:1];
			NSObject *key = [obj getXpath:xp type:[NSObject class] def:nil obj:obj restXpath:restXpath];
			NSString *ms = [NSString stringWithString:(*restXpath)];
			*restXpath = [ms substringFromIndex:1];
			if ([self isKindOfClass:[NSDictionary class]]){
                //				NSString *k = (NSString *)key;
                //				if ([key isKindOfClass:[NSNumber class]])
                //					k = [((NSNumber*)key) description];
				
				//return [self getXpath:[NSString stringWithFormat:@"/%@/%@",key,(*restXpath)] type:type def:def obj:obj restXpath:restXpath];
                id kk = key;
                NSDictionary *dd = (NSDictionary*)self;
                if (dd[kk]){
                    id sub = dd[kk];
                    return [sub getXpath:[NSString stringWithFormat:@"/%@",(*restXpath)] type:type def:def obj:obj restXpath:restXpath];
                }else{
#if TARGET_IPHONE_SIMULATOR
                    //NSLog(@"ERROR WANT KEY OF NSDICO BUT NOT FOUND KEY '%@' IN %@ ",[key description], [self description]);
#endif
                    return def;
                }
			}else if ([self isKindOfClass:[NSArray class]]){
				if ([key isKindOfClass:[NSString class]]){
					int i = [((NSString*)key) intValue];
					return [self getXpath:[NSString stringWithFormat:@"/[%d]/%@",i,(*restXpath)] type:type def:def obj:obj restXpath:restXpath];
				}else{
#if TARGET_IPHONE_SIMULATOR
					//NSLog(@"error index not found %@ (sub : %@)in %@",xpath, xp , [self description]);
#endif
					return def;
				}
			}else{
#if TARGET_IPHONE_SIMULATOR
				//NSLog(@"ERROR UN KNOW TYPE: %@ in %@",xpath, [self description]);
#endif
				return def;
			}
		}
		
		
		NSRange r;
		r.length = [xpath indexOfSubString:@"]"] - 1;
		r.location = 1;
		NSString *i = [xpath substringWithRange:r];
		if ([self isKindOfClass:[NSArray class]]){
			NSArray *a = (NSArray *)self;
			NSString *p = [xpath substringFromIndex:r.length +2];
			int j = [i intValue];
			if (j < [a count]){
				*restXpath = p;
				return [a[j] getXpath:p type:type def:def obj:obj restXpath:restXpath];
			}
			else{
#if TARGET_IPHONE_SIMULATOR
				//NSLog(@"GET XPATH : %@ NOT FOUND index => %d count %d" , xpath , j , [a count]);
#endif
				return def;
			}
			
		}else{
#if TARGET_IPHONE_SIMULATOR
			//NSLog(@"BAD TYPE FOUND : WANT ARRAY FOUND => %@" , [self description]);
#endif
			return def;
		}
		return def;
	}
	
	if ([c isEqualToString:@"]"]){
		if ([self isKindOfClass:type] && ![self isKindOfClass:[NSNull class]])
			return self;
		else{
#if TARGET_IPHONE_SIMULATOR
			//NSLog(@"BAD TYPE FOUND : WANT %@ FOUND => %@" , [type description], [self description]);
#endif
			return def;
		}
	}
	if ([self isKindOfClass:[NSDictionary class]]){
		NSInteger a = [xpath indexOfSubString:@"/"];
		NSInteger b = [xpath indexOfSubString:@"["];
        NSInteger c = [xpath indexOfSubString:@"]"];
		NSInteger k = MIN(a, b);
        k = MIN(k, c);
		k = MIN([xpath length], k);
		NSString *key = [xpath substringToIndex:k];
		NSString *s = [xpath substringFromIndex:k];
		NSDictionary *d = (NSDictionary*)self;
		if (d[key]){
			*restXpath = s;
			return [d[key] getXpath:s type:type def:def obj:obj restXpath:restXpath];
		}else{
#if TARGET_IPHONE_SIMULATOR
			//NSLog(@"ERROR KEY IN NSDICTIONARY NOT FOUND %@",key);
#endif
			return def;
		}
	}
	
#if TARGET_IPHONE_SIMULATOR
	//NSLog(@"ERROR FOUND XPATH %@: WANT %@ FOUND => %@" ,xpath, [type description ], [self description]);
#endif
	return  def;
}

-(id)getXpath:(NSString*)xpath type:(Class)type def:(id)def{
	NSString *r = nil;
	return [self getXpath:xpath type:type def:def obj:self restXpath:&r];
}
-(NSString *)getXpathEmptyString:(NSString*)xpath{
	return [self getXpath:xpath type:[NSString class] def:@""];
}
-(NSString *)getXpathIntegerToString:(NSString*)xpath{
	return [NSString stringWithFormat:@"%d", [[self getXpath:xpath type:[NSNumber class] def:@0] intValue]];
}

-(int)getXpathInteger:(NSString*)xpath{
	return [[self getXpath:xpath type:[NSNumber class] def:@0] intValue];
}

-(long)getXpathLong:(NSString*)xpath{
	return [[self getXpath:xpath type:[NSNumber class] def:@0] longValue];
}
//-(id)getXpathDoubleToString:(NSString*)xpath{
//	return [NSString stringWithFormat:@"%f", [[self getXpath:xpath type:[NSNumber class] def:[NSNumber numberWithD:0]] intValue]];
//}

-(id)getXpathNil:(NSString*)xpath type:(Class)type{
	return [self getXpath:xpath type:type def:nil];
}
-(NSString *)getXpathNilString:(NSString*)xpath{
	return [self getXpath:xpath type:[NSString class] def:nil];
}

-(NSDictionary*)getXpathNilDictionary:(NSString*)xpath{
	return [self getXpath:xpath type:[NSDictionary class] def:nil];
}

-(NSArray*)getXpathNilArray:(NSString*)xpath{
	return [self getXpath:xpath type:[NSArray class] def:nil];
}

-(BOOL)getXpathBool:(NSString*)xpath defaultValue:(BOOL)defaultValue{
	
    NSNumber *returnedValue = [self getXpath:xpath type:[NSNumber class] def:nil];
    
    return returnedValue ? [returnedValue boolValue] : defaultValue;
}


-(id)ToMutable{
	if ([self isKindOfClass:[NSString class]]){
		NSMutableString * s = [[NSMutableString alloc] init] ;
		[s appendString:(NSString*)self];
		return s;
	}
	if ([self isKindOfClass:[NSArray class]]){
		NSArray *a = (NSArray *)self;
		NSMutableArray *ar = [[NSMutableArray alloc] init] ;
		for (id e in a) {
			id ee = [e ToMutable];
			[ar addObject:ee];
		}
		return ar;
	}
	if ([self isKindOfClass:[NSDictionary class]]){
		NSDictionary *a = (NSDictionary *)self;
		NSMutableDictionary *ar = [[NSMutableDictionary alloc] init] ;
		for (id k in [a allKeys]) {
			id e = a[k];
			id ee = [e ToMutable];
			id kk = [k ToMutable];
			ar[kk] = ee;
		}
		return ar;
	}
	return self;
}


-(id)ToUnMutable{
	if ([self isKindOfClass:[NSMutableString class]]){
		return [NSString stringWithString:(NSString*)self];
	}
	if ([self isKindOfClass:[NSMutableArray class]]){
		NSArray *a = (NSArray *)self;
		NSMutableArray *ar = [[NSMutableArray alloc] init];
		for (id e in a) {
			id ee = [e ToUnMutable];
			[ar addObject:ee];
		}
		return [NSArray arrayWithArray:ar];
	}
	if ([self isKindOfClass:[NSMutableDictionary class]]){
		NSDictionary *a = (NSDictionary *)self;
		NSMutableDictionary *ar = [[NSMutableDictionary alloc] init];
		for (id k in [a allKeys]) {
			id e = a[k];
			id ee = [e ToUnMutable];
			id kk = [k ToUnMutable];
			ar[kk] = ee;
		}
		return [NSDictionary dictionaryWithDictionary:ar];
	}
	return self;
}

@end
