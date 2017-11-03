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
#import "GCConfManager.h"

//#define URL_MATCH_SHEET @"http://cdn.thefanclub.com/gsmsoccerexp/get_matchs_sheet_heads/%@.ijson"

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

#warning UARENA
+(void)getGCListMatchsHeads:(NSString *)matchIDs rep:(void (^)(GCAPPMatchManager *rep, BOOL cache, NSData *data))cb_rep {
  NSString *urlString = [self matchRequestUrlStringFor:matchIDs];
  [NsSnRequester request:urlString cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
    [NSObject backGroundBlock:^{
      GCAPPMatchManager *match_manager = [GCAPPMatchManager getInstance];
      NSArray *matchs = [GSMMatchModel fromJSONArray:[rep getXpathNilArray:@"flux"]];

      if (!match_manager.match_event_gc){
        match_manager.match_event_gc = [[NSMutableDictionary alloc] init];
      }

      for (GSMMatchModel *matchMod in matchs) {
        [match_manager.match_event_gc setObject:matchMod forKey:matchMod.match_id];
      }
      [NSObject mainThreadBlock:^{
        if (cb_rep)
          cb_rep(match_manager, cache, data);
      }];
    }];
  } cache:NO];
}

+ (NSString *)matchRequestUrlStringFor:(NSString *)matchIds {
  NSString *baseURL = [GCConfManager getInstance].basePipelineURLString;
  NSString *url = [NSString stringWithFormat:@"%@matches/_/by_opta_id?match_ids=%@", baseURL, matchIds];
  return url;
}

+(GSMMatchModel *)getGCEventMatchFromId:(NSString *)matchId{
  GCAPPMatchManager *match_manager = [GCAPPMatchManager getInstance];
  return [match_manager.match_event_gc getXpath:matchId type:[GSMMatchModel class] def:nil];
}

+(NSArray *)getFakePokJSONArray {
  NSArray *matches = nil;
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GSM_fake_matches" ofType:@"json"];
  NSError *fileError = nil;
  NSData *data = [NSData dataWithContentsOfFile:filePath options:(NSDataReadingMappedIfSafe) error:&fileError];
  if (!fileError) {
    NSError *jsonError;
    NSDictionary *gsmMatches = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (gsmMatches) {
      matches = [gsmMatches getXpathNilArray:@"flux"];
      return matches;
    }
    else {
      NSLog(@"%@", [jsonError localizedDescription]);
    }
  }
  else {
    NSLog(@"%@", [fileError localizedDescription]);
  }
  return nil;
}

@end
