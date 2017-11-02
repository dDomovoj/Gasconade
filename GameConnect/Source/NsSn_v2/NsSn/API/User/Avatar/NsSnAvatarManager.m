//
//  NsSnAvatarManager.m
//  StadeDeFrance
//
//  Created by Guillaume Derivery on 2/24/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "NsSnAvatarManager.h"
#import "NsSnConfManager.h"
#import "NsSnAvatarModel.h"

@implementation NsSnAvatarManager

+(BOOL) setImageViewJA:(UIImageViewJA *)img_view withRatio:(NsSnMediaProfile)ratio fromAvatars:(NSArray *)avatarFormats
{
    return [self setImageViewJA:img_view withRatio:ratio fromAvatars:avatarFormats andEndBlock:nil];
}

+(BOOL) setImageViewJA:(UIImageViewJA *)img_view withRatio:(NsSnMediaProfile)ratio fromAvatars:(NSArray *)avatarFormats andEndBlock:(void(^)(UIImageViewJA *image))cb_done
{
    if (!avatarFormats || [avatarFormats count] == 0)
    {
        [img_view setImage:[UIImage imageNamed:@"im_default_profile.png"]];
        cb_done(img_view);
        return FALSE;
    }
    
    NSString *url = nil;
    for (NsSnAvatarModel *avatar in avatarFormats)
    {
        if ([avatar.profile_name isEqualToString:[NsSnAvatarManager getFormat:ratio]])
        {
            url = [NSString stringWithFormat:@"%@", avatar.url];
            break;
        }
    }

    if (url && [url length] > 0)
    {
        [img_view loadImageFromURL:url ttl:[[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageTTL] unsignedIntValue] endblock:cb_done];
        return YES;
    }
    else
    {
        cb_done(img_view);
        return NO;
    }
}

+(NSString *) getAvatarURLFromAvatars:(NSArray *)avatarFormats withRatio:(NsSnMediaProfile)ratio
{
    if (!avatarFormats || [avatarFormats count] == 0)
        return @"im_default_profile.png";
    
    NSString *url = nil;
    for (NsSnAvatarModel *avatar in avatarFormats)
    {
        if ([avatar.profile_name isEqualToString:[NsSnAvatarManager getFormat:ratio]])
        {
            url = [NSString stringWithFormat:@"%@", avatar.url];
            break;
        }
    }
    return url;
}

+(NSString *) getFormat:(NsSnMediaProfile)profile
{
    switch (profile)
    {
        case NsSnMediaProfile_ss_40x40:
            return @"small_square";
            break;
        case NsSnMediaProfile_ls_640x640:
            return @"large_square";
            break;
        case NsSnMediaProfile_ms_320x320:
            return @"medium_square";
            break;
        case NsSnMediaProfile_mss_140x140:
            return @"medium_small_square";
            break;
        case NsSnMediaProfile_sr_40x60:
            return @"small_ratio";
            break;
        case NsSnMediaProfile_lr_640x960:
            return @"large_ratio";
            break;
        case NsSnMediaProfile_br_1024x1536:
            return @"big_ratio";
            break;
        case NsSnMediaProfile_mr_320x480:
            return @"medium_ration";
            break;
        case NsSnMediaProfile_msr_140x210:
            return @"medium_small_ratio";
            break;
        case NsSnMediaProfile_orig_640x960:
            return @"original";
            break;
        case NsSnMediaProfile_oao_640x960:
            return @"original_auto_oriented";
            break;
        default:
            return @"original";
            break;
    }
}

@end
