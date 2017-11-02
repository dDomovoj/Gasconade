//
//  UIImageViewJA.m
//  Extends
//
//  Created by bigmac on 04/10/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UIImageViewJA.h"
#import "UIMasterApplication.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import "NSObject+NSObject_File.h"
#import "NSObject+NSObject_Xpath.h"
#import "NSObject+NSObject_Tool.h"
#import "NSString+NSString_File.h"
#import "NSString+NSString_Tool.h"
#import "UIDevice+UIDevice_Tool.h"


static NSMutableDictionary *pool_img = nil;


@interface UIImageViewJA (Private)
+(NSInteger) dateModifiedSort:(NSString *) file1 ttl:(unsigned)ttl;
-(void)runDL:(NSString*)localurl dist:(NSString*)disturl local_file:(NSString*)local_file;
-(void)runCallBack;
-(void)clearPool;
@end


@implementation NSDLClassJA


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	_total = [response expectedContentLength];
	recived = 0;
	if ([_delegate respondsToSelector:@selector(recivingdata:totalbytes:)])
		[_delegate recivingdata:recived totalbytes:_total];
}



//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] init]; }
	[data appendData:incrementalData];
	recived = [data length];
	[NSObject mainThreadBlock:^{
		if ([_delegate respondsToSelector:@selector(recivingdata:totalbytes:)]){
			[_delegate recivingdata:recived totalbytes:_total];
		}
	}];
}

- (void)connection:(NSURLConnection *)c didFailWithError:(NSError *)error{
	data = nil;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[connection cancel];
	connection=nil;
	if(self.delegate_image){
        [NSObject mainThreadBlock:^{
            NSLog(@"%@",[error debugDescription]);
            if (_callback)
                _callback(data);
            else
                NSLog(@"clean callabck");
        }];
    }
	data=nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[connection cancel];
 	connection=nil;
    if(self.delegate_image){
        [NSObject mainThreadBlock:^{
            if (_callback){
                //NSLog(@"CALL BACK %@",dist_url);
                _callback(data);
            }else
                NSLog(@"clean callabck");
        }];
    }
	data=nil;
}



-(void)runDL:(NSString*)localurl dist:(NSString*)disturl{
	[connection cancel];
	connection = nil;
	
    data = nil;
    dist_url = disturl;
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:disturl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:90.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
}
-(void)cancel{
    _callback = nil;
    data = nil;
    _delegate = nil;
    
    [connection cancel];
	connection = nil;
}

@end


@implementation NSIOCheckImage


#pragma mark Load from DISK OR DL
-(void)run:(NSString*)url locf:(NSString*)locf ttl:(int)ttl{
    [NSObject backGroundBlock:^{
		NSFileManager *FileManager = [NSFileManager defaultManager];
		BOOL file_existe = [FileManager fileExistsAtPath:locf];
		if (file_existe && ttl){
			[UIImageViewJA dateModifiedSort:locf ttl:ttl];
			file_existe = [FileManager fileExistsAtPath:locf];
			if(file_existe){
                [self loadcontentfile:locf];
				return;
			}
		}
		[NSObject mainThreadBlock:^{
			[_delegate runDL:locf dist:url local_file:locf];
		}];
	}];
}
-(void)loadcontentfile:(NSString*)lf{
	NSData *d = [NSData dataWithContentsOfFile:lf];
	if (!d || ![d length]){
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:lf error:NULL];
        [_delegate setupimage:nil];
		return;
	}
	if (!_delegate)
        return ;
	
    UIImage *i =  [UIImage imageWithData:d];
	
	
	if (!i){
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:lf error:NULL];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[_delegate runCallBack];
		});
	}
	
	dispatch_sync(dispatch_get_main_queue(), ^{
        [pool_img setValue:i forKey:lf];
        [_delegate clearPool];
		[_delegate setupimage:i];
	});
	return;
}


@end



@implementation UIImageViewJA



@synthesize dist_url,my_UIViewContentModeScaleAspectFit,my_responder;

