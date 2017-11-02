    //
//  UIListNetco.m
//  Extends
//
//  Created by bigmac on 04/10/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UIListNetco.h"
#import "UIMasterApplication.h"
#import "NSDataManager.h"

@implementation UIListNetco

@synthesize url;
@synthesize urlMore;
@synthesize paramPOST;
@synthesize flux;
@synthesize linker;
@synthesize data;
@synthesize activeTopReload;
@synthesize isLoading;
@synthesize limit;
@synthesize delegate_list;
@synthesize presentalViewController;
@synthesize navigationViewController;
@synthesize callRequest;
@synthesize callbackRespond;
@synthesize callbackProgress;
@synthesize callbackMore;
@synthesize noInfoView;
@synthesize text_no_info;
@synthesize color_text_no_info;
@synthesize HUD;
@synthesize current_page;
@synthesize colorReload;
@synthesize colorReloadActivity;

#ifndef SHOW_HUD_LOADER_ON_LISTNETCO
#define SHOW_HUD_LOADER_ON_LISTNETCO YES
#endif

-(void)myinit{
	self.delegate = nil;
	self.delegate = self;
	self.dataSource = nil;
	self.dataSource = self;
    _isCache = YES;
    self.scrollsToTop = YES;
	last_totalitem = -1;
	url = nil;
	urlMore = nil;
	flux = nil;
	paramPOST = nil;
    self.autoPostVars = YES;
	linker = nil;
	data = nil;
	activeTopReload = NO;
	isLoading = NO;
	limit = 20;
	delegate_list = nil;
	presentalViewController = nil;
	navigationViewController = nil;
    self.show_HUD = SHOW_HUD_LOADER_ON_LISTNETCO;
    self.manually_more = NO;
    self.alphaActivity = 1.0f;
    self.reload_callback = NO;
	callRequest = nil;
	callbackRespond = nil;
	callbackProgress = nil;
	callbackMore = nil;
	HUD = [MBProgressHUD showHUDAddedTo:self animated:NO];
	[HUD hide:NO];
	HUD.delegate = self;
	hasMore = YES;
	//	__weak MBProgressHUD *HUD2 = HUD;
	__weak UIListNetco *list = self;
	self.callbackRespond = ^(NSDictionary *rep, BOOL cache, NSData *data2, NSInteger httpcode) {
		list.HUD.progress = 1;
		//self.HUD.mode = MBProgressHUDModeDeterminate;
		[list render_reponse:rep cache:cache];
	};
	self.callbackProgress = ^(long long total, long long current) {
		if (current > 0 && total > 0 && total != current){
			list.HUD.mode = MBProgressHUDModeDeterminate;
			list.HUD.progress = current / (float)total;
		}
	};
    
    
	color_text_no_info = [UIColor grayColor];
	text_no_info = NSLocalizedString(@"Aucune information disponible.", @"");
	[self setDefaultCellNoInfo];
}

-(void) setDefaultCellNoInfo{
    float width = self.frame.size.width;
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width / 2) - (width / 2), 0, width, self.frame.size.height)];
    [lb_title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    lb_title.backgroundColor = [UIColor clearColor];
    lb_title.text = text_no_info;
    
    lb_title.font = [UIFont fontWithName:@"Helvetica" size:12];
    lb_title.numberOfLines = 10;
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.textColor = color_text_no_info;
    
//    self.noInfoView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellNo"];
//    [self.noInfoView setSelectionStyle:UITableViewCellSelectionStyleGray];
//    self.noInfoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self.noInfoView addSubview:lb_title];
	
	
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self myinit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		[self myinit];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)dropViewDidBeginRefreshing:(id)sender{
    if ([delegate_list respondsToSelector:@selector(askForReloadSlide:)])
        [delegate_list askForReloadSlide:self];
	[self reload];
}

