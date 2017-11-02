//
//  GSMTeamModel.h
//  FIFA_WC14
//
//  Created by Quimoune NetcoSports on 21/10/13.
//  Copyright (c) 2013 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCModel.h"

@interface GSMTeamModel : GCModel

@property (strong, nonatomic) NSString *team_id;
@property (strong, nonatomic) NSString *team_name;
@property (strong, nonatomic) NSString *team_short_name;
@property (strong, nonatomic) NSString *team_official_name;
@property (strong, nonatomic) NSString *team_city_name;
@property (strong, nonatomic) NSString *team_area_name;
@property (strong, nonatomic) NSString *team_founded_year;
@property (strong, nonatomic) NSString *team_address;
@property (strong, nonatomic) NSString *team_address_number;
@property (strong, nonatomic) NSString *team_address_extra;
@property (strong, nonatomic) NSString *team_address_zip;
@property (strong, nonatomic) NSString *team_phone;
@property (strong, nonatomic) NSString *team_fax;
@property (strong, nonatomic) NSString *team_email;
@property (strong, nonatomic) NSString *team_url;
@property (strong, nonatomic) NSString *team_colors;
@property (strong, nonatomic) NSString *team_has_pic;
@property (strong, nonatomic) NSString *team_image_url;
@property (strong, nonatomic) NSString *team_image_big_url;
@property (strong, nonatomic) NSString *team_federation_image_url;

@end
