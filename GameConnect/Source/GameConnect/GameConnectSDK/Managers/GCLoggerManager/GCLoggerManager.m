//
//  GCLoggerManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 25/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

//#import "GCLoggerManager.h"
#import "Extends+Libs.h"

@implementation GCLoggerManager
{
    NSDictionary *initializedTagName;
}

#pragma Singleton
+(GCLoggerManager *) getInstance
{
    static GCLoggerManager *logManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logManager = [[self alloc] init];
    });
    return logManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GCAppTag" ofType:@"json"];
        NSError *fileError = nil;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:(NSDataReadingMappedIfSafe) error:&fileError];
        
        if (!fileError)
        {
            NSError *jsonError;
            NSDictionary *tagName = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            if (tagName)
                initializedTagName = [tagName getXpathNilDictionary:@"tagName"];
            else
                NSLog(@"GCLoggerManager : JSON Error => %@", [jsonError localizedDescription]);
        }
        else
            NSLog(@"GCLoggerManager : File Error => %@", [fileError localizedDescription]);
        

    }
    return self;
}

-(NSString *) getTagNameForKey:(NSString *)key
{
    if (initializedTagName)
        return [initializedTagName getXpathEmptyString:key];
    return @"";
}


+(void)GCLog:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSLog(format, args);
    va_end(args);
}

-(void)GCTag:(NSString *)clasname
{
    if (self.blockEventTrackingVCSDK)
    {
        self.blockEventTrackingVCSDK(clasname);
    }
    else
    {
 //    NSLog(@"GCTag %@",format);
    }
}

-(void)GCTagApp:(NSString *)clasname
{
    NSString*tagName = [self getTagNameForKey:clasname];
    
    if (self.blockEventTrackingVCAPP)
    {
        self.blockEventTrackingVCAPP(tagName);
    }
    else
    {
        if (tagName && [tagName length] > 0)
        {
        }
        else
        {
            NSLog(@"=> TRACK GC NOT GOOD : classname => %@", clasname);
        }
    }
}

@end