-(void)setReloadAndMore{
	if (self.activeTopReload && !refreshControl){
		[refreshControl removeObservaterJA];
		refreshControl = [[ODRefreshControl alloc] initInScrollView:self];
		refreshControl.tintColor = colorReload;
        refreshControl.activityIndicatorViewColor = colorReloadActivity;
        refreshControl. alpha = self.alphaActivity;
		[refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
 	}
}

-(void)setForceActiveTopReload:(BOOL)isActive{
    self.activeTopReload = NO;
    
	if (self.activeTopReload && !refreshControl){
		[refreshControl removeObservaterJA];
		refreshControl = [[ODRefreshControl alloc] initInScrollView:self];
		refreshControl.tintColor = colorReload;
        refreshControl.activityIndicatorViewColor = colorReloadActivity;
        refreshControl. alpha = self.alphaActivity;
		[refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
 	}
    else if (!self.activeTopReload && refreshControl){
        [refreshControl endRefreshing];
		[refreshControl removeObservaterJA];
        refreshControl = nil;
    }
}

-(void)delselectRow{
	NSIndexPath *d = [self indexPathForSelectedRow];
	if (d)
		[self deselectRowAtIndexPath:d animated:YES];
}
-(void) StopAndClean{
	[refreshControl removeObservaterJA];
	refreshControl = nil;
	if (_objectOb){
		for(id<UIListNetcoVisiteur> visiteur in _objectOb){
			[visiteur setList:nil];
			[visiteur stop];
		}
		_objectOb = nil;
	}
    _isCache = YES;
	url = nil;
	urlMore = nil;
	flux = nil;
	paramPOST = nil;
	linker = nil;
	data = nil;
	activeTopReload = NO;
	isLoading = NO;
	limit = 20;
	delegate_list = nil;
	presentalViewController = nil;
	navigationViewController = nil;
	callRequest = nil;
	callbackRespond = nil;
	callbackProgress = nil;
	callbackMore = nil;
	noInfoView = nil;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
	if (!newSuperview) {
		[refreshControl removeObservaterJA];
		refreshControl = nil;
	}
}

- (void)dealloc
{
    [self StopAndClean];
	[refreshControl removeObservaterJA];
	refreshControl = nil;
	linker = nil;
	data = nil;
	activeTopReload = NO;
	isLoading = NO;
	limit = 20;
	delegate_list = nil;
	presentalViewController = nil;
	navigationViewController = nil;
	callRequest = nil;
	callbackRespond = nil;
	callbackProgress = nil;
	callbackMore = nil;
    
}
-(void)removenoinfos{
    
    [noInfoView removeFromSuperview];
    [self setSeparatorStyle:style_sep];
}


//UITableView separator are not used by UIListNetco (they are reset in removenoinfos),
//so if you still need to use standard separator use the method below:
- (void)setSeparatorStyleExplicitly:(UITableViewCellSeparatorStyle)separatorStyle
{
    style_sep = separatorStyle;
}

#pragma -
-(void) reload{
	[self reload:YES];
}
-(void) reload:(BOOL)load_pull{
	[self setDefaultCellNoInfo];
	[self setReloadAndMore];
    
	if ([delegate_list respondsToSelector:@selector(getDateFromtable: indexPath: withData:)] && self.TimeScrollerView == nil){
		self.TimeScrollerView =	[[TimeScroller alloc] initWithDelegate:self];
	}
	[self removenoinfos];
    
	// force reload titile view
	self.delegate = nil;
	self.delegate = self;
    
	[HUD hide:YES];
	current_page = 1;
	last_totalitem = -1;
	hasMore = YES;
	askForMore = NO;
	if (callbackMore)
		askForMore = YES;
	if ([delegate_list respondsToSelector:@selector(setUrlMoreDataForListNetco: withNewPage: Limit:)])
		askForMore = YES;
    
	__weak UIListNetco *this = self;
    
	if(url){
//        if (TARGET_IPHONE_SIMULATOR){
//            NSLog(@"UIListNetco : URL => %@", this.url);
//        }
		void (^callback_send)(long long total, long long current) =  ^(long long total, long long current) {
			/*if (current_page > 1)
			 HUD.mode = MBProgressHUDModeDeterminate;*/
		};
		self.callRequest = ^(){
			[NSDataManager request:this.url headers:nil autovarspost:this.autoPostVars post:this.paramPOST cb_send:callback_send cb_rcv:this.callbackProgress cb_rep:this.callbackRespond credential:nil cache:this.isCache];
//			[NSDataManager request:this.url post:this.paramPOST cb_send:callback_send cb_rcv:this.callbackProgress cb_rep:this.callbackRespond credential:nil cache:this.isCache];
		};
	}else if (url == nil && self.callRequest == nil){
		self.callRequest = ^(){
            if (![this.delegate_list respondsToSelector:@selector(askForReloadSlide:)])
                [this render_reponse:this.flux cache:NO];
		};
	}
    
	if(url && [delegate_list respondsToSelector:@selector(setUrlMoreDataForListNetco: withNewPage: Limit:)]){
		void (^callback_send)(long long total, long long current) =  ^(long long total, long long current) {
			if (this.current_page > 1)
				this.HUD.mode = MBProgressHUDModeDeterminate;
		};
		self.callbackMore = ^(int page, int limit){
            if ([this.delegate_list respondsToSelector:@selector(askForShowMore:)])
                [this.delegate_list askForShowMore:this];
			if(this.urlMore){
//                if (TARGET_IPHONE_SIMULATOR){
//                    NSLog(@"UIListNetco : URLMORE => %@", this.urlMore);
//                }
                [NSDataManager request:this.urlMore headers:nil autovarspost:this.autoPostVars post:this.paramPOST cb_send:callback_send cb_rcv:this.callbackProgress cb_rep:this.callbackRespond credential:nil cache:NO];
//				[NSDataManager request:this.urlMore post:this.paramPOST cb_send:callback_send cb_rcv:this.callbackProgress cb_rep:this.callbackRespond credential:nil cache:NO];
            }
			else{
				NSLog(@"=============================ERRRRRRRRRRRRRROR=============================");
			}
            
		};
	}else{
        if ([this.delegate_list respondsToSelector:@selector(askForShowMore:)]){
            self.callbackMore = ^(int page, int limit){
                if ([this.delegate_list respondsToSelector:@selector(askForShowMore:)])
                    [this.delegate_list askForShowMore:this];
            };
        }
    }
    if (self.show_HUD){
        [HUD show:YES];
    }
	isLoading = YES;
	if (load_pull)
		[self showLoading];
	self.callRequest();
}
-(void)showLoading{
	isLoading = YES;
	[refreshControl beginRefreshing];
	[self removenoinfos];
}
-(void)hideLoading{
	isLoading = NO;
	[refreshControl endRefreshing];
    [HUD hide:YES afterDelay:1];
}
-(void)render_reponse:(NSDictionary*)rep cache:(BOOL)cache{
	[self removenoinfos];
	if (cache && current_page > 1)
		return;
	if (!cache){
		[refreshControl endRefreshing];
        if (self.show_HUD){
            [HUD hide:YES];
        }
    }
	isLoading = cache;
	BOOL dataerror = NO;
	if (current_page == 1){
		self.flux = rep;
	}else if (rep != nil){
		HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
		HUD.mode = MBProgressHUDModeCustomView;
		[HUD hide:YES afterDelay:1];
		if ([[rep allKeys] count])
			self.flux = [self.data addMoreDataIn:self.flux WithNewData:rep];
		else{
			// error
			current_page--;
			dataerror = YES;
		}
	}
	
	if ([delegate_list respondsToSelector:@selector(willfinishloading:datas:cache:barButton:)]){
        [delegate_list willfinishloading:self datas:self.flux cache:cache barButton:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)]];
    }
	NSInteger nbs = 1;
	if ([data respondsToSelector:@selector(getNbSectionInData:)]){
		nbs = [self.data getNbSectionInData:self.flux];
	}
	int totalitem = 0;
	for (int i = 0;  i < nbs; i++) {
		totalitem += [self.data getCountInSection:i inData:self.flux];
	}
    if (TARGET_IPHONE_SIMULATOR){
       // NSLog(@"NB DATA IN LIST : %d", totalitem);
    }
	if((rep == nil || totalitem == 0) && self.data){
		if ([delegate_list respondsToSelector:@selector(setNoInfoView:)]){
			UIView *v = [delegate_list setNoInfoView:self];
			self.contentOffset = CGPointMake(0, 0);
			[self addSubviewToBonce:v];
			v.userInteractionEnabled = NO;
			noInfoView = v;
            style_sep = self.separatorStyle;
            [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
		}
	}
	if (!cache){
		hasMore = (last_totalitem != totalitem && totalitem == limit * current_page) || last_totalitem == -1 || dataerror;
		last_totalitem = totalitem;
	}
	[super reloadData];
	if ([delegate_list respondsToSelector:@selector(finishloading:datas:cache:barButton:)]){
        [delegate_list finishloading:self datas:self.flux cache:cache barButton:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)]];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([delegate_list respondsToSelector:@selector(scrollViewDidScroll:)]){
        [delegate_list scrollViewDidScroll:scrollView];
    }
	if (askForMore && hasMore && !self.manually_more && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 30 && !isLoading){
		// call
		isLoading = YES;
		current_page++;
		if ([delegate_list respondsToSelector:@selector(setUrlMoreDataForListNetco: withNewPage: Limit:)])
			self.urlMore = [delegate_list setUrlMoreDataForListNetco:self withNewPage:current_page Limit:self.limit];
		[HUD hide:NO];
        if (self.presentalViewController.view && self.show_HUD)
            HUD = [MBProgressHUD showHUDAddedTo:self.presentalViewController.view animated:YES];
		HUD.mode =  MBProgressHUDModeIndeterminate;
        if (self.show_HUD){
            [HUD show:YES];
        }
		self.callbackMore(current_page,limit);
	}
	[_TimeScrollerView scrollViewDidScroll];
}

