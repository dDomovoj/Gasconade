//
//  NsSnModel.h
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NsSnModel : NSObject

-(NSDictionary*)toDictionary;
+(id) fromJSON:(NSDictionary*)data;
+(id) fromJSONArray:(NSArray*)data;
-(BOOL)validate;

@end