-(void)myinit{
	_clear_image = YES;
    def_placeHolder = nil;
}

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self myinit];
    }
    return self;
}

-(id)initWithImage:(UIImage *)image{
	self = [super initWithImage:image];
    if (self) {
        // Initialization code
		[self myinit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		[self myinit];
    }
    return self;
}


-(UIImage *)placeHolder{
    return def_placeHolder;
}
-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl withPlaceholder:(UIImage *)pholder{
    def_placeHolder = pholder;
    [self loadImageFromURL:url ttl:ttl];
}
-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl clean:(BOOL)clear withPlaceholder:(UIImage *)pholder{
    def_placeHolder = pholder;
    [self loadImageFromURL:url ttl:ttl clean:clear];
}
-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl endblock:(void(^)(UIImageViewJA *image))cb withPlaceholder:(UIImage *)pholder{
    def_placeHolder = pholder;
    [self loadImageFromURL:url ttl:ttl endblock:cb];
}


-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl clean:(BOOL)clear{
	self.clear_image = clear;
	[self loadImageFromURL:url ttl:ttl];
}


-(void)loadImageFromURL:(NSString*)url ttl:(unsigned)ttl endblock:(void(^)(UIImageViewJA *image))cb{
	callback = cb;
	[self loadImageFromURL:url ttl:ttl];
}
-(void)loadImageFromURL:(NSString *)url ttl:(unsigned)ttl{
#if TARGET_IPHONE_SIMULATOR
	//NSLog(@"image => %@",url);
#endif
    c_io.delegate = nil;
    c_io = nil;
    c_download.callback = nil;
    [c_download cancel];
	c_download=nil;
    
    
    //NSLog(@"DESTROY on instance %d %@",(int)self,url);
    
	isJpeg = NO;
	NSString *lowerstr = [url lowercaseString];
	isJpeg = [lowerstr isSubString:@".jpg"] || [lowerstr isSubString:@".jpeg"];
	_loaded = FALSE;
    if (![url isKindOfClass:[NSString class]])
        return;
    
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// url = [url strReplace:@" " to:@"%20"];
    
    if(self.image && ![self.dist_url isEqualToString:url] && _clear_image)
        self.image = [self placeHolder];
	if (!pool_img){
		pool_img = [[NSMutableDictionary alloc] init];
	}
    // TODO JA
    
	if (url == nil){
		self.image = [self placeHolder];
		return;
	}
    
	
	
	if (![url length])
		url = nil;
	if (!url){
		self.image = [self placeHolder];
        [self runCallBack];
		return;
	}
	
	if (!my_UIViewContentModeScaleAspectFit)
		my_UIViewContentModeScaleAspectFit = UIViewContentModeScaleAspectFit;
	
	if (!([url rangeOfString:@"http"].length > 0 || [url rangeOfString:@"/"].length > 0)){
		UIImage *j = [UIImage imageNamed:url];
		if (j){
			//NSLog(@"load image bundle");
			[self setupimage:j];
			return;
		}
	}

    
	if (!self.image)
        self.image = [self placeHolder];

	self.dist_url = url;
	
    NSString *locf = [self getLocaleFile:self.dist_url];
	
	
    
    UIImage *im = pool_img[locf];
    if (im){
        //NSLog(@"load image cache ram %@",locf);
        [self setupimage:im];
    }
    
    
	c_io.delegate = nil;
    c_io = nil;
    
    c_io = [[NSIOCheckImage alloc] init];
    c_io.delegate = self;
	[c_io run:url locf:locf ttl:ttl];
    
}


//-(BOOL)dataIsValidJPEG:(NSData *)thedata
//{
//    if (!thedata || thedata.length < 2) return NO;
//	
//    NSInteger totalBytes = thedata.length;
//    const char *bytes = (const char*)[thedata bytes];
//	
//    return (bytes[0] == (char)0xff &&
//            bytes[1] == (char)0xd8 &&
//            bytes[totalBytes-2] == (char)0xff &&
//            bytes[totalBytes-1] == (char)0xd9);
//}

+(void)freepool{
    pool_img = nil;
}
+(NSInteger) dateModifiedSort:(NSString *) file1 ttl:(unsigned)ttl {
    NSDictionary *attrs1 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:file1
                            error:nil];
	NSDate *a = attrs1[NSFileModificationDate];
	NSDate *b = [NSDate dateWithTimeIntervalSinceNow:-((int)ttl)];
	if ([a compare:b]  == NSOrderedDescending || !a)
		return 0;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([[UIMasterApplication getInstance] isTypeOfNet] > 0)
		[fileManager removeItemAtPath:file1 error:NULL];
	return 1;
}

