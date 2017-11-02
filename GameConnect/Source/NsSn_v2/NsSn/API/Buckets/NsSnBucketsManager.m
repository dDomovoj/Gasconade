//
//  NsSnBucketsManager.m
//  StadeDeFrance
//
//  Created by Quimoune NetcoSports on 25/02/2014.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "NsSnBucketsManager.h"
#import "NsSnConfManager.h"
#import "NsSnRequester.h"
#import "Extends+Libs.h"

@implementation NsSnBucketsManager

+(NsSnBucketsManager *)getInstance{
    static NsSnBucketsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[NsSnBucketsManager alloc] init];
    });
    return sharedMyManager;
}

-(void)setBucketsByName:(NSString *)bucketName andValue:(NSData *)data cb_rep:(void (^)(BOOL ok))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLBucketSetByName], bucketName];
    
    NSDictionary *postDic = @{@"datas_with_content_type" : @[@{@"name": @"file", @"content_type": @"text/plain", @"datas": data}]};
    
    if ([url isSubString:@"(null)"])
        return cb_rep(NO);
    
    [NsSnRequester request:url post:postDic cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        BOOL isOK = NO;
        if ([[rep getXpathIntegerToString:@"bucket_saved"] isEqualToString:@"1"]){
            isOK = YES;
        }
        cb_rep(isOK);
    } cache:NO];
}

-(void)getBucketsByName:(NSString *)bucketName cb_rep:(void (^)(NSDictionary *rep, NSData *data, BOOL cache))cb_rep{
    NSString *url = [NSString stringWithFormat:[[NsSnConfManager getInstance] getURL:NsSnConfigURLBucketGetByName], bucketName];
    
    if ([url isSubString:@"(null)"])
        return cb_rep(nil, nil, NO);
    
    [NsSnRequester request:url cb_rep:^(NSDictionary *rep, BOOL cache, NSData *data, NSInteger httpcode, NsSnUserErrorValue error) {
        cb_rep(rep, data, cache);
    } cache:NO];
}



@end
