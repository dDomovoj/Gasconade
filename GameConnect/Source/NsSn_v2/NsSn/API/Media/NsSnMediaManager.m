//
//  NsSnMediaManager.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnMediaManager.h"
#import "NsSnConfManager.h"
#import "UIImageViewJA.h"
#import "Extends+Libs.h"

@implementation NsSnMediaManager


+(NsSnMediaManager*)getInstance{
    static NsSnMediaManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnMediaManager alloc] init];
    });
    return sharedMyManager;
}

-(NsSnMediaFormat*)getFormat:(NsSnMediaProfile)profile profiles:(NSArray*)profiles{
    NSString *key = [self getNameProfile:profile];
    for (int i = 0; i < [profiles count]; i++) {
        NsSnMediaFormat *m = profiles[i];
        if ([m.profil_name isEqualToString:key])
            return m;
    }
    return nil;
}

-(NSString*)getNameProfile:(NsSnMediaProfile)profile{
    if (profile == NsSnMediaProfile_l_640x640){
        return @"l_640x640";
    }else if (profile == NsSnMediaProfile_lr_1024x1024)
        return @"lr_1024x1024";
    else if (profile == NsSnMediaProfile_lr_640x640)
        return @"lr_640x640";
    else if (profile == NsSnMediaProfile_m_320x320)
        return @"m_320x320";
    else if (profile == NsSnMediaProfile_mr_320x320)
        return @"mr_320x320";
    else if (profile == NsSnMediaProfile_ms_140x140)
        return @"ms_140x140";
    else if (profile == NsSnMediaProfile_msr_140x140)
        return @"msr_140x140";
    else if (profile == NsSnMediaProfile_s_40x40)
        return @"s_40x40";
    else if (profile == NsSnMediaProfile_sr_40x40)
        return @"sr_40x40";
    return @"s_40x40";
}


-(void)setImageViewJARatio:(UIImageViewJA *)imageView media_name:(NSString*)media_name profiles:(NSArray*)profiles  profile:(NsSnMediaProfile)profile{
    if ([media_name length] == 0){
        [imageView setImage:[UIImage imageNamed:@"default_profile.png"]];
        return;
    }
    NSString *rep1 = [media_name substringWithRange:NSMakeRange(0, 3)];
    NSString *rep2 = [media_name substringWithRange:NSMakeRange(3, 3)];
    NsSnMediaFormat *m = [[NsSnMediaManager getInstance] getFormat:profile profiles:profiles];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@_%@.%@",[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageDns], m.media_base,rep1,rep2,media_name,m.profil_name,m.ext];
    [imageView loadImageFromURL:url ttl:[[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageTTL] unsignedIntValue]];
}
-(void)setImageViewJARatio:(UIImageViewJA *)imageView media_name:(NSString*)media_name{
    if ([media_name length] == 0){
        [imageView setImage:[UIImage imageNamed:@"default_profile.png"]];
        return;
    }
    NSString *rep1 = [media_name substringWithRange:NSMakeRange(0, 3)];
    NSString *rep2 = [media_name substringWithRange:NSMakeRange(3, 3)];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@/%@_%@.jpg",[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageDns], @"/ms/s",rep1,rep2,media_name,@"ms_140x140"];
    [imageView loadImageFromURL:url ttl:[[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageTTL] unsignedIntValue]];
}

-(void)setImageViewJARatioBig:(UIImageViewJA *)imageView media_name:(NSString*)media_name{
    if ([media_name length] == 0){
        [imageView setImage:[UIImage imageNamed:@"default_profile.png"]];
        return;
    }
    NSString *rep1 = [media_name substringWithRange:NSMakeRange(0, 3)];
    NSString *rep2 = [media_name substringWithRange:NSMakeRange(3, 3)];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@/%@_%@.jpg",[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageDns], @"/l/r",rep1,rep2,media_name,@"lr_640x640"];
    [imageView loadImageFromURL:url ttl:[[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageTTL] unsignedIntValue]];
}

@end
