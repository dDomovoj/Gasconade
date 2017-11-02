//
//  NSSharedItem.m
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import "NSSharedItem.h"

#define ITEM_TYPE           @"type"

#define ITEM_TITLE          @"title"

#define ITEM_AUTHOR         @"author"

#define ITEM_DESCRIPTION    @"desc"

#define ITEM_APP            @"app"

#define ITEM_IMAGE          @"image"

#define ITEM_IMAGE_URL      @"image_url"

#define ITEM_URL            @"url"

#define ITEM_RECIPIENT      @"recipient"

@interface NSSharedItem (Private)

/**
 *  Method used to parse json object in order to initialize the attributes
 *  @param  data NSdata sent to the init method
 */
- (void) initializeItemDatas: (NSData *) data;


/**
 * Method used to initialize the attributes from a dictionary.
 * @param dict NSDictionary
 */
- (void) initializeItemDatasFromDictionary: (NSDictionary *) dict;

@end

@implementation NSSharedItem

@synthesize title = _title, author = _author, desc = _desc, app = _app, image = _image, url = _url, recipient = _recipient;
@synthesize image_url = _image_url;

- (id) init{
    self = [super init];
    if (self)
    {
    }
    return self;
}


- (id) initWithJSON:(NSString *)jsonObject{
    self = [super init];
    if (self)
    {
        NSData *data = [jsonObject dataUsingEncoding:NSUTF8StringEncoding];
        [self initializeItemDatas:data];
    }
    return self;
}

- (id) initWithData:(NSData *)data{
    self = [super init];
    if (self)
    {
        [self initializeItemDatas:data];
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict{
    self = [super init];
    if (self)
    {
        [self initializeItemDatasFromDictionary:dict];
    }
    return self;
}

- (void) initializeItemDatas: (NSData *) data;
{
    NSError *error = nil;
    NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (response){
        [self initializeItemDatasFromDictionary:response];
    }
}


- (void) initializeItemDatasFromDictionary:(NSDictionary *)dict
{
    if (dict)
    {
        self.type = [dict objectForKey:ITEM_TYPE];
        self.title = [dict objectForKey:ITEM_TITLE];
        self.author = [dict objectForKey:ITEM_AUTHOR];
        self.desc = [dict objectForKey:ITEM_DESCRIPTION];
        self.app = [dict objectForKey:ITEM_APP];
        self.url = [dict objectForKey:ITEM_URL];
		self.image_url = [dict objectForKey:ITEM_IMAGE_URL];
        UIImage *image = [dict objectForKey:ITEM_IMAGE];
        if (image)
        {
            self.image = image;
        }
        self.recipient = [dict objectForKey:ITEM_RECIPIENT];
    }
}

- (BOOL) updateWithDictionary: (NSDictionary *) dict
{
    if (dict)
    {
        NSString *type = [dict objectForKey:ITEM_TYPE];
        if (type)
        {
            self.type = type;
        }
        NSString *title = [dict objectForKey:ITEM_TITLE];
        if (title)
        {
            self.title = title;
        }
        NSString *author = [dict objectForKey:ITEM_AUTHOR];
        if (author)
        {
            self.author = author;
        }
        NSString *desc = [dict objectForKey:ITEM_DESCRIPTION];
        if (desc)
        {
            self.desc = desc;
        }
        NSString *app = [dict objectForKey:ITEM_APP];
        if (app)
        {
            self.app = app;
        }
        UIImage *image = [dict objectForKey:ITEM_IMAGE];
        if (image)
        {
            self.image = image;
        }
        NSString *imageu = [dict objectForKey:ITEM_IMAGE_URL];
        if (imageu)
        {
            self.image_url = imageu;
        }
		NSString *url = [dict objectForKey:ITEM_URL];
        if (url)
        {
            self.url = url;
        }
        NSString *recipient = [dict objectForKey:ITEM_RECIPIENT];
        if (recipient)
        {
            self.recipient = recipient;
        }
        return YES;
    }
    return NO;
}

- (BOOL) updateWithNSSharedItem: (NSSharedItem *) item
{
    if (item)
    {
        if (item.type)
        {
            self.type = item.type;
        }
        if (item.title)
        {
            self.title = item.title;
        }
        if (item.author)
        {
            self.author = item.author;
        }
        if (item.desc)
        {
            self.desc = item.desc;
        }
        if (item.app)
        {
            self.app = item.app;
        }
        if (item.image)
        {
            self.image = item.image;
        }
        if (item.image_url)
        {
            self.image_url = item.image_url;
        }
		if (item.url)
        {
            self.url = item.url;
        }
        if (item.recipient)
        {
            self.recipient = item.recipient;
        }
        return YES;
    }
    return NO;
}

-(id) copyWithZone: (NSZone *) zone
{
    NSSharedItem *itemCopy = [[NSSharedItem allocWithZone: zone] init];
    itemCopy.title = self.title;
    itemCopy.type = self.type;
    itemCopy.author = self.author;
    itemCopy.image = self.image;
    itemCopy.desc = self.desc;
    itemCopy.app = self.app;
    itemCopy.url = self.url;
    itemCopy.recipient = self.recipient;
	itemCopy.image_url = self.image_url;
    return itemCopy;
}

@end
