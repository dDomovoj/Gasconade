//
//  NsSnTicketModel.m
//  StadeDeFrance
//
//  Created by Quimoune NetcoSports on 25/02/2014.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "NsSnTicketModel.h"
#import "Extends+Libs.h"
#import "NsSnConfManager.h"

@implementation NsSnTicketModel


-(NSDictionary *)toDictionary{
    NSDictionary *dic = @{
                          @"ticket_id": self.ticket_id,
                          @"event_id": self.ticket_event_id,
                          @"performance_id": self.ticket_performance_id,
                          @"product": self.ticket_product,
                          @"date": self.ticket_date,
                          @"entrance": self.ticket_entrance,
                          @"loge": self.ticket_loge,
                          @"block": self.ticket_block,
                          @"row": self.ticket_row,
                          @"seat_number": self.ticket_seat_number,
                          };
    return dic;
}

-(void)fromJSON:(NSDictionary *)data {
    self.ticket_id = [data getXpathEmptyString:@"ticket_id"];
    self.ticket_event_id = [data getXpathEmptyString:@"event_id"];
    self.ticket_performance_id = [data getXpathEmptyString:@"performance_id"];
    self.ticket_product = [data getXpathEmptyString:@"product"];
    self.ticket_date = [data getXpathEmptyString:@"date"];
    self.ticket_entrance = [data getXpathEmptyString:@"entrance"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:self.ticket_date];
    
    
    //date = [NSDate dateWithTimeIntervalSinceNow:60*1+24*60*60];
    
    self.ticket_date_utc = date;
    self.ticket_loge = [data getXpathEmptyString:@"loge"];
    self.ticket_block = [data getXpathEmptyString:@"block"];
    self.ticket_row = [data getXpathEmptyString:@"row"];
    self.ticket_seat_number = [data getXpathEmptyString:@"seat_number"];
}


+(NsSnTicketModel *)fromJSON:(NSDictionary*)data {
    NsSnTicketModel *elt = [NsSnTicketModel new];
    [elt fromJSON:data];
    return elt;
}

+(id)fromJSONArray:(NSArray*)data {
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnTicketModel fromJSON:elt]];
    }];
    return ret;
}


@end
