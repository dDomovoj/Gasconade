//
//  NSSharingKit.h
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractNetwork.h"
#import "NSSharingMenu.h"
#import "NSShareMenuConfiguration.h"

/**
 *  Main class used to handle sharing networks and items
 */
@interface NSSharingKit : NSObject<UIActionSheetDelegate, NSSharingMenuDelegate>

/**
 *  init method that initialized the sharing library with
 *  a json reachabled via an URL.
 *  The json must override some default parameters.
 *  @see    init
 *  @param  url NSURL url to reach the json
 *  @return NSSharingKit
 */
- (id) initWithJson: (NSURL *) url;

/**
 *  init method that initializes with a data
 *  representing a json object.
 *  the data must override some default parameters.
 *  @see    init
 *  @param  data NSData representing a json object
 *  @return NSSharingKit
 */
- (id) initWithData: (NSData *) data;

/**
 *  init method that initializes with a dictionary
 *  representing a json object.
 *  the dictionary must override some default parameters.
 *  @see    init
 *  @param  dict NSDictionary representing a json object
 *  @return NSSharingKit
 */
- (id) initWithDictionary: (NSDictionary *) dict;

/**
 *  init method that initializes with a NSString representing
 *  a json object.
 *  the json must override some default parameters.
 *  @see    init
 *  @param  json NSString representing a json object
 *  @return NSSharingKit
 */
- (id) initWithFile: (NSString *) filePath;

/**
 *  Method to render a view controller in order to present
 *  all sharing networks available.
 *  @return
 */
- (void) renderViewWithDatas: (NSDictionary *) data controller: (UIViewController *) controller;

/**
 *  Method to render a dynamic view controller in order to present
 *  all sharing networks available.
 *  @return
 */
- (void) renderDynamicViewIn:(UIViewController *) controller atPoint: (CGPoint) point WithDatas: (NSDictionary *) datas withConfig: (NSShareMenuConfiguration *) config;


/**
 *  Get a particular network thanks to its id
 *  @param  networkId the id of the network
 *  @return AbstractNetwork
 */
- (AbstractNetwork *)   getNetworkFromId:(NSString *) networkId;

/**
 *  share via a particular network with a NSDictionary that represent
 *  the data to share
 *  @param  networkId id used to identify the network to use
 *  @param  datas   NSDictionary representing the datas to share
 *  @param  controller UIViewController that call the sharing
 */
-(void) shareViaNetwork: (NSString *) networkId withDatas: (NSDictionary *) datas controller: (UIViewController *) controller;

/**
 *  Setter method adding a block to the networks
 *  It is used when sharing is done
 *  @param blockDone
 *  @return void
 */
- (void) setCompletionDone:(CompletionBlock) blockDone;

/**
 *  Setter method adding a block to the networks
 *  It is used when sharing is canceled
 *  @param blockCanceled
 *  @return void
 */
- (void) setCompletionCanceled:(CompletionBlock) blockCanceled;

/**
 *  Setter method adding a block to the networks
 *  It is used when sharing has failed
 *  @param blockFailed
 *  @return void
 */
- (void) setCompletionFailed:(CompletionBlock) blockFailed;

/**
 *  Setter method adding a block to the networks
 *  It is used when sharing is saved (a mail for example)
 *  @param blockSaved
 *  @return void
 */
- (void) setCompletionSaved:(CompletionBlock) blockSaved;

/**
 *  Setter method adding a block to the network identified by
 *  the id.
 *  It is used when sharing is done
 *  @param blockDone
 *  @return void
 */
- (void) setCompletionDone:(CompletionBlock) blockDone networkId: (NSString *) networkId;

/**
 *  Setter method adding a block to the network identified by
 *  the id.
 *  It is used when sharing is canceled
 *  @param blockCanceled
 *  @return void
 */
- (void) setCompletionCanceled:(CompletionBlock) blockCanceled networkId: (NSString *) networkId;

/**
 *  Setter method adding a block to the network identified by
 *  the id.
 *  It is used when sharing has failed
 *  @param blockFailed
 *  @return void
 */
- (void) setCompletionFailed:(CompletionBlock) blockFailed networkId: (NSString *) networkId;

/**
 *  Setter method adding a block to the network identified by
 *  the id.
 *  It is used when sharing is saved (a mail for example)
 *  @param blockSaved
 *  @return void
 */
- (void) setCompletionSaved:(CompletionBlock) blockSaved networkId: (NSString *) networkId;

@end
