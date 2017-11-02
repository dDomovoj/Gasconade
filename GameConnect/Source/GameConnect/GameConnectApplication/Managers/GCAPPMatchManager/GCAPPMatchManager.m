//
//  GCAPPMatchManager.m
//  FIFA_WC14
//
//  Created by Derivery Guillaume on 10/23/13.
//  Copyright (c) 2013 Netco Sports. All rights reserved.
//

#import "NSObject+NSObject_Tool.h"
#import "NSObject+NSObject_Xpath.h"
#import "GCAPPMatchManager.h"
#import "NSDataManager.h"
#import "NsSnConfManager.h"
#import "NsSnRequester.h"
#import <NSTRestAPIManager/NSTRestAPIManager.h>

//#import "PSGOneApp-Swift.h"

#define URL_MATCH_SHEET @"http://cdn.thefanclub.com/gsmsoccerexp/get_matchs_sheet_heads/%@.ijson"

@implementation GCAPPMatchManager

+(GCAPPMatchManager *)getInstance{
    static GCAPPMatchManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [GCAPPMatchManager new];
    });
    return sharedMyManager;
}

#pragma mark -
#pragma mark Game Connect

+(void)getGCListMatchsHeads:(NSString *)matchIDs rep:(void (^)(GCAPPMatchManager *rep, BOOL cache, NSData *data))cb_rep
{
    NSTRestAPIPlainRequest *request = [self matchRequestFor:matchIDs];
    [NSTRestAPIManager modelsForRequest:request].then((AnyPromise *)^(NSTRestAPIResponse *response, AnyPromise *fetch, NSArray *responses) {
        [NSObject backGroundBlock:^{
            GCAPPMatchManager *match_manager = [GCAPPMatchManager getInstance];

            NSArray *matchs = [GSMMatchModel fromJSONArray:[response.model getXpathNilArray:@"matches"]];

            if (!match_manager.match_event_gc){
                match_manager.match_event_gc = [[NSMutableDictionary alloc] init];
            }

            for (GSMMatchModel *matchMod in matchs)
            {
                [match_manager.match_event_gc setObject:matchMod forKey:matchMod.match_id];
            }

            [NSObject mainThreadBlock:^{
                if (cb_rep)
                    cb_rep(match_manager, NO, nil);
            }];
        }];
    }).catch(^(id error) {
        [NSObject mainThreadBlock:^{
            if (cb_rep)
                cb_rep([GCAPPMatchManager getInstance], NO, nil);
        }];
    });

}

+ (NSTRestAPIPlainRequest *)matchRequestFor:(NSString *)matchIds
{
    NSString *baseURL = ConfigManager.instance.config.opta.basePipelineURLString;
    NSString *url = [NSString stringWithFormat:@"%@matches/_/by_opta_id?match_ids=%@", baseURL, matchIds];

    NSTRestAPIPlainRequest *request = [[[[NSTRestAPIPlainRequest builder] setURLString:url] setResponseDataType:NSTResponseDataTypeJSON] build];

    return request;
}

+(GSMMatchModel *)getGCEventMatchFromId:(NSString *)matchId{
    GCAPPMatchManager *match_manager = [GCAPPMatchManager getInstance];
    return [match_manager.match_event_gc getXpath:matchId type:[GSMMatchModel class] def:nil];
}

+(NSArray *)getFakePokJSONArray
{
    NSArray *matches = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GSM_fake_matches" ofType:@"json"];
    NSError *fileError = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:(NSDataReadingMappedIfSafe) error:&fileError];
    
    if (!fileError)
    {
        NSError *jsonError;
        NSDictionary *gsmMatches = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
        if (gsmMatches)
        {
            matches = [gsmMatches getXpathNilArray:@"flux"];
            return matches;
        }
        else
        {
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    }
    else
    {
        NSLog(@"%@", [fileError localizedDescription]);
    }
    return nil;
}


@end
