//
//  GCSponsorsManager.m
//  PSG_Stadium
//
//  Created by Sergey Dikovitsky on 10/18/16.
//  Copyright © 2016 Netcosports. All rights reserved.
//

#import "GCSponsorsManager.h"
#warning GC TEST POST
#import "GCConfManager.h"

@implementation GCSponsorsManager

CREATE_INSTANCE

- (void)postPixelRequest
{
  NSString *URLString = [GCConfManager getInstance].pixelURLString;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];

    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];

    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [dataTask resume];
}

@end