-(void) manuallyShowMore
{
    //if (askForMore && hasMore){
		// call
		isLoading = YES;
		current_page++;
		if ([delegate_list respondsToSelector:@selector(setUrlMoreDataForListNetco: withNewPage: Limit:)])
			self.urlMore = [delegate_list setUrlMoreDataForListNetco:self withNewPage:current_page Limit:self.limit];
		[HUD hide:NO];
        if (self.presentalViewController.view && self.show_HUD)
            HUD = [MBProgressHUD showHUDAddedTo:self.presentalViewController.view animated:YES];
		HUD.mode =  MBProgressHUDModeIndeterminate;
        if (self.show_HUD){
            [HUD show:YES];
        }
		self.callbackMore(current_page,limit);
	//}
}

#pragma -
#pragma property

-(void) setLinker:(id<ILinker>) linkerparam{
	linker = linkerparam;
    [self setDelegate_list:delegate_list];
}

-(void) setRender:(Class <ICRender>)render
{
	if (linker == nil){
		linker = [[DefaultCelluleLinker alloc] init];
	}
	if ([linker isKindOfClass:[DefaultCelluleLinker class]]){
		DefaultCelluleLinker *tmp = (DefaultCelluleLinker *)linker;
		[tmp setRender:render];
	}
	[self setDelegate_list:delegate_list];
    
}

