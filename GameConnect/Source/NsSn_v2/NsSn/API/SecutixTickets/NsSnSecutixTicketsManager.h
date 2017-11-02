//
//  NsSnSecutixTicketsManager.h
//  StadeDeFrance
//
//  Created by Quimoune NetcoSports on 25/02/2014.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnTicketModel.h"

@interface NsSnSecutixTicketsManager : NSObject{
    
}


@property (nonatomic, strong) NSArray *ticketsList;


+(NsSnSecutixTicketsManager *)getInstance;


-(void)getTicketsList:(void (^)(NsSnSecutixTicketsManager *rep, BOOL cache))cb_rep;
-(void)getTicketById:(NSString *)ticketId cb_rep:(void (^)(NSString *filename, BOOL cache))cb_rep;


@end
