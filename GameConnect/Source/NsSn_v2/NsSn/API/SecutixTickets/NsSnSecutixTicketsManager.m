//
//  NsSnSecutixTicketsManager.m
//  StadeDeFrance
//
//  Created by Quimoune NetcoSports on 25/02/2014.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "NsSnSecutixTicketsManager.h"
#import "NsSnConfManager.h"
#import "NsSnRequester.h"
#import "Extends+Libs.h"


@implementation NsSnSecutixTicketsManager


+(NsSnSecutixTicketsManager *)getInstance{
    static NsSnSecutixTicketsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnSecutixTicketsManager alloc] init];
    });
    return sharedMyManager;
}

-(void)getTicketsList:(void (^)(NsSnSecutixTicketsManager *rep, BOOL cache))cb_rep
{
    NSString *url = [[NsSnConfManager getInstance] getURL:NsSnConfigURLSecutixTicketsList];

    if ([url isSubString:@"(null)"])
        return cb_rep(nil, false);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        NSArray *a = [rep getXpathNilArray:@"tickets"];
        NsSnSecutixTicketsManager *ticketManager = [NsSnSecutixTicketsManager getInstance];
        ticketManager.ticketsList = nil;
        ticketManager.ticketsList = [NsSnTicketModel fromJSONArray:a];
        cb_rep(ticketManager, cache);
    } cache:YES];
}

-(void)getTicketById:(NSString *)ticketId cb_rep:(void (^)(NSString *filename, BOOL cache))cb_rep{
    NSString *file = [[NSString stringWithFormat:@"ticket-%@.pdf", ticketId] toiphonedoc];
    if ([file isFileExist]){
        cb_rep(file, YES);
    }
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLSecutixTicketById], ticketId];
    if ([url isSubString:@"(null)"])
        return cb_rep(nil, false);
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        [NSObject backGroundBlock:^{
            [data setDataSaveNSDataFile:file];
            [NSObject mainThreadBlock:^{
                cb_rep(file, cache);
            }];
        }];
    } cache:NO];
}


@end