-(void) setRenderHeader:(Class <ICRender>)render
{
	if (linker == nil){
		linker = [[DefaultCelluleLinker alloc] init];
	}
	if ([linker isKindOfClass:[DefaultCelluleLinker class]]){
		DefaultCelluleLinker *tmp = (DefaultCelluleLinker *)linker;
		[tmp setRenderHeader:render];
	}
	[self setDelegate_list:delegate_list];
    
}
-(void)setDefaultLinker{
	self.linker = [[DefaultCelluleLinker alloc] init];
}
-(void) setIAff:(Class <IAffItem>)item bundle:(NSString*)bundle
{
	if (linker == nil)
		linker = [[DefaultCelluleLinker alloc] init];
    
	if ([linker isKindOfClass:[DefaultCelluleLinker class]]){
		DefaultCelluleLinker *tmp = (DefaultCelluleLinker *)linker;
		[tmp setIAff:item bundle:bundle];
	}
    [self setDelegate_list:delegate_list];
}

-(void) setData:(id <IData>)dataparam{
	data = dataparam;
    [self setDelegate_list:delegate_list];
    self.delegate = nil;
	self.delegate = self;
}

-(void)setDataRenderSimple:(NSString*)xpath{
	UIDefaultRenderSimple *d = [[UIDefaultRenderSimple alloc] init];
	d.xpath = xpath;
	[self setData:d];
}


