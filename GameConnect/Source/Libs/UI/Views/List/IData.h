//
//  IData.h
//  listNetcoSports
//
//  Created by Benjamin Bouachour on 28/02/11.
//  Copyright 2011 NetcoSports. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IData<NSObject>

-(id)	getElementAtIndex:(NSIndexPath *)indexPath inData:(id)data;
-(NSInteger)	getCountInSection:(NSInteger)section inData:(id)data;


@optional
-(NSInteger)	getNbSectionInData:(id)data;
-(id)	addMoreDataIn:(id)oldData WithNewData:(NSDictionary *)newData;
-(id)   getElementForSection:(NSInteger)section inData:(id)data;
-(NSString*)getTitleForHeader:(NSInteger)section inData:(id)data; // simple

@end
