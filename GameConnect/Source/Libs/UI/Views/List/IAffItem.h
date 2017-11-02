//
//  IAffItem.h
//  listNetcoSports
//
//  Created by Benjamin Bouachour on 28/02/11.
//  Copyright 2011 NetcoSports. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IAffItem <NSObject>

-(void)setItem:(id)element indexPath:(NSIndexPath *)indexPath list:(id)list;
@optional
+(id)alloc; // never rewirte

@end