#pragma Tablelist
-(void)reloadData{
	[super reloadData];
    if (self.reload_callback)
    {
        if ([delegate_list respondsToSelector:@selector(finishloading:datas:cache:barButton:)]){
            [delegate_list finishloading:self datas:self.flux cache:NO barButton:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)]];
        }
    }
}


// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if ([delegate_list respondsToSelector:@selector(sectionIndexTitlesForTableView:)]){
        return [delegate_list performSelector:@selector(sectionIndexTitlesForTableView:) withObject:tableView];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if ([delegate_list respondsToSelector:@selector(tableView: sectionForSectionIndexTitleDic:)]){
        return (NSInteger)[delegate_list performSelector:@selector(tableView: sectionForSectionIndexTitleDic:) withObject:tableView withObject:@{@"title":title, @"index":[NSNumber numberWithInteger:index]}];
    }
    return 0;
}


#pragma mark Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([delegate_list respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
       return [delegate_list tableView:tableView   canEditRowAtIndexPath:indexPath];
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([delegate_list respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        [delegate_list tableView:tableView   commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([delegate_list respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
        return [delegate_list tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([delegate_list respondsToSelector:@selector(tableView: shouldIndentWhileEditingRowAtIndexPath:)])
        return [delegate_list tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (last_totalitem == 0)
        return 1;
	if (data != nil && [data respondsToSelector:@selector(getNbSectionInData:)] ){
        return [data getNbSectionInData:flux];
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 	if (data != nil && [data respondsToSelector:@selector(getCountInSection:inData:)])
		return [data getCountInSection:section inData:flux];
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	//	iscreatecell = YES;
	if ([delegate_list respondsToSelector:@selector(tableView: cellForRowAtIndexPath: withData:)]){
		[delegate_list tableView:self cellForRowAtIndexPath:indexPath withData:[data getElementAtIndex:indexPath inData:flux]];
	}
    
//	if (last_totalitem == 0){
//        return nil;
//    }
    
	id dataElement = [data getElementAtIndex:indexPath inData:flux];
    
    
	UITableViewCell *c = [linker getCellForIndexPath:indexPath andData:dataElement inTableView:self parentViewController:presentalViewController];
	if ([[c class]  respondsToSelector:@selector(getIdentifierCell)]){
		assert([c.reuseIdentifier isEqualToString:[[c class] performSelector:@selector(getIdentifierCell)]]);
	}else
		assert(false);
    
	assert(!!c);
    return c;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id dataElement = [data getElementAtIndex:indexPath inData:flux];
    Class<ICRender> r = [linker getICRenderForIndexPath:indexPath  elt:dataElement];
    CGFloat h = [r getHeightCellforData:dataElement indexPath:indexPath table:self];
	// NSLog(@"list => index : %d => %f height", indexPath.row , h);
	return h;
}




// Header View

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if ([data respondsToSelector:@selector(getTitleForHeader: inData:)]){
		return 30;
	}
    if (![data respondsToSelector:@selector(getElementForSection: inData:)]){
        return 0;
    }
    CGFloat h = 0;
    id dataElement = [data getElementForSection:section inData:flux];
    Class<ICRender> l = [linker getICRenderForSection:section  elt:dataElement];
    if (!l)
        return 0;
	if ([(NSObject *)l respondsToSelector:@selector(getHeaderViewForSection: withData:)] || [(NSObject *)l respondsToSelector:@selector(getHeaderViewForSection: withData: tableView: parentViewController:)]){
        h = [l getHeightHeaderforData:dataElement indexPath:section table:self];
    }
	//    NSLog(@"list => section : %d => %f height", section , h);
	return h;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if ([data respondsToSelector:@selector(getTitleForHeader: inData:)]){
		return [data getTitleForHeader:section inData:flux];
	}
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!([data respondsToSelector:@selector(getElementForSection: inData:)] /*|| [data respondsToSelector:@selector(getElementForSection: inData: tableView: parentViewController:)]*/)){
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        vv.backgroundColor = [UIColor clearColor];
        return vv;
    }
    id dataElement = [data getElementForSection:section inData:flux];
    
    Class<ICRender> l = [linker getICRenderForSection:section  elt:dataElement];
    
    
	if ([(NSObject *)l respondsToSelector:@selector(getHeaderViewForSection: withData: tableView: parentViewController:)]){ // New One !
		return [l getHeaderViewForSection:section withData:dataElement tableView:tableView parentViewController:presentalViewController];
	}
	if ([(NSObject *)l respondsToSelector:@selector(getHeaderViewForSection: withData:)]){ // !! Deprecated
		return [l getHeaderViewForSection:section withData:dataElement];
	}
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    vv.backgroundColor = [UIColor clearColor];
	return vv;
}




// Footer View

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	/*if ([data respondsToSelector:@selector(getTitleForFooter: inData:)]){
		return 30;
	}*/
    if (![data respondsToSelector:@selector(getElementForSection: inData:)]){
        return 0;
    }
    CGFloat h = 0;
    id dataElement = [data getElementForSection:section inData:flux];
    Class<ICRender> l = [linker getICRenderForSection:section  elt:dataElement];
    
	if ([(NSObject *)l respondsToSelector:@selector(getFooterViewForSection: withData: tableView: parentViewController:)]){
        h = [l getHeightFooterforData:dataElement indexPath:section table:self];
    }
	//    NSLog(@"list => section : %d => %f height", section , h);
	return h;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!([data respondsToSelector:@selector(getElementForSection: inData:)] /*|| [data respondsToSelector:@selector(getElementForSection: inData: tableView: parentViewController:)]*/)){
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        vv.backgroundColor = [UIColor clearColor];
        return vv;
    }
    id dataElement = [data getElementForSection:section inData:flux];
    
    Class<ICRender> l = [linker getICRenderForSection:section  elt:dataElement];
    
    
	if ([(NSObject *)l respondsToSelector:@selector(getFooterViewForSection: withData: tableView: parentViewController:)]){
		return [l getFooterViewForSection:section withData:dataElement tableView:tableView parentViewController:presentalViewController];
	}
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    vv.backgroundColor = [UIColor clearColor];
	return vv;
}



-(BOOL)respondsToSelector:(SEL)aSelector{
	if (aSelector == @selector(tableView: viewForHeaderInSection:)){
		if ([data respondsToSelector:@selector(getTitleForHeader: inData:)] || !data)
			return NO;
	}
	return [super respondsToSelector:aSelector];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([delegate_list respondsToSelector:@selector(tableView: didDeselectRowAtIndexPath: withData:)]){
		[delegate_list tableView:self didDeselectRowAtIndexPath:indexPath withData:[self.data getElementAtIndex:indexPath inData:self.flux]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([delegate_list respondsToSelector:@selector(tableView: didSelectRowAtIndexPath: withData:)]){
		[delegate_list tableView:self didSelectRowAtIndexPath:indexPath withData:[self.data getElementAtIndex:indexPath inData:self.flux]];
	}
    
    
    
    if ([self.linker respondsToSelector:@selector(isIAffForIndexPath:)] && ![self.linker isIAffForIndexPath:indexPath]){
		//        [self deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    // Permet à l'utilisateur si il préfère faire un presentModalView ou un pushView
	if (self.data != nil && [self.linker respondsToSelector:@selector(showAffItem: indexPath: list: navigationController:)])
		[self.linker showAffItem:[self.data getElementAtIndex:indexPath inData:self.flux] indexPath:indexPath list:self.flux navigationController:self.navigationViewController];
	else if (self.data != nil)
	{
		// pushView
        
		/*UIViewController<IAffItem> *aff = [[_linker getIAffForIndexPath:indexPath] retain];
         if ([aff respondsToSelector:@selector(setItem:indexPath:list:)])
         [aff setItem:[_data getElementAtIndex:indexPath inData:_flux] indexPath:indexPath list:_flux];
         [navigation pushViewController:aff animated:YES];
         [aff release];*/
        if ([self.linker respondsToSelector:@selector(showAffItem:indexPath:list:navigationController:)])
            [self.linker showAffItem:[self.data getElementAtIndex:indexPath inData:self.flux] indexPath:indexPath list:self.flux navigationController:self.navigationViewController];
	}
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([delegate_list respondsToSelector:@selector(tableView: canMoveRowAtIndexPath:)]){
		return [delegate_list tableView:self canMoveRowAtIndexPath:indexPath];
	}
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
	if ([delegate_list respondsToSelector:@selector(tableView: moveRowAtIndexPath: toIndexPath:)]){
		[delegate_list tableView:self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
	if ([delegate_list respondsToSelector:@selector(tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath:)]){
		return [delegate_list tableView:self targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
	}
    return proposedDestinationIndexPath;
}



#pragma TimeScroll

- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    return self;
}


//The date for a given cell
- (NSDate *)dateForCell:(UITableViewCell *)cell {
	if ([delegate_list respondsToSelector:@selector(getDateFromtable: indexPath: withData:)]){
		NSIndexPath *indexPath = [self indexPathForCell:cell];
		id d = [self.data getElementAtIndex:indexPath inData:self.flux];
		NSDate *date = [delegate_list getDateFromtable:self indexPath:indexPath withData:d];
		return date;
	}
	return nil;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[_TimeScrollerView scrollViewDidEndDecelerating];
    if ([delegate_list respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
        [delegate_list scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[_TimeScrollerView scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		[_TimeScrollerView scrollViewDidEndDecelerating];
	}
}
-(void)PostItems:(NSString*)key data:(id)datae{
    NSArray *i = [self visibleCells];
    for (UITableViewCell *c  in i) {
        if ([c respondsToSelector:@selector(reciverPost: data:)]){
			id <ICRender>cc = (id<ICRender>)c;
			[cc reciverPost:key data:datae];
        }
    }
}

#pragma observateur
-(void)addObject:(id<UIListNetcoVisiteur>)obj{
	if (!_objectOb)
		_objectOb = [[NSMutableArray alloc] init];
	[_objectOb addObject:obj];
	[obj setList:self];
	[obj run];
}

-(BOOL)removeMyObservaterur:(id<UIListNetcoVisiteur>)obj{
	if (obj){
		[obj stop];
		[_objectOb removeObject:obj];
        return TRUE;
	}
    return FALSE;
}


#pragma  autorefresh

-(void)setAutoRefresh:(BOOL)ok interval:(NSTimeInterval)interval{
    
	__block BOOL vue = FALSE;
	__block id<UIListNetcoVisiteur> obj = nil;
	[_objectOb each:^(NSInteger index, id elt, BOOL last) {
		if ([elt isKindOfClass:[UIListNetcoVisiteurTimer class]]){
			vue = TRUE;
			obj = elt;
		}
	}];
	if (interval == 0 || !ok){
		(!!obj) && [self removeMyObservaterur:obj];
		vue = YES;
	}
	if (vue)
		return;
	UIListNetcoVisiteurTimer *t =  [[UIListNetcoVisiteurTimer alloc] init] ;
	t.timer_time = interval;
	[self addObject:t];
}

-(void)setColorReload:(UIColor *)colorReloadobj{
	refreshControl.tintColor = colorReloadobj;
	colorReload = colorReloadobj;
}

-(void)setColorReloadActivity:(UIColor *)colorReloadobj{
    refreshControl.activityIndicatorViewColor = colorReloadobj;
	colorReloadActivity = colorReloadobj;
}


#pragma setPostParam

-(void)setParamPOST:(NSDictionary *)dicPOST withAutoVars:(BOOL)autoVars{
    self.paramPOST = [dicPOST ToMutable];
    self.autoPostVars = autoVars;
}


@end



@implementation UIDefaultRenderSimple
@synthesize xpath;

-(id)	getElementAtIndex:(NSIndexPath *)indexPath inData:(id)data{
    
    return [data getXpath:[NSString stringWithFormat:@"%@[%ld]"
						   ,xpath
						   ,(long)indexPath.row] type:[NSObject class] def:nil];
    
}
-(NSInteger)	getCountInSection:(NSInteger)section inData:(id)data{
	//NSLog(@"nb ret :> %d",[[data getXpathNilArray:xpath] count]);
	return [[data getXpathNilArray:xpath] count];
}

-(id)	addMoreDataIn:(id)oldData WithNewData:(NSDictionary *)newData{
	NSArray *a =  [oldData getXpathNilArray:xpath];
	a = [a arrayByAddingObjectsFromArray:[newData getXpathNilArray:xpath]];
	NSMutableDictionary *d = [newData ToMutable];
    if (a)
		[d setObject:a forKey:[xpath strReplace:@"/" to:@""]];
	return d;
}
-(id)   getElementForSection:(NSInteger)section inData:(id)data{
	if ([self getCountInSection:section inData:data])
		return [self getElementAtIndex:[NSIndexPath indexPathForRow:0 inSection:section] inData:data];
	return nil;
}

@end


@implementation DefaultCelluleLinker

-(id) init
{
	if (!(self = [super init]))
		return nil;
	_aff = nil;
	_render = nil;
	return self;
}



-(void) setIAff:(Class <IAffItem>)item bundle:(NSString*)bundle{
	_aff = item;
	_bundle = bundle;
}


-(Class<ICRender>) getICRenderForIndexPath:(NSIndexPath *)indexPath  elt:(id)elt
{
	if (_renderHeader && indexPath.row == 0 && indexPath.section == 0)
		return _renderHeader;
	return _render;
}

-(UITableViewCell *) getCellForIndexPath:(NSIndexPath *)indexPath andData:(id)dataElement inTableView:(UITableView *)tableView parentViewController:(UIViewController*)parentViewController;
{
	Class<ICRender> render = [self getICRenderForIndexPath:indexPath elt:dataElement];
	NSString *CellIdentifier = [render getIdentifierCell];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	return ([render getCell:cell forData:dataElement indexPath:indexPath tableView:tableView parentViewController:parentViewController]);
}
-(BOOL) isIAffForIndexPath:(NSIndexPath *)indexPath{
	return !!_bundle;
}

-(void) showAffItem:(id)element indexPath:(NSIndexPath *)indexPath list:(id)list navigationController:(UINavigationController *)navigation
{
	id<IAffItem> a = [[_aff  alloc] initWithNibName:_bundle bundle:nil];
    
	[a setItem:element indexPath:indexPath list:list];
	if ([a isKindOfClass:[UIViewController class]])
		[navigation pushViewController:(UIViewController *)a animated:YES];
}

-(void) dealloc{
	_bundle = nil;
}

-(Class<ICRender>) getICRenderForSection:(NSInteger)section  elt:(id)elt{
	return _render;
}



@end

@implementation UIListNetcoVisiteurTimer
@synthesize timer_time;

-(void)stop{
	[timer invalidate];
	timer = nil;
}
-(void)setList:(UIListNetco*)list{
	tb_list = list;
}
-(void)run{
	[timer invalidate];
	timer = nil;
    if (timer_time > 0)
        timer = [NSTimer scheduledTimerWithTimeInterval:timer_time target:self selector:@selector(reponse:) userInfo:nil repeats:YES] ;
}
-(void)reponse:(id)paramName{
	if (!tb_list.isLoading && tb_list.window){
		[tb_list reload:NO];
		NSLog(@"list reload");
	}else {
		NSLog(@"list not reload");
	}
    
    
}
- (void)dealloc{
	tb_list = nil;
	[timer invalidate];
	timer = nil;
}

@end

