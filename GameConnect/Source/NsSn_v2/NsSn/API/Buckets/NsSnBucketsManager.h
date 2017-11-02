//
//  NsSnBucketsManager.h
//  StadeDeFrance
//
//  Created by Quimoune NetcoSports on 25/02/2014.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NsSnBucketsManager : NSObject{
    
}

+(NsSnBucketsManager *)getInstance;

-(void)setBucketsByName:(NSString *)bucketName andValue:(NSData *)data cb_rep:(void (^)(BOOL ok))cb_rep;
-(void)getBucketsByName:(NSString *)bucketName cb_rep:(void (^)(NSDictionary *rep, NSData *data, BOOL cache))cb_rep;


@end
