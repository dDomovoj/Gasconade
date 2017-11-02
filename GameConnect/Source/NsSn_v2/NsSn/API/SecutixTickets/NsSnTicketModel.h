//
//  NsSnTicketModel.h
//  StadeDeFrance
//
//  Created by Quimoune NetcoSports on 25/02/2014.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"


@interface NsSnTicketModel : NsSnModel

@property (nonatomic, strong) NSString *ticket_id;
@property (nonatomic, strong) NSString *ticket_event_id;
@property (nonatomic, strong) NSString *ticket_performance_id;
@property (nonatomic, strong) NSString *ticket_product;
@property (nonatomic, strong) NSString *ticket_date;
@property (nonatomic, strong) NSDate   *ticket_date_utc;
@property (nonatomic, strong) NSString *ticket_entrance;
@property (nonatomic, strong) NSString *ticket_loge;
@property (nonatomic, strong) NSString *ticket_block;
@property (nonatomic, strong) NSString *ticket_row;
@property (nonatomic, strong) NSString *ticket_seat_number;


@end
