//
//  ViewSlide.m
//  traceSport
//
//  Created by bigmac on 16/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewSlide.h"
#import "UITableViewCellSlide.h"
#import "Extends+Libs.h"

@implementation ViewSlide

@synthesize my_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
}

-(void)pushItemInSC:(UIView*)item content:(UIItemViewSlide*)content
{
    item.hidden = NO;
	CGRect f =  item.frame;
	f.origin.x = f.origin.y = 0;
	
	[content addMySubview:item];
	
	item.frame = f;
	content.view = item;
}

-(int)visibleindex{
	return floor((self.contentOffset.x+self.frame.size.width/2)/self.frame.size.width);
}
-(void)	setSelected:(int) selected{
	select_index = selected;
	[self setContentOffset:CGPointMake(select_index*self.frame.size.width, 0)];
}
-(void)reloadList{
//    [[self subviews] each:^(int index, id elt) {
//        [elt removeFromSuperview];
//    }];
	[self clearSubview];
    tb.delegate = nil;
    tb.dataSource  = nil;
    tb = nil;
	NSInteger nbelt = [my_delegate getNbItem:self];
	CGFloat aw = 0;
	CGFloat ah = 0;
	for (int i = 0; i<nbelt; i++) {
		CGFloat w = [my_delegate getWidthForItem:self index:i];
		CGFloat h = [my_delegate getHeightForItem:self index:i];
		//int x = aw;
		aw += w;
		ah = h;
		//UIItemViewSlide *e = [[[UIItemViewSlide alloc] initWithFrame:CGRectMake(x, 0, w, h)] autorelease];
		//e.backgroundColor = [UIColor purpleColor];
		//e.pos = i;
		//e.delegate = self;
		//		[e setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
		//[self addSubview:e];
	}
	
	if (!tb){
		CGRect r  = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
		tb = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
	}
	tb.delegate = self;
	tb.dataSource = self;
	
	
	self.delegate = self;
	[self setContentSize:CGSizeMake(aw, ah)];
	[self scrollViewDidScroll:self];
	
	[self setContentOffset:CGPointMake(select_index*self.frame.size.width, 0) animated:NO];
	[tb reloadData];
	tb.hidden = YES;
	[self addSubview:tb];
}

-(void)draw_me:(UIItemViewSlide*)e{
	//[self pushItemInSC:[my_delegate getViewForIndex:self index:e.pos] content:e];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[tb setContentOffset:CGPointMake(0,  self.contentOffset.x)];
	if ([my_delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
		[my_delegate scrollViewDidScroll:self];
	}
	//[tb scrollRectToVisible:CGRectMake(0, self.contentOffset.x, self.frame.size.height, self.frame.size.width) animated:YES];
	return;
	
}

-(void)click:(id)sender{
	if([my_delegate respondsToSelector:@selector(touchItem: index:)]){
		UIItemViewSlide *e = sender;
		[my_delegate touchItem:self index:e.pos];
	}
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return  [my_delegate getNbItem:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellSlide *cell = (UITableViewCellSlide*)[tableView dequeueReusableCellWithIdentifier:@"moi"];
	if (!cell){
		CGFloat w = [my_delegate getWidthForItem:self index:indexPath.row];
		CGFloat h = [my_delegate getHeightForItem:self index:indexPath.row];
		cell = [[UITableViewCellSlide alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"moi"];
		//NSLog(@"cell view  %@",cell.reuseIdentifier);
		cell.frame = CGRectMake(w*indexPath.row, 0, h, w);
		UIItemViewSlide *e = [[UIItemViewSlide alloc] initWithFrame:CGRectMake(w*indexPath.row, 0, w, h)];
		e.backgroundColor = [UIColor clearColor];
		e.pos = indexPath.row;
		e.delegate = self;
		//		[e setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
		[self addSubview:e];
		cell.t = e;
	}else{
		CGFloat w = [my_delegate getWidthForItem:self index:indexPath.row];
		CGFloat h = [my_delegate getHeightForItem:self index:indexPath.row];
		UIItemViewSlide *eee = cell.t;
		eee.frame = CGRectMake(w*indexPath.row, 0, w, h);
		eee.pos = indexPath.row;
		
	}
	
	
	// call delegate
	UIItemViewSlide *eee = cell.t;
	UIView *reusse = eee.view;
	
	if(self.frame.size.height  != self.contentSize.height){
		NSInteger nbelt = [my_delegate getNbItem:self];
		CGFloat aw = 0;
		CGFloat ah = 0;
		for (int i = 0; i<nbelt; i++) {
			CGFloat w = [my_delegate getWidthForItem:self index:i];
			CGFloat h = [my_delegate getHeightForItem:self index:i];
			
			aw += w;
			ah = h;
		}
		
		
		CGRect rr  = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
		tb.frame = rr;
		
		[self setContentSize:CGSizeMake(aw, ah)];
	}
	UIView *vv = [my_delegate getViewForIndex:self index:indexPath.row reuse:reusse];
	
	vv.frame = CGRectMake(0, 0, [my_delegate getWidthForItem:self index:indexPath.row], [my_delegate getHeightForItem:self index:indexPath.row]);
	//reusse.frame = vv.frame;
	
	CGRect r = eee.frame;
	r.size = vv.frame.size;
	eee.frame = r;
	[self pushItemInSC:vv content:cell.t];
	
	
	return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat w = [my_delegate getWidthForItem:self index:indexPath.row];
	return w;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if([my_delegate respondsToSelector:@selector(scrollViewDidEndDragging: willDecelerate:)]){
		[my_delegate scrollViewDidEndDragging:self willDecelerate:decelerate];
	}
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	if([my_delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]){
		[my_delegate scrollViewDidEndScrollingAnimation:self];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if([my_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
		[my_delegate scrollViewDidEndDecelerating:self];
	}
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[self reloadList];
}

-(void) clearList
{
	//    NSArray *ar = [self subviews];
	//    for (UIItemViewSlide *item in ar)
	//    {
	//        if ([item isKindOfClass:[UIItemViewSlide class]])
	//            [item setHidden:YES];
	//    }
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

-(UIView*)getVisibleView{
	UITableViewCellSlide *cell = (UITableViewCellSlide*)[tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self visibleindex] inSection:0]];
	return cell.t.view;
}

@end
