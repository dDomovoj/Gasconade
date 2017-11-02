//
//  IDataGG.h
//  GameConnectV2
//
//  Created by Guilaume Derivery on 29/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDataGG <NSObject>

@required
-(id) getElementForIndexPath:(NSIndexPath *)indexPath fromData:(id)data;
-(NSInteger) getNumberOfRowsInSection:(NSInteger)section forData:(id)data;
-(NSInteger) getNumberOfSectionsForData:(id)data; // Default => 1

@optional
-(id) getElementForSection:(NSInteger)section fromData:(id)data;
-(id) mergeOldData:(id)data withNewOne:(NSDictionary *)newData;

@end