- (void)dealloc {
	my_responder = nil;
	// TODO JA
	[c_download cancel]; //in case the URL is still downloading
	c_download = nil;
    c_io.delegate = nil;
    c_io = nil;
}


-(void)clearPool{
	if ([pool_img count] > 400){
		int k = 0;
		for (NSString *key in [pool_img allKeys]){
			if (k > 10)
				return;
			k++;
			[pool_img removeObjectForKey:key];
		}
	}
}






-(NSString*) getLocaleFile:(NSString *)str{
    NSString *jastr = [NSString stringWithFormat:@"%@", [[str md5] lowercaseString]];
	return [jastr toiphonecache];
}

-(void)write:(NSData*)urldata tofile:(NSString*)file{
	NSFileManager *FileManager = [NSFileManager defaultManager];
	BOOL success = [FileManager createFileAtPath:file  contents:urldata attributes:nil];
	if(!success) {
		NSLog(@"Failed to copy : %@.",  file);
	}
}

-(void)setupimage:(UIImage*)i{
	
//    NSLog(@" DISPLAY IMAGE FOR instance %d distfile %@",(int) self,dist_url);

    if(!i)
        self.image = [self placeHolder];
    else
        self.image = i;

    [self setNeedsDisplay];
	[self setClipsToBounds:YES];
	[self runCallBack];
}


#pragma mark Save To file and display
-(void)saveandloadlocal:(NSData*)d lf:(NSString*)lf {
	if (!d){
		[self setupimage:nil];
		return;
	}
	UIImage *i = [UIImage imageWithData:d];
	[self setupimage:i];
	[NSObject backGroundBlockDownload:^{
		if (i)
			[self write:d tofile:lf];
		else {
			//NSLog(@"erreur image %@ possible file %@", dist_url,lf);
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager removeItemAtPath:lf error:NULL];
		}
	}];
}


#pragma mark Start DL
-(void)runDL:(NSString*)localurl dist:(NSString*)disturl local_file:(NSString*)local_file{
	if (_clear_image)
		self.image = [self placeHolder];
    c_download = [[NSDLClassJA alloc] init];
    c_download.delegate = self.my_responder;
    c_download.delegate_image = self;
    __weak UIImageViewJA *this = self;
    NSString *lldffk = [local_file copy];
    __weak NSDLClassJA *c_download2 = c_download;
    [c_download setCallback:^(NSData *data) {
        //NSLog(@"display on instance %d %@ %@",(int)this,lldffk,disturl);
        if(c_download2.delegate_image)
            [this saveandloadlocal:data lf:lldffk];
    }];
    [c_download runDL:localurl dist:dist_url];
}








#pragma mark delegate UIIAMAGEVIEWJA
-(void)runCallBack{
	_loaded = TRUE;
	if ([my_responder respondsToSelector:@selector(finchargement:)])
		[my_responder finchargement:self];
	if(callback)
		callback(self);
	callback = nil;
}











#pragma mark - TFC

