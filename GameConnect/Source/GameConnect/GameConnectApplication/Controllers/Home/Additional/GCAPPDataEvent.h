//
//  GCDataEvent.h
//  GameConnectV2
//
//  Created by Guilaume Derivery on 30/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDataGG.h"

@interface GCAPPDataEvent : NSObject <IDataGG>

@property (strong, nonatomic) NSString *parsingXpathItem;
@property (strong, nonatomic) NSAttributedString *eventsHeaderAttributedString;
@property (strong, nonatomic) NSAttributedString *noInfoAttributedString;

-(void) myInit;
-(void) addCustomData:(NSArray *)elements inSection:(NSInteger)section;
-(void) addDataForHeaderSections:(NSArray *)elements;

@end
