//
//  GSMTeamModel.h
//  FIFA_WC14
//
//  Created by Quimoune NetcoSports on 21/10/13.
//  Copyright (c) 2013 Netco Sports. All rights reserved.
//

#import "GSMTeamModel.h"
#import "Extends+Libs.h"
//#import "PSGOneApp-Swift.h"

@implementation GSMTeamModel

+ (GSMTeamModel *) fromJSON:(NSDictionary *)dic{
    GSMTeamModel *model = [GSMTeamModel new];
    
    if (dic && [dic isKindOfClass:[NSDictionary class]])
    {
        model.team_id = [dic getXpathNilString:@"team_id"];
        if (!model.team_id)
            model.team_id = [dic getXpathNilString:@"id"];

        model.team_name = [dic getXpathEmptyString:@"team_name"];
        model.team_short_name = [[dic getXpathEmptyString:@"abbrev_name"] uppercaseString];
        model.team_official_name = [dic getXpathEmptyString:@"official_name"];
        model.team_city_name = [dic getXpathEmptyString:@"city_name"];
        model.team_area_name = [dic getXpathEmptyString:@"area_name"];
        model.team_founded_year = [dic getXpathEmptyString:@"founded"];
        model.team_address = [dic getXpathEmptyString:@"address"];
        model.team_address_number = [dic getXpathEmptyString:@"address_number"];
        model.team_address_extra = [dic getXpathEmptyString:@"address_extra"];
        model.team_address_zip = [dic getXpathEmptyString:@"address_zip"];
        model.team_phone = [dic getXpathEmptyString:@"phone"];
        model.team_fax = [dic getXpathEmptyString:@"fax"];
        model.team_email = [dic getXpathEmptyString:@"email"];
        model.team_url = [dic getXpathEmptyString:@"url"];
        model.team_colors = [dic getXpathEmptyString:@"club_colors"];
        model.team_has_pic = [dic getXpathEmptyString:@"has_photo"];
        
        model.team_image_url = [NSString stringWithFormat:@"http://cdn.thefanclub.com/data_externe_iphone/FIFA/teams/team_64/%@.png", [model.team_short_name lowercaseString]];
        model.team_image_big_url = [NSString stringWithFormat:@"http://cdn.thefanclub.com/data_externe_iphone/FIFA/teams/big_team/%@.png", [model.team_short_name lowercaseString]];
        model.team_federation_image_url = [NSString stringWithFormat:@"http://cdn.thefanclub.com/data_externe_iphone/FIFA/teams/fed/%@.png", [model.team_short_name lowercaseString]];
        ;
        model.team_image_url = [NSString stringWithFormat:@"%@%@.png", [ConfigManager instance].config.opta.clubLogosURLString, model.team_id];
    }
    return model;
}

+(NSString *)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic format:(NSString *)format{
    // Formats : 20x20 / 25x25 / 50x50 or none
	int isPic = 0;
    if ([hasPic isKindOfClass:[NSString class]]){
        isPic = [hasPic intValue];
    }
    else if ([hasPic isKindOfClass:[NSNumber class]]){
        isPic = [hasPic intValue];
    }
    
	if (format && [format isNotEqualToString:@""]){
	} else {
		format = @"teams";
	}
    NSString *url = [NSString stringWithFormat:@"http://cdn.thefanclub.com/gsm_medias/soccer/%@/generic.png", format];
    if (isPic == 1){
        int dirInt = (floor([idTeam intValue] / 1000) + 1) * 1000;
        NSString *dir = [NSString stringWithFormat:@"%d", dirInt];
        url = [NSString stringWithFormat:@"http://cdn.thefanclub.com/gsm_medias/soccer/%@/%@/%@.png", format, dir, idTeam];
    }
    return url;
}


+(NSArray *)fromJSONArray:(NSArray*)data{
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[data count]];
    [data each:^(NSInteger index, id elt, BOOL last){
        GSMTeamModel *model = [GSMTeamModel fromJSON:elt];
        [ret addObject:model];
    }];
    return ret;
}

@end
