//
//  ILinker.h
//  listNetcoSports
//
//  Created by Benjamin Bouachour on 28/02/11.
//  Copyright 2011 NetcoSports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICRender.h"
#import "IAffItem.h"

@protocol ILinker <NSObject>

-(Class<ICRender>) getICRenderForIndexPath:(NSIndexPath *)indexPath  elt:(id)elt;

-(UITableViewCell *) getCellForIndexPath:(NSIndexPath *)indexPath andData:(id)dataElement inTableView:(UITableView *)tableView parentViewController:(UIViewController*)parentViewController;

-(BOOL) isIAffForIndexPath:(NSIndexPath *)indexPath;


@optional


-(void) showAffItem:(id)element indexPath:(NSIndexPath *)indexPath list:(id)list navigationController:(UINavigationController *)navigation;

-(Class<ICRender>) getICRenderForSection:(NSInteger)section  elt:(id)elt;


@end
