//
//  ICRender.h
//  listNetcoSports
//
//  Created by Benjamin Bouachour on 28/02/11.
//  Copyright 2011 NetcoSports. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ICRender <NSObject>

+(UITableViewCell *) getCell:(UITableViewCell *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath tableView:(UITableView *)tableView parentViewController:(UIViewController*)parentViewController;
+(NSString *) getIdentifierCell;
+(CGFloat) getHeightCellforData:(id)elt indexPath:(NSIndexPath*)indexPath table:(UITableView*)tb;


@optional

// Header section
+(CGFloat) getHeightHeaderforData:(id)elt indexPath:(NSInteger)section table:(UITableView*)tb;

+(NSString *) getHeaderForSection:(NSInteger)section withData:(id)data; // simple string

+(UIView *) getHeaderViewForSection:(NSInteger)section withData:(id)data; // !! Deprecated
+(UIView *) getHeaderViewForSection:(NSInteger)section withData:(id)data tableView:(UITableView *)tableView parentViewController:(UIViewController *)parentViewController; // New one !

// Footer section
+(CGFloat) getHeightFooterforData:(id)elt indexPath:(NSInteger)section table:(UITableView*)tb;
+(UIView *) getFooterViewForSection:(NSInteger)section withData:(id)data tableView:(UITableView *)tableView parentViewController:(UIViewController *)parentViewController;


-(void)removeReference;
-(void)reciverPost:(NSString*)key data:(id)data;


+ (BOOL)instancesRespondToSelector:(SEL)aSelector; // never Overwirte
+ (BOOL)resolveClassMethod:(SEL)sel;///// never Overwirte

@end