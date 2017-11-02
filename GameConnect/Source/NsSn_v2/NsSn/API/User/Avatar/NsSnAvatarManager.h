//
//  NsSnAvatarManager.h
//  StadeDeFrance
//
//  Created by Guillaume Derivery on 2/24/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageViewJA.h"

typedef enum
{
    NsSnMediaProfile_ss_40x40,
    NsSnMediaProfile_ls_640x640,
    NsSnMediaProfile_ms_320x320,
    NsSnMediaProfile_mss_140x140,
    
    NsSnMediaProfile_sr_40x60,
    NsSnMediaProfile_lr_640x960,
    NsSnMediaProfile_br_1024x1536,
    
    NsSnMediaProfile_mr_320x480,
    NsSnMediaProfile_msr_140x210,
    NsSnMediaProfile_orig_640x960,
    NsSnMediaProfile_oao_640x960
} NsSnMediaProfile;

@interface NsSnAvatarManager : NSObject

+(BOOL) setImageViewJA:(UIImageViewJA *)img_view withRatio:(NsSnMediaProfile)ratio fromAvatars:(NSArray *)avatarFormats;

+(BOOL) setImageViewJA:(UIImageViewJA *)img_view withRatio:(NsSnMediaProfile)ratio fromAvatars:(NSArray *)avatarFormats andEndBlock:(void(^)(UIImageViewJA *image))cb_done;

+(NSString *) getAvatarURLFromAvatars:(NSArray *)avatarFormats withRatio:(NsSnMediaProfile)ratio;

@end
