//
//  NSSharingKit.m
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import "NSSharingKit.h"
#import "NSSharedItem.h"
#import "NSNetworkFactory.h"
#import "FacebookNetwork.h"

#define DEFAULT_JSON    @"config"

@interface NSSharingKit ()

/**
 *  Application's name to display when sharing
 */
@property (strong, nonatomic) NSString*   app;

/**
 *  list of AbstractNetworks that describe all networks
 *  used for sharing
 */
@property (strong, nonatomic) NSArray*    networks;


/**
 *  default item
 */
@property (strong, nonatomic) NSMutableDictionary* defaultItem;

/**
 *  list of NSSharedItems that can be used for sharing.
 *  @example articles, news, photos
 */
@property (strong, nonatomic) NSArray*    items;

/**
 * datas for dynamic render
 */
@property (strong, nonatomic) NSDictionary *datas;

/**
 * list of NSSharingMenuItem
 */
@property (strong, nonatomic) NSArray *menuItems;

/**
 * controller that present all the sharing views
 */
@property (strong, nonatomic) UIViewController *controller;

/**
 *  Method that loads the default json and initializes
 *  the networks and items arrays
 */
- (void) loadDefaultJson;

/**
 *  Method that loads a json file and update the datas
 *  @param  path NSString filepath
 */
- (void) loadJson : (NSString *) path;

/**
 *  Method that initializes datas from a dictionary
 *  @param  datas NSDictionary
 */
- (void) initializeFromDictionary: (NSDictionary *) datas;

/**
 *  Method that loads default networks
 *  @param  NSArray networks got from files
 */
- (void) loadDefaultNetworks: (NSArray *) networks;

/**
 *  Method that loads default items
 *  @param  NSDictionary defaultItems with items for each type.
 */
- (void) loadDefaultItems: (NSDictionary *) items;

/**
 *  Method that updates the default networks
 *  @param  NSArray networks
 */
- (void) updateNetworks: (NSArray *) networks;

/**
 *  Method that updates default items
 *  @param  NSDictionary items
 */
- (void) updateItems: (NSDictionary *) items;

@end

@implementation NSSharingKit

- (id) init
{
    self = [super init];
    if (self)
    {
        [self loadDefaultJson];
    }
    return self;
}

- (id) initWithJson: (NSURL *) url
{
    self = [self init];
    if (self)
    {
        NSData* data = [NSData dataWithContentsOfURL: url];
        NSError *error = nil;
        NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (response){
            [self initializeFromDictionary:[response objectForKey:@"Sharing Kit"]];
        }
    }
    return self;
}

