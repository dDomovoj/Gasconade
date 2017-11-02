//
//  NsSnMediaFormat.h
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnModel.h"


@interface NsSnMediaFormat : NsSnModel

@property (nonatomic,retain) NSString *size;
@property (nonatomic,retain) NSString *profil_name;
@property (nonatomic,retain) NSString *ext;
@property (nonatomic,retain) NSString *media_base;

@end
