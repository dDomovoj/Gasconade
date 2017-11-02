//
//  UIListNetco.h
//  Extends
//
//  Created by bigmac on 04/10/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Extends+Libs.h"
#import "ILinker.h"
#import "IData.h"
#import "IAffItem.h"
#import "ICRender.h"
#import "MBProgressHUD.h"
#import "ODRefreshControl.h"
#import "TimeScroller.h"

@class UIListNetco ;
@protocol UIListNetcoVisiteur;

@protocol UIListNetcoDelegate <NSObject>

@optional

- (void)tableView:(UIListNetco *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;
- (void)tableView:(UIListNetco *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;
- (void)tableView:(UIListNetco *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;


- (void)willfinishloading:(UIListNetco *)tableView datas:(NSDictionary*)datas cache:(BOOL)cache barButton:(UIBarButtonItem*)barButton; // call after recived data
- (void)finishloading:(UIListNetco *)tableView datas:(NSDictionary*)datas cache:(BOOL)cache barButton:(UIBarButtonItem*)barButton; // call after render data an process, don't modify data

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *) setUrlMoreDataForListNetco:(UIListNetco *)listNetco withNewPage:(int)newPage Limit:(int)Limit;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

-(void)askForReloadSlide:(UIListNetco *)listNetco;
-(void)askForShowMore:(UIListNetco *)listNetco;

-(NSDate*)getDateFromtable:(UIListNetco*)listNetco indexPath:(NSIndexPath*)indexPath withData:(id)data;


-(UIView *) setNoInfoView:(UIListNetco *)listNetco;

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitleDic:(NSDictionary *)titleIndexDic;


@end




@interface UIListNetco : UITableView<TimeScrollerDelegate,MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
	int current_page;
	int last_totalitem;
	BOOL hasMore;
	BOOL askForMore;
	ODRefreshControl *refreshControl;
	NSMutableArray *_objectOb; // observateur
	UITableViewCellSeparatorStyle style_sep;
}
@property (nonatomic,strong) UIView *noInfoView;

@property (nonatomic) BOOL isCache;

@property (nonatomic,strong) UIColor *colorReload;
@property (nonatomic,strong) UIColor *colorReloadActivity;
@property (nonatomic) CGFloat alphaActivity;

@property (nonatomic, strong)  TimeScroller *TimeScrollerView;
@property (assign) int current_page;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSString *text_no_info;
@property (nonatomic, strong) UIColor *color_text_no_info;
@property (nonatomic) BOOL show_HUD;
@property (nonatomic) BOOL manually_more;
@property (nonatomic) BOOL reload_callback;

//@property (nonatomic, strong) IBOutlet UITableViewCell *noInfoView;

@property (nonatomic,copy) void(^callRequest) ();
@property (nonatomic,copy) void(^callbackProgress) (long long total , long long current);
@property (nonatomic,copy) void(^callbackRespond) (NSDictionary*rep, BOOL cache, NSData* data, NSInteger httpcode);
@property (nonatomic,copy) void(^callbackMore) (int page, int limit);


-(void)render_reponse:(NSDictionary*)rep cache:(BOOL)cache;


@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *urlMore;

@property (nonatomic) BOOL autoPostVars;
@property (nonatomic, strong) NSMutableDictionary *paramPOST;
@property (nonatomic, strong) NSDictionary *flux;

@property (nonatomic, strong) id<ILinker> linker;
@property (nonatomic, strong) id<IData> data;


@property (nonatomic, assign) BOOL activeTopReload;
@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, assign) int limit;


@property (weak) IBOutlet NSObject<UIListNetcoDelegate> *delegate_list;
@property (weak) IBOutlet UIViewController *presentalViewController;
@property (weak) IBOutlet UINavigationController *navigationViewController;




-(void)setLinker:(id<ILinker>)linker;
-(void)setDefaultLinker;
-(void)setRender:(Class<ICRender>)render;
-(void)setRenderHeader:(Class<ICRender>)render;
-(void)setData:(id<IData>)data;
-(void)setDataRenderSimple:(NSString*)xpath;

-(void) setIAff:(Class <IAffItem>)item bundle:(NSString*)bundle;
-(void) reload;
-(void) StopAndClean;
-(void) delselectRow;
-(void) manuallyShowMore;
-(void)removenoinfos;

// Override

-(void)reloadData;



// loading
-(void)showLoading;
-(void)hideLoading;


-(void)PostItems:(NSString*)key data:(id)data;
// cafe
//-(void)seManager:

-(void)setForceActiveTopReload:(BOOL)isActive;

// observateur
-(void)addObject:(id<UIListNetcoVisiteur>)obj;
-(BOOL)removeMyObservaterur:(id<UIListNetcoVisiteur>)obj;

// Auto-Refresh
-(void)setAutoRefresh:(BOOL)ok interval:(NSTimeInterval)interval;

// Add POST parameters
-(void)setParamPOST:(NSDictionary *)dicPOST withAutoVars:(BOOL)autoVars;

//UITableView separator are not used by UIListNetco (they are reset in removenoinfos),
//so if you still need to use standard separator use the method below:
- (void)setSeparatorStyleExplicitly:(UITableViewCellSeparatorStyle)separatorStyle;


@end


@interface UIDefaultRenderSimple:NSObject <IData>
@property(nonatomic,strong) NSString* xpath;
@end

@interface DefaultCelluleLinker : NSObject <ILinker> {
	Class<IAffItem>	_aff;
	NSString *_bundle;
}
@property (strong, nonatomic) Class<ICRender> renderHeader;
@property (strong, nonatomic) Class<ICRender> render;
-(void) setIAff:(Class <IAffItem>)item bundle:(NSString*)bundle;

@end




@protocol UIListNetcoVisiteur
-(void)stop;
-(void)setList:(UIListNetco*)list;
-(void)run;
@end

@interface UIListNetcoVisiteurTimer : NSObject<UIListNetcoVisiteur>{
	__weak UIListNetco *tb_list;
	NSTimer *timer;
	
}
@property (nonatomic,assign) NSTimeInterval timer_time;
@end

