//
//  NSNetworkFactory.h
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractNetwork.h"

@interface NSNetworkFactory : NSObject

+ (AbstractNetwork *) getNetwork: (NSString *) networkId;

@end
