//
//  GCDataEvent.m
//  GameConnectV2
//
//  Created by Guilaume Derivery on 30/03/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPDataEvent.h"
#import "Extends+Libs.h"
#import "GCEventModel.h"

@interface GCAPPDataEvent ()
{
    NSInteger customSection;
    NSArray *dataForCustomSection;
    NSArray *dataForHeaderSections;

    BOOL hasTopCell;
}
@end

@implementation GCAPPDataEvent

-(void)myInit
{
    hasTopCell = NO;
    customSection = 0;
    dataForCustomSection = nil;
}

-(id) getElementForIndexPath:(NSIndexPath *)indexPath fromData:(id)data
{
    if (data && [data isKindOfClass:[NSDictionary class]])
    {

        NSInteger delta = self.eventsHeaderAttributedString ? 1 : 0;

        id element = [data getXpath:SWF(@"%@[%ld]", self.parsingXpathItem, (long)fmax(indexPath.row - delta, 0)) type:[NSObject class] def:nil];
        
        if (element && [element isKindOfClass:[GCEventModel class]]) {
            if (indexPath.row == 0 && indexPath.section == 0 && self.eventsHeaderAttributedString) {
                return self.eventsHeaderAttributedString;
            } else {
                return element;
            }
        } else {
            if (indexPath.row == 0 && indexPath.section == 0 && self.noInfoAttributedString) {
                return self.noInfoAttributedString;
            }
            
            if (hasTopCell) {
                NSArray *elements = [data getXpathNilArray:SWF(@"%@", self.parsingXpathItem)];
                NSInteger indexInCustomData = indexPath.row - [elements count] - 1;
                id objectData = [dataForCustomSection getXpath:SWF(@"[%ld]", (long)indexInCustomData) type:[NSObject class] def:nil];
                return objectData;
            } else {
                NSArray *elements = [data getXpathNilArray:SWF(@"%@", self.parsingXpathItem)];
                NSInteger indexInCustomData = indexPath.row - [elements count];
                id objectData = [dataForCustomSection getXpath:SWF(@"[%ld]", (long)indexInCustomData) type:[NSObject class] def:nil];
                return objectData;
            }
        }
    }
    return nil;
}

-(NSInteger) getNumberOfRowsInSection:(NSInteger)section forData:(id)data
{
    NSInteger total = 0;
    total += [data getXpathNilArray:self.parsingXpathItem] ? [[data getXpathNilArray:self.parsingXpathItem] count] : 0;

    hasTopCell = self.eventsHeaderAttributedString || (self.noInfoAttributedString && total == 0 && data);
    if (hasTopCell) {
        total++;
    }
    if (dataForCustomSection) {
        total += [dataForCustomSection count];
    }
    return total;
}

-(NSInteger) getNumberOfSectionsForData:(id)data
{
    return 1;
}

-(void)addDataForHeaderSections:(NSArray *)elements
{
    dataForHeaderSections = elements;
}

-(void) addCustomData:(NSArray *)elements inSection:(NSInteger)section
{
    dataForCustomSection = elements;
    customSection = section;
}

@end