- (id) initWithData: (NSData *) data
{
    self = [self init];
    if (self)
    {
        NSError *error = nil;
        NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (response){
            [self initializeFromDictionary:[response objectForKey:@"Sharing Kit"]];
        }
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict
{
    self = [self init];
    if (self)
    {
        [self initializeFromDictionary:[dict objectForKey:@"Sharing Kit"]];
    }
    return self;
}


- (id) initWithFile: (NSString *) filePath
{
    self = [self init];
    if (self)
    {
        [self loadJson:filePath];
    }
    return self;
}

- (void) renderViewWithDatas: (NSDictionary *) datas controller:(UIViewController *)controller
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    NSString *type = [datas objectForKey:@"type"];
    NSDictionary *placeHolder = [datas objectForKey:@"placeholder"];
    NSDictionary *dic_networks = [datas objectForKey:@"networks"];
    int index = 0;
    for (AbstractNetwork *network in self.networks)
    {
        if (dic_networks && [dic_networks count] > 0)
        {
            for (NSString *network_datas in dic_networks)
            {
                if ([network_datas isEqualToString:network.networkId])
                {
                    NSString *active_value = [dic_networks objectForKey:network_datas];
                    if ([active_value isEqualToString:@"1"])
                    {
                        [sheet addButtonWithTitle:network.name];
                        network.controller = controller;
                        network.index = index;
                        index++;
                        NSString *s_type = [NSString stringWithFormat:@"%@_%@", network_datas, type];
                        NSSharedItem *sharedItem = nil;
                        for (NSSharedItem *current in self.items)
                        {
                            if ([current.type isEqualToString:s_type])
                            {
                                sharedItem = [current copy];
                                break;
                            }
                        }
                        if (!sharedItem)
                        {
                            sharedItem = [[NSSharedItem alloc] initWithDictionary:self.defaultItem];
                            NSMutableArray *itemsList = [NSMutableArray arrayWithArray:self.items];
                            [itemsList addObject:sharedItem];
                            self.items = itemsList;
                        }
                        NSString *title = [placeHolder objectForKey:@"title"];
                        if (title)
                        {
                            sharedItem.title = [sharedItem.title stringByReplacingOccurrencesOfString:@"%{title}%" withString:title];
							sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{title}%" withString:title];
                        }
                        NSString *author = [placeHolder objectForKey:@"author"];
                        if (author)
                        {
                            sharedItem.author = [sharedItem.author stringByReplacingOccurrencesOfString:@"%{author}%" withString:author];
                        }
                        UIImage *image = [placeHolder objectForKey:@"image"];
                        if (image)
                        {
                            sharedItem.image = image;
                        }
                        NSString *desc = [placeHolder objectForKey:@"desc"];
                        if (desc)
                        {
                            sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{desc}%" withString:desc];
                        }
                        NSString *url = [placeHolder objectForKey:@"url"];
                        if (url)
                        {
							sharedItem.title = [sharedItem.title stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
                            sharedItem.url = [sharedItem.url stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
							sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
                        }
                        NSString *app = [placeHolder objectForKey:@"app"];
                        if (app)
                        {
                            sharedItem.app = [sharedItem.app stringByReplacingOccurrencesOfString:@"%{app}%" withString:app];
                        }
                        NSString *recipient = [placeHolder objectForKey:@"recipient"];
                        if (recipient)
                        {
                            sharedItem.recipient = [sharedItem.recipient stringByReplacingOccurrencesOfString:@"%{recipient}%" withString:recipient];
                        }
                        NSString *image_url = [placeHolder objectForKey:@"image_url"];
                        if (image_url)
                        {
                            sharedItem.image_url = [sharedItem.image_url stringByReplacingOccurrencesOfString:@"%{image_url}%" withString:image_url];
                        }
                        network.item = sharedItem;
                    }
                }
            }
        }
    }
    [sheet addButtonWithTitle:NSLocalizedString(@"Annuler", nil)];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    [sheet showInView:controller.view];
}

- (void) renderDynamicViewIn:(UIViewController *) controller atPoint: (CGPoint) point WithDatas: (NSDictionary *) datas withConfig:(NSShareMenuConfiguration *)config
{
    self.datas = datas;
    NSMutableArray *menus = [[NSMutableArray alloc] init];
    NSString *type = [datas objectForKey:@"type"];
    NSDictionary *placeHolder = [datas objectForKey:@"placeholder"];
    NSDictionary *dic_networks = [datas objectForKey:@"networks"];
    int index = 0;
    for (AbstractNetwork *network in self.networks)
    {
        if (dic_networks && [dic_networks count] > 0)
        {
            for (NSString *network_datas in dic_networks)
            {
                if ([network_datas isEqualToString:network.networkId])
                {
                    NSString *active_value = [dic_networks objectForKey:network_datas];
                    if ([active_value isEqualToString:@"1"])
                    {
                        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"NSShareKitResources.bundle/%@Button.png", network.networkId]];
                        UIImage *imgPressed = [UIImage imageNamed:[NSString stringWithFormat:@"NSShareKitResources.bundle/%@Button.png", network.networkId]];
                        //UIImage *logo = [UIImage imageNamed:[NSString stringWithFormat:@"NSShareKitResources.bundle/%@.png", network.networkId]];
                        NSSharingMenuItem *menuItem = [[NSSharingMenuItem alloc] initWithImage:img
                                                                              highlightedImage:imgPressed
                                                                                  ContentImage:nil
                                                                       highlightedContentImage:nil
                                                                                    forNetwork:network.networkId];
                        [menus addObject:menuItem];
                        network.controller = controller;
                        network.index = index;
                        index++;
                        NSString *s_type = [NSString stringWithFormat:@"%@_%@", network_datas, type];
                        NSSharedItem *sharedItem = nil;
                        for (NSSharedItem *current in self.items)
                        {
                            if ([current.type isEqualToString:s_type])
                            {
                                sharedItem = [current copy];
                                break;
                            }
                        }
                        if (!sharedItem)
                        {
                            sharedItem = [[NSSharedItem alloc] initWithDictionary:self.defaultItem];
                            NSMutableArray *itemsList = [NSMutableArray arrayWithArray:self.items];
                            [itemsList addObject:sharedItem];
                            self.items = itemsList;
                        }
                        NSString *title = [placeHolder objectForKey:@"title"];
                        if (title)
                        {
                            sharedItem.title = [sharedItem.title stringByReplacingOccurrencesOfString:@"%{title}%" withString:title];
							sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{title}%" withString:title];
                        }
                        NSString *author = [placeHolder objectForKey:@"author"];
                        if (author)
                        {
                            sharedItem.author = [sharedItem.author stringByReplacingOccurrencesOfString:@"%{author}%" withString:author];
                        }
                        UIImage *image = [placeHolder objectForKey:@"image"];
                        if (image)
                        {
                            sharedItem.image = image;
                        }
                        NSString *desc = [placeHolder objectForKey:@"desc"];
                        if (desc)
                        {
                            sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{desc}%" withString:desc];
                        }
                        NSString *url = [placeHolder objectForKey:@"url"];
                        if (url)
                        {
							sharedItem.title = [sharedItem.title stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
                            sharedItem.url = [sharedItem.url stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
							sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
                        }
                        NSString *app = [placeHolder objectForKey:@"app"];
                        if (app)
                        {
                            sharedItem.app = [sharedItem.app stringByReplacingOccurrencesOfString:@"%{app}%" withString:app];
                        }
                        NSString *recipient = [placeHolder objectForKey:@"recipient"];
                        if (recipient)
                        {
                            sharedItem.recipient = [sharedItem.recipient stringByReplacingOccurrencesOfString:@"%{recipient}%" withString:recipient];
                        }
                        NSString *image_url = [placeHolder objectForKey:@"image_url"];
                        if (image_url)
                        {
                            sharedItem.image_url = [sharedItem.image_url stringByReplacingOccurrencesOfString:@"%{image_url}%" withString:image_url];
                        }
                        network.item = sharedItem;
                    }
                }
            }
        }
    }
    self.menuItems = menus;
    self.controller = controller;
    NSSharingMenu *menu = [[NSSharingMenu alloc] initWithFrame:controller.view.bounds AtPoint:point items:menus withConfig: config];
    menu.delegate = self;
    [controller.view addSubview:menu];
    [controller.view bringSubviewToFront:menu];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= [self.networks count])
    {
        return;
    }
    for (AbstractNetwork *network in self.networks)
    {
        if (network.index == buttonIndex)
        {
            [network share];
        }
    }
}

- (AbstractNetwork *)   getNetworkFromId:(NSString *) networkId
{
    for (AbstractNetwork *network in self.networks)
    {
        if ([network.networkId isEqualToString:networkId])
        {
            return (network);
        }
    }
    [NSException raise:NSInternalInconsistencyException
                format:@"%@ does not exist", networkId];
    return nil;
}

-(void) shareViaNetwork: (NSString *) networkId withDatas: (NSDictionary *) datas controller: (UIViewController *) controller
{
    AbstractNetwork *network = [self getNetworkFromId:networkId];
    network.controller = controller;
    NSString *type = [datas objectForKey:@"type"];
    NSSharedItem *sharedItem = nil;
    for (NSSharedItem *current in self.items)
    {
        if ([current.type isEqualToString:type])
        {
            sharedItem = [current copy];
            break;
        }
    }
    if (!sharedItem)
    {
        sharedItem = [[NSSharedItem alloc] initWithDictionary:self.defaultItem];
        sharedItem.type = type;
        NSMutableArray *itemsList = [NSMutableArray arrayWithArray:self.items];
        [itemsList addObject:sharedItem];
        self.items = itemsList;
    }
    NSString *title = [datas objectForKey:@"title"];
    if (title)
    {
        sharedItem.title = [sharedItem.title stringByReplacingOccurrencesOfString:@"%{title}%" withString:title];
		sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{title}%" withString:title];
    }
    NSString *author = [datas objectForKey:@"author"];
    if (author)
    {
        sharedItem.author = [sharedItem.author stringByReplacingOccurrencesOfString:@"%{author}%" withString:author];
    }
    
    UIImage *image = [datas objectForKey:@"image"];
    if (image)
    {
        sharedItem.image = image;
    }
    NSString *desc = [datas objectForKey:@"desc"];
    if (desc)
    {
        sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{desc}%" withString:desc];
    }
    NSString *url = [datas objectForKey:@"url"];
    if (url)
    {
        sharedItem.url = [sharedItem.url stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
		sharedItem.desc = [sharedItem.desc stringByReplacingOccurrencesOfString:@"%{url}%" withString:url];
    }
    NSString *app = [datas objectForKey:@"app"];
    if (app)
    {
        sharedItem.app = [sharedItem.app stringByReplacingOccurrencesOfString:@"%{app}%" withString:app];
    }
    NSString *image_url = [datas objectForKey:@"image_url"];
    if (image_url)
    {
        sharedItem.image_url = [sharedItem.image_url stringByReplacingOccurrencesOfString:@"%{image_url}%" withString:image_url];
    }
    NSString *recipient = [datas objectForKey:@"recipient"];
    if (recipient)
    {
        sharedItem.recipient = [sharedItem.recipient stringByReplacingOccurrencesOfString:@"%{recipient}%" withString:recipient];
    }
    network.item = sharedItem;
    [network share];
}

- (void) loadDefaultJson
{
    NSBundle *sharingKitBundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@"NSShareKit" ofType:@"bundle"]];
    NSString *filePath = [sharingKitBundle pathForResource:DEFAULT_JSON ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (response)
    {
        NSDictionary *defaultDatas = [response objectForKey:@"Sharing Kit"];
        self.app = [defaultDatas objectForKey:@"app"];
        [self loadDefaultNetworks:[defaultDatas objectForKey:@"networks"]];
        [self loadDefaultItems:[defaultDatas objectForKey:@"items"]];
    }
}

- (void) loadJson: (NSString *) path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (response)
    {
        [self initializeFromDictionary:[response objectForKey:@"Sharing Kit"]];
    }
}

- (void) initializeFromDictionary: (NSDictionary *) datas
{
    if (datas)
    {
        NSString *app = [datas objectForKey:@"app"];
        if (app && [app length] != 0)
        {
            self.app = app;
        }
        [self updateNetworks:[datas objectForKey:@"networks"]];
        [self updateItems:[datas objectForKey:@"items"]];
    }
}

- (void) loadDefaultNetworks: (NSArray *) networks
{
    if (networks)
    {
        NSMutableArray *nwTmp = [[NSMutableArray alloc] init];
        for (NSDictionary *network in networks)
        {
            NSString *networkId = [network objectForKey:@"networkId"];
            NSString *name = [network objectForKey:@"name"];
            AbstractNetwork *an = [NSNetworkFactory getNetwork:networkId];
            an.networkId = networkId;
            an.name = name;
            //an.logo = [UIImage imageNamed:logo];
            [nwTmp addObject:an];
        }
        self.networks = nwTmp;
    }
}

- (void) updateNetworks: (NSArray *) networks
{
    if (networks)
    {
        NSMutableArray *addedNetworks = [[NSMutableArray alloc] init];
        for (NSDictionary *network in networks)
        {
            NSString *networkId = [network objectForKey:@"networkId"];
            NSString *name = [network objectForKey:@"name"];
            NSString *logo = [network objectForKey:@"logo"];
            BOOL toCreate = YES;
            for (AbstractNetwork *current in self.networks)
            {
                if ([current.networkId isEqualToString:networkId])
                {
                    if (name && [name length] != 0)
                    {
                        current.name = name;
                    }
                    if (logo && [logo length] != 0)
                    {
                        current.logo = [UIImage imageNamed:logo];
                    }
                    toCreate = NO;
                    break;
                }
            }
            if (toCreate)
            {
                AbstractNetwork *an = [NSNetworkFactory getNetwork:networkId];
                an.networkId = networkId;
                an.name = name;
                an.logo = [UIImage imageNamed:logo];
                [addedNetworks addObject:an];
            }
        }
        if ([addedNetworks count] != 0){
            self.networks = [NSArray arrayWithObjects:self.networks, addedNetworks, nil];
        }
    }
}

- (void) loadDefaultItems: (NSDictionary *) items
{
    if (items)
    {
        NSMutableArray *itemsTmp = [[NSMutableArray alloc] init];
        NSMutableDictionary *defaultItem = [items objectForKey:@"defaultItem"];
        NSArray *typeItems = [items objectForKey:@"typeItems"];
        for (NSDictionary *item in typeItems)
        {
            NSArray *types = [item objectForKey:@"type"];
            NSArray *networks = [item objectForKey:@"networks"];
            for (NSString *type in types)
            {
                NSMutableDictionary *dic_new = [NSMutableDictionary dictionaryWithDictionary:item];
                if (!networks || [networks count] <= 0)
                {
                    NSSharedItem *sharedItem = [[NSSharedItem alloc] initWithDictionary:defaultItem];
                    [dic_new setObject:type forKey:@"type"];
                    [sharedItem updateWithDictionary:dic_new];
                    [itemsTmp addObject:sharedItem];
                }
                else
                {
                    for (NSString *network in networks)
                    {
                        NSSharedItem *sharedItem = [[NSSharedItem alloc] initWithDictionary:defaultItem];
                        NSString *s_key = [NSString stringWithFormat:@"%@_%@", network, type];
                        [dic_new setObject:s_key forKey:@"type"];
                        [sharedItem updateWithDictionary:dic_new];
                        [itemsTmp addObject:sharedItem];
                    }
                }
            }
        }
        self.items = itemsTmp;
        self.defaultItem = defaultItem;
    }
}

- (void) updateItems: (NSDictionary *) items
{
    if (items)
    {
        NSMutableArray *addedItems = [[NSMutableArray alloc] init];
        NSArray *typeItems = [items objectForKey:@"typeItems"];
        if (typeItems)
        {
            for (NSDictionary *currentItem in typeItems)
            {
                NSArray *types = [currentItem objectForKey:@"type"];
                NSArray *networks = [currentItem objectForKey:@"networks"];
                for (NSString *type in types)
                {
                    NSString *cur_type = type;
                    if (!networks || [networks count] <= 0)
                    {
                        NSSharedItem *curItem = nil;
                        for (NSSharedItem *curSharedItem in self.items)
                        {
                            if ([cur_type isEqualToString:curSharedItem.type])
                            {
                                curItem = curSharedItem;
                                break;
                            }
                        }
                        if (!curItem)
                        {
                            curItem = [[NSSharedItem alloc] initWithDictionary:self.defaultItem];
                        }
                        curItem.type = cur_type;
                        NSString *title = [currentItem objectForKey:@"title"];
                        curItem.title = title ? title : curItem.title;
                        NSString *author = [currentItem objectForKey:@"author"];
                        curItem.author = author ? author : curItem.author;
                        NSString *desc = NSLocalizedString( [currentItem objectForKey:@"desc"], nil);
                        curItem.desc = desc ? desc : curItem.desc;
                        NSString *app = [currentItem objectForKey:@"app"];
                        curItem.app = app ? app : curItem.app;
                        NSString *imgName = [currentItem objectForKey:@"image"];
                        curItem.image = imgName ? [UIImage imageNamed:imgName] : curItem.image;
                        NSString *url = [currentItem objectForKey:@"url"];
                        curItem.url = url ? url : curItem.url;
                        NSString *recipient = [currentItem objectForKey:@"recipient"];
                        curItem.recipient = recipient ? recipient : curItem.recipient;
                        NSString *image_url = [currentItem objectForKey:@"image_url"];
                        curItem.image_url = image_url ? image_url : curItem.image_url;
                        [addedItems addObject:curItem];
                    }
                    else
                    {
                        for (NSString *network in networks)
                        {
                            NSSharedItem *curItem = nil;
                            cur_type = [NSString stringWithFormat:@"%@_%@", network, type];
                            for (NSSharedItem *curSharedItem in self.items)
                            {
                                if ([cur_type isEqualToString:curSharedItem.type])
                                {
                                    curItem = curSharedItem;
                                    break;
                                }
                            }
                            if (!curItem)
                            {
                                curItem = [[NSSharedItem alloc] initWithDictionary:self.defaultItem];
                            }
                            curItem.type = cur_type;
                            NSString *title = [currentItem objectForKey:@"title"];
                            curItem.title = title ? title : curItem.title;
                            NSString *author = [currentItem objectForKey:@"author"];
                            curItem.author = author ? author : curItem.author;
                            NSString *desc = NSLocalizedString( [currentItem objectForKey:@"desc"], nil);
                            curItem.desc = desc ? desc : curItem.desc;
                            NSString *app = [currentItem objectForKey:@"app"];
                            curItem.app = app ? app : curItem.app;
                            NSString *imgName = [currentItem objectForKey:@"image"];
                            curItem.image = imgName ? [UIImage imageNamed:imgName] : curItem.image;
                            NSString *url = [currentItem objectForKey:@"url"];
                            curItem.url = url ? url : curItem.url;
                            NSString *recipient = [currentItem objectForKey:@"recipient"];
                            curItem.recipient = recipient ? recipient : curItem.recipient;
                            NSString *image_url = [currentItem objectForKey:@"image_url"];
                            curItem.image_url = image_url ? image_url : curItem.image_url;
                            [addedItems addObject:curItem];
                        }
                    }
                }
            }
        }
        NSMutableArray *item_to_remove = [[NSMutableArray alloc] init];
        for (NSSharedItem *item in self.items)
        {
            for (NSSharedItem *nw_item in addedItems)
            {
                if ([item.type isEqualToString:nw_item.type])
                {
                    [item_to_remove addObject:nw_item];
                    break;
                }
            }
        }
        NSMutableArray *ar_nw_items = [NSMutableArray arrayWithArray:self.items];
        [ar_nw_items removeObjectsInArray:item_to_remove];
        [ar_nw_items addObjectsFromArray:addedItems];
        self.items = [NSArray arrayWithArray:ar_nw_items];
    }
}

- (void) setCompletionDone:(CompletionBlock)blockDone
{
    if (self.networks && [self.networks count] != 0)
    {
         for (AbstractNetwork *network in self.networks)
         {
             [network setCompletionDone:blockDone];
         }
    }
}

- (void) setCompletionCanceled:(CompletionBlock)blockCanceled
{
    if (self.networks && [self.networks count] != 0)
    {
        for (AbstractNetwork *network in self.networks)
        {
            [network setCompletionCanceled:blockCanceled];
        }
    }
}

- (void) setCompletionFailed:(CompletionBlock)blockFailed
{
    if (self.networks && [self.networks count] != 0)
    {
        for (AbstractNetwork *network in self.networks)
        {
            [network setCompletionFailed:blockFailed];
        }
    }
}

- (void) setCompletionSaved:(CompletionBlock)blockSaved
{
    if (self.networks && [self.networks count] != 0)
    {
        for (AbstractNetwork *network in self.networks)
        {
            [network setCompletionSaved:blockSaved];
        }
    }
}

- (void) setCompletionDone:(CompletionBlock)blockDone networkId:(NSString *)networkId
{
    AbstractNetwork *network = [self getNetworkFromId:networkId];
    [network setCompletionDone:blockDone];
}

- (void) setCompletionCanceled:(CompletionBlock)blockCanceled networkId:(NSString *)networkId
{
    AbstractNetwork *network = [self getNetworkFromId:networkId];
    [network setCompletionCanceled:blockCanceled];
}

- (void) setCompletionFailed:(CompletionBlock)blockFailed networkId:(NSString *)networkId
{
    AbstractNetwork *network = [self getNetworkFromId:networkId];
    [network setCompletionFailed:blockFailed];
}

- (void) setCompletionSaved:(CompletionBlock)blockSaved networkId:(NSString *)networkId
{
    AbstractNetwork *network = [self getNetworkFromId:networkId];
    [network setCompletionSaved:blockSaved];
}

- (void)NSSharingMenu:(NSSharingMenu *)menu didSelectIndex:(NSInteger)index
{
    if (index >= [self.networks count])
    {
        return;
    }
    for (AbstractNetwork *network in self.networks)
    {
        if (network.index == index)
        {
            [network share];
        }
    }
}

@end
