//
//  NsSnMediaManager.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"
#import "NsSnMediaFormat.h"
#import "UIImageViewJA.h"

typedef enum  {
    NsSnMediaProfile_s_40x40,
    NsSnMediaProfile_l_640x640,
    NsSnMediaProfile_m_320x320,
    NsSnMediaProfile_ms_140x140,
    NsSnMediaProfile_sr_40x40,
    NsSnMediaProfile_lr_640x640,
    NsSnMediaProfile_lr_1024x1024,
    NsSnMediaProfile_mr_320x320,
    NsSnMediaProfile_msr_140x140
} NsSnMediaProfile;

@interface NsSnMediaManager : NSObject
+(NsSnMediaManager*)getInstance;
-(NsSnMediaFormat*)getFormat:(NsSnMediaProfile)profile profiles:(NSArray*)profiles;
-(void)setImageViewJARatio:(UIImageViewJA *)imageView media_name:(NSString*)media_name profiles:(NSArray*)profiles  profile:(NsSnMediaProfile)profile;
-(void)setImageViewJARatio:(UIImageViewJA *)imageView media_name:(NSString*)media_name;
-(void)setImageViewJARatioBig:(UIImageViewJA *)imageView media_name:(NSString*)media_name;
@end
