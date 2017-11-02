//
//  UIDevice+UIDevice_Tool.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#import "UIDevice+UIDevice_Tool.h"
#import "NSString+NSString_Tool.h"

@implementation UIDevice (UIDevice_Tool)



////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{

    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return outstring;
}

// Returns device model on raw format
- (NSString *)platformRawString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);

    return platform;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
	if (!macaddress)
		return @"";
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash md5];
    return uniqueIdentifier;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    // New for > iOS 6
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	if (!uniqueIdentifier)
		return @"";
    return [uniqueIdentifier strReplace:@"-" to:@""];

    // Deprecated in iOS 7
    //    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    //	if (!macaddress)
    //		return @"";
    //    NSString *uniqueIdentifier = [macaddress md5];
    //    return uniqueIdentifier;
}


+(BOOL)isIPAD{
	NSString * model = [[UIDevice currentDevice] model];
	return [model isSubString:@"iPad"];
}
+(BOOL)isOrientationPortrait{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)
        return YES;
    return NO;
}
+(CGRect)getScreenFrame{
	return CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+(BOOL) isIphone5
{
    return [UIDevice getScreenFrame].size.height == 568 ? YES : NO;
}

- (NSString *)getDeviceType
{
    NSString *platform = [self platformRawString];

    if ([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])
        return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])
        return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])
        return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])
        return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])
        return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])
        return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])
        return @"iPad 3 (4G,2)";
    if ([platform isEqualToString:@"iPad3,3"])
        return @"iPad 3 (4G,3)";
    if ([platform isEqualToString:@"i386"])
        return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])
        return @"Simulator";

    return platform;
}

@end
