//
//  NSObject+NSObject_Tool.m
//  Extends
//
//  Created by bigmac on 28/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "NSObject+NSObject_Tool.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (NSObject_Tool)

+(NSString*)getLangName{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSArray *langs = [defs objectForKey:@"AppleLanguages"];
	NSString *l = [langs[0] substringToIndex:2];
	return l;
}

+(NSString*)getFullLangName{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSArray *langs = [defs objectForKey:@"AppleLanguages"];
	NSString *l = langs[0];
	return l;
}

+(NSString*)getCountryPhone{
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    //NSDictionary *dic = [defs dictionaryRepresentation];
	NSString *langs = [defs objectForKey:@"AppleLocale"];
	NSString *l = [langs substringFromIndex:3];
    if ([l length] == 0)
        l = langs ;
	return l;
}
#define D_MAX_BG_QUEUE 20

+(void)backGroundBlockDownload:(void (^)())block{
	if (![NSThread isMainThread]){
		block();
		return;
	}
	
	static dispatch_queue_t ar_queue2[D_MAX_BG_QUEUE];
	static dispatch_once_t onceToken2;
	srand((unsigned int)time(NULL));
	dispatch_once(&onceToken2, ^{
		for (int i = 0; i < D_MAX_BG_QUEUE; i++) {
			ar_queue2[i] = dispatch_queue_create([[NSString stringWithFormat:@"MyQueue%d",i] cStringUsingEncoding:(NSUTF8StringEncoding)],NULL);
		}
	});
	int i = rand() % D_MAX_BG_QUEUE;
	dispatch_queue_t queue = ar_queue2[i];
	dispatch_async(queue, ^{
		block();
	});
}
+(void)backGroundBlock:(void (^)())block{
	if (![NSThread isMainThread]){
		block();
		return;
	}

	static dispatch_queue_t ar_queue[D_MAX_BG_QUEUE];
	static dispatch_once_t onceToken;
	srand((unsigned int)time(NULL));
	dispatch_once(&onceToken, ^{
		for (int i = 0; i < D_MAX_BG_QUEUE; i++) {
			ar_queue[i] = dispatch_queue_create([[NSString stringWithFormat:@"MyQueue%d",i] cStringUsingEncoding:(NSUTF8StringEncoding)],NULL);
		}
	});
	int i = rand() % D_MAX_BG_QUEUE;
	dispatch_queue_t queue = ar_queue[i];
	dispatch_async(queue, ^{
		block();
	});
}
+(void)mainThreadBlock:(void (^)())block{
	// safe if main thread run
	if ([NSThread isMainThread]){
		block();
		return;
	}
	dispatch_sync(dispatch_get_main_queue(), ^{
		block();
	});
}
+(BOOL)isRetina{
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            return YES;
        }
    }
	return NO;
}
-(void)NSObject_Tool:(void(^)())block{
	block();
}
-(void)performWithDelay:(NSTimeInterval)time block:(void(^)())block{
	[self performSelector:@selector(NSObject_Tool:) withObject:[block copy] afterDelay:time];
}


__strong static NSString *getVerionsiOS_systemVersion = nil;

+(int)getVerionsiOS{
	if (getVerionsiOS_systemVersion == nil)
		getVerionsiOS_systemVersion = [[UIDevice currentDevice] systemVersion];
	NSString *sysv = getVerionsiOS_systemVersion;
	int valssys = 0;
	if ([sysv length] > 1)
		sysv = [sysv substringToIndex:1];
	valssys = [sysv intValue];
	return valssys;
}
+(BOOL)isUniversalApplication{
    NSArray *deviceFamily =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UIDeviceFamily"];
	return [deviceFamily count]==2;
}


-(NSDictionary *)serializeToDictionary{
    Class clazz = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableDictionary* propertyDic = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char  *methodName = property_getName(properties[i]);
        NSString *method_name = [NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding];
        @try {
            id val = [self valueForKey:method_name];
            [propertyDic setObject:val forKey:method_name];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
        }
    }
    free(properties);
    return  propertyDic;
}
@end
