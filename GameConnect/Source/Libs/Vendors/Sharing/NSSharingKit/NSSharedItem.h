//
//  NSSharedItem.h
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Interface to describe a single item to share
 */
@interface NSSharedItem : NSObject<NSCopying>

/**
 *  Item type.
 *  @example    article, news, picture
 */
@property (strong, nonatomic) NSString*   type;

/**
 *  Title of the article
 */
@property (strong, nonatomic) NSString*   title;

/**
 *  Author who share the article
 */
@property (strong, nonatomic) NSString*   author;

/**
 *  Image that can be shared with the item
 */
@property (strong, nonatomic) UIImage*    image;

/**
 *  Image url that can be shared with the item
 */
@property (strong, nonatomic) NSString*   image_url;

/**
 *  Complete description.
 *  @example    tweet's body, description of an article
 */
@property (strong, nonatomic) NSString*   desc;

/**
 *  App's name from where the item is shared
 */
@property (strong, nonatomic) NSString*   app;

/**
 *  Url to share.
 *  @example    app, image, website
 */
@property (strong, nonatomic) NSString*      url;

/**
 * Recipient for email
 */
@property (strong, nonatomic) NSString*     recipient;


/**
 * Initialize an item via a JSON object in order to initialize
 * the attributes
 * @param   JsonObject JSON String describing an item.
 * @return  initialized object
 */
- (id) initWithJSON: (NSString *) jsonObject;

/**
 * Initialize an item via a NSData serialized from a json object.
 * @param   datas NSData
 * @return  initialized object
 */
- (id) initWithData: (NSData *) datas;

/**
 * Initialize an item via a dictionary
 * @param   dict NSDictionary
 * @return  initialized object
 */
- (id) initWithDictionary: (NSDictionary *) dict;

/**
 * Update an item via a dictionary
 * @param   dict NSDictionary
 * @return  BOOL
 */
- (BOOL) updateWithDictionary: (NSDictionary *) dict;

/**
 * Update an item throught another item
 * @param   item NSSharedItem
 * @return  BOOL
 */
- (BOOL) updateWithNSSharedItem: (NSSharedItem *) item;

@end
