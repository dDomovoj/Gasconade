//
//  ViewSlide.h
//  traceSport
//
//  Created by bigmac on 16/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIItemViewSlide.h"
@class ViewSlide;


@protocol ViewSlideDelegate <NSObject>
@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@required
-(NSInteger)getNbItem:(ViewSlide*)vs;
-(UIView*) getViewForIndex:(ViewSlide*)vs index:(NSInteger)index reuse:(UIView*)reuse;
-(void)touchItem:(ViewSlide*)vs index:(NSInteger)index;
-(CGFloat)getWidthForItem:(ViewSlide*)vs index:(NSInteger)index;
-(CGFloat)getHeightForItem:(ViewSlide*)vs index:(NSInteger)index;

@end


@interface ViewSlide : UIScrollView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIItemViewSlideDelegate> {
    NSMutableArray *reuse;
	__weak id<ViewSlideDelegate> my_delegate;
	UITableView *tb;
	int select_index;
}
@property (nonatomic, weak) IBOutlet id<ViewSlideDelegate> my_delegate;

-(void)	willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
-(void)	reloadList;
-(void) clearList;
-(int)	visibleindex;
-(void)	setSelected:(int) selected;
-(UIView*)getVisibleView;
@end