- (void)loadavatar:(NSString*)str{
	NSString *urlimg = @"http://www.thefanclub.com";
    if (![str isKindOfClass:[NSNull class]] && [str isSubString:@"http://www"]){
        urlimg = @"";
    }
	
	if (![str isKindOfClass:[NSNull class]] && [str isKindOfClass:[NSString class]] && ![str isEqualToString:@""]) {
		urlimg = [NSString stringWithFormat:@"%@%@", urlimg, str];
	}
	else {
		urlimg = [NSString stringWithFormat:@"%@/images/default.jpg", urlimg];
	}
	[self loadImageFromURL:urlimg ttl:60*60];
    [self.layer setCornerRadius:5.0];
}


#pragma mark - OPTA

-(NSString *)getF1CarsUrl:(NSString *)idcar{
	return [NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/F1/cars/tid_%@.png", idcar];
}

-(NSString *)getFlagsUrlWithIso3:(NSString *)iso{
	return [NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/F1/flags/%@.png", iso];
}

-(NSString *)getPilotById:(NSString *)idpilot{
	return [NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/F1/pilotes/pilote_%@.png", idpilot];
}
-(void)loadFlag:(NSString *)flag{
	[self loadImageFromURL:[self getFlagsUrlWithIso3:[flag lowercaseString]] ttl:7*24*60*60];
}
-(void)loadCar:(NSString *)car{
	[self loadImageFromURL:[self getF1CarsUrl:car] ttl:7*24*60*60];
}
-(void)loadCircuit:(NSString *)circuit{
	[self loadImageFromURL:[[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/F1/circuits/%@.png", circuit] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ttl:7*24*60*60];
}
-(void)loadRacePics:(NSString *)racepics{
	[self loadImageFromURL:[[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/F1/race_pics/%@-pics.png", racepics] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ttl:7*24*60*60];
}

-(void)getPlayerC10:(NSString *)idplayer{
    if ([NSObject isRetina])
        [self loadImageFromURL:[[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/Foot/logo_players_c10/home_%@%@.png", idplayer, @"@2x"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ttl:7*24*60*60];
    else
        [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/Foot/logo_players_c10/home_%@.png", idplayer] ttl:7*24*60*60];
}
-(void)getPlayerC10Bulle:(NSString *)idplayer{
    if ([NSObject isRetina])
        [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/Foot/logo_players_c10/%@%@.png", idplayer, @"@x2"] ttl:7*24*60*60];
    else
        [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/Foot/logo_players_c10/%@.png", idplayer] ttl:7*24*60*60];
}
-(void)getClubRugbyById:(NSString *)idclub{
	[self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/Rugby/logo_teams/club_%@.png", idclub] ttl:7*24*60*60];
}
-(void)getClubById:(NSString *)idclub withSize:(NSString *)size{
    /*
	 INFOS => Existing Sizes : 15x15, 30x30, 50x50, 90x90
     */
	NSString *sizePlus = [NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/Foot/logo_teams_reduce/Icones%@-%@", size, size];
	[self loadImageFromURL:[NSString stringWithFormat:@"%@/club_%@.png", sizePlus, idclub] ttl:7*24*60*60];
}
-(void)getClubById:(NSString *)idclub{
    /*
	 INFOS => Size : 120x120
     */
	[self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/Foot/logo_teams/club_%@.png", idclub] ttl:7*24*60*60];
}


#pragma mark - LFP

-(void)getCompLfpByKey:(NSString *)compKey{
	[self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/LFP/logo_comp/comp_%@.png", compKey] ttl:7*24*60*60];
}
-(void)getCompLfpFiligraneByKey:(NSString *)compKey{
	[self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/LFP/logo_comp/comp_fili_%@.png", compKey] ttl:7*24*60*60];
}


#pragma mark - GSM

-(void)getGSMcompByIdHDG:(NSString *)idTeam{
    [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/data_externe_iphone/HoraDoGol/comps/comp_%@.png", idTeam] ttl:60*60*24*7];
}

-(void)getGSMcompById:(NSString *)idComp{
    [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/comps/comp_%@.png", idComp] ttl:60*60*24*7];
}


// 20x20 / 25x25 / 50x50
-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format ttl:(unsigned)ttl{
	int isPic = 0;
    if ([hasPic isKindOfClass:[NSString class]]){
        isPic = [hasPic intValue];
    }
    else if ([hasPic isKindOfClass:[NSNumber class]]){
        isPic = [hasPic intValue];
    }
    
    if ([NSObject isRetina] && ![format isSubString:@"teams_rndone"])
        format = @"";
    
	if (format && [format isNotEqualToString:@""]){
		
	} else {
		format = @"teams";
	}
    if (isPic == 1){
        NSString *dir = [self getDirectoryGSMpics:idTeam];
        [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/%@/%@/%@.png", format, dir, idTeam] ttl:ttl];
    }
    else {
        [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/%@/generic.png", format] ttl:ttl];
    }
}


-(void) getRoundTeamPictoById :(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format endblock:(void(^)(UIImageViewJA *image))cb{
	int isPic = 0;
    if ([hasPic isKindOfClass:[NSString class]]){
        isPic = [hasPic intValue];
    }
    else if ([hasPic isKindOfClass:[NSNumber class]]){
        isPic = [hasPic intValue];
    }
    
    if ([NSObject isRetina] && ![format isSubString:@"teams_rndone"])
        format = @"";
    
	if (format && [format isNotEqualToString:@""])
    {
		
	}
    else
    {
//		format = @"teams";
	}
    
    NSString *url = [NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/teams_rndone/%@/generic.png", format];
    if (isPic == 1)
    {
        NSString *dir = [self getDirectoryGSMpics:idTeam];
        url = [NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/teams_rndone/%@/%@.png", dir, idTeam];
    }
    [self loadImageFromURL:url ttl:60*60*24*7 endblock:^(UIImageViewJA *image) {
        if (cb)
            cb(image);
    }];
}

-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format endblock:(void(^)(UIImageViewJA *image))cb{
	int isPic = 0;
    if ([hasPic isKindOfClass:[NSString class]]){
        isPic = [hasPic intValue];
    }
    else if ([hasPic isKindOfClass:[NSNumber class]]){
        isPic = [hasPic intValue];
    }
    
    if ([NSObject isRetina] && ![format isSubString:@"teams_rndone"])
        format = @"";
    
	if (format && [format isNotEqualToString:@""]){
		
	} else {
		format = @"teams";
	}
    NSString *url = [NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/%@/generic.png", format];
    if (isPic == 1){
        NSString *dir = [self getDirectoryGSMpics:idTeam];
        url = [NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/%@/%@/%@.png", format, dir, idTeam];
    }
    [self loadImageFromURL:url ttl:60*60*24*7 endblock:^(UIImageViewJA *image) {
        if (cb)
            cb(image);
    }];
}


-(void)getPlaceById:(NSString*)idPlace hasPic:(id)hasPic
{
    int isPic = 0;
    if ([hasPic isKindOfClass:[NSString class]]){
        isPic = [hasPic intValue];
    }
    else if ([hasPic isKindOfClass:[NSNumber class]]){
        isPic = [hasPic intValue];
    }
    
    if (isPic == 1){
        NSString *dir = [self getDirectoryGSMpics:idPlace];
        [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/places/size/%@/place_%@.jpg", dir, idPlace] ttl:60*60*24*7];
    }
    else {
        [self loadImageFromURL:@"http://www.thefanclub.com/gsm_medias/places/generic.png" ttl:60*60*24*7];
    }
}

-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic format:(NSString*)format
{
    [self getGSMteamById:idTeam hasPic:hasPic format:format ttl:60*60*24*7];
}

-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic{
	[self getGSMteamById:idTeam hasPic:hasPic format:nil ttl:60*60*24*7];
}

-(void)getGSMteamById:(NSString *)idTeam hasPic:(id)hasPic ttl:(unsigned)ttl{
	[self getGSMteamById:idTeam hasPic:hasPic format:nil ttl:ttl];
}

-(void)getGSMpersonById:(NSString *)idPerson hasPic:(id)hasPic{
    int isPic = 0;
    if ([hasPic isKindOfClass:[NSString class]]){
        isPic = [hasPic intValue];
    }
    else if ([hasPic isKindOfClass:[NSNumber class]]){
        isPic = [hasPic intValue];
    }
    
    if (isPic == 1){
        NSString *dir = [self getDirectoryGSMpics:idPerson];
        [self loadImageFromURL:[NSString stringWithFormat:@"http://www.thefanclub.com/gsm_medias/soccer/persons/%@/%@.jpg", dir, idPerson] ttl:60*60*24*7];
    }
    else {
        [self loadImageFromURL:@"http://www.thefanclub.com/gsm_medias/soccer/persons/generic.png" ttl:60*60*24];
    }
}



-(NSString *)getDirectoryGSMpics:(NSString *)idPic{
    int dir = (floor([idPic intValue] / 1000) + 1) * 1000;
    return [NSString stringWithFormat:@"%d", dir];
}

#pragma mark -
#pragma mark WORLD CUP

-(void)getWCteamFedFlag:(NSString *)teamShortName
{
    [self getWCteamFedFlag:teamShortName withBaseUrl:@"http://www.thefanclub.com/data_externe_iphone/FIFA"];
}

-(void)getWCteamBigFlag:(NSString *)teamShortName
{
    [self getWCteamBigFlag:teamShortName withBaseUrl:@"http://www.thefanclub.com/data_externe_iphone/FIFA"];
}

-(void)getWCteamBigFlagGrad:(NSString *)teamShortName
{
    [self getWCteamBigFlagGrad:teamShortName withBaseUrl:@"http://www.thefanclub.com/data_externe_iphone/FIFA"];
}

-(void)getWCteamFlag:(NSString *)teamShortName{
    c_io.delegate = nil;
    c_io = nil;
    [self getWCteamFlag:teamShortName withFormat:@"64" withBaseUrl:@"http://www.thefanclub.com/data_externe_iphone/FIFA"];
}

-(void)getWCteamFlag:(NSString *)teamShortName withFormat:(NSString *)format{
    [self getWCteamFlag:teamShortName withFormat:format withBaseUrl:@"http://www.thefanclub.com/data_externe_iphone/FIFA"];
}

-(void)getWCteamFedFlag:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl
{
    c_io.delegate = nil;
    c_io = nil;
    teamShortName = [teamShortName lowercaseString];
    [self loadImageFromURL:[NSString stringWithFormat:@"%@/teams/fed/%@.png", baseUrl, teamShortName] ttl:60*60*24*7];
}

-(void)getWCteamBigFlag:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl
{
    c_io.delegate = nil;
    c_io = nil;
    teamShortName = [teamShortName lowercaseString];
    [self loadImageFromURL:[NSString stringWithFormat:@"%@/teams/big_team/%@.png", baseUrl, teamShortName] ttl:60*60*24*7];
}

-(void)getWCteamBigFlagGrad:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl
{
    c_io.delegate = nil;
    c_io = nil;
    teamShortName = [teamShortName lowercaseString];
    [self loadImageFromURL:[NSString stringWithFormat:@"%@/teams/big_team_grad/%@.png", baseUrl, teamShortName] ttl:60*60*24*7];
}

-(void)getWCteamFlag:(NSString *)teamShortName withBaseUrl:(NSString *)baseUrl
{
    c_io.delegate = nil;
    c_io = nil;
    [self getWCteamFlag:teamShortName withFormat:@"64" withBaseUrl:baseUrl];
}

-(void)getWCteamFlag:(NSString *)teamShortName withFormat:(NSString *)format withBaseUrl:(NSString *)baseUrl
{
    teamShortName = [teamShortName lowercaseString];
    [self loadImageFromURL:[NSString stringWithFormat:@"%@/teams/team_%@/%@.png", baseUrl, format, teamShortName] ttl:60*60*24*7];
}


@end




