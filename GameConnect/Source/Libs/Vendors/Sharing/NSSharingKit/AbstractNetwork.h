//
//  AbstractNetwork.h
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSSharedItem.h"

typedef enum {
    typeDone = 1,
    typeCanceled,
    typeFailed,
    typeSaved
} typeResult;

/**
 * Block definition use for completion
 */
typedef void (^CompletionBlock)();

/**
 *  Abstract Class that describe a global social network
 */
@interface AbstractNetwork : NSObject

/**
 * Controller from where the sharing is called
 */
@property (strong, nonatomic) UIViewController *controller;

/**
 *  The item to share
 */
@property (strong, nonatomic) NSSharedItem *item;

/**
 * Network's name that will appears on view controller for sharing
 */
@property (strong, nonatomic) NSString*   name;

/**
 *  Network's logo that will appears on view controller for sharing
 */
@property (strong, nonatomic) UIImage*    logo;

/**
 * Network's id in order to be selected in a list
 */
@property (strong, nonatomic) NSString*   networkId;

@property (nonatomic) int index;
/**
 *  Abstract method used to call the sharing method of the network
 *  @return  void
 */
- (void) share;

/**
 *  Abstract method used to call the sharing method of the network
 *  with a dictionary for the datas
 *  @param  datas NSDictionary representing datas
 */
- (void) shareWithDatas: (NSDictionary *) datas;

/**
 *  Setter method adding a block to the current object
 *  It is used when sharing is done
 *  @param blockDone
 *  @return void
 */
- (void) setCompletionDone:(CompletionBlock) blockDone;

/**
 *  Setter method adding a block to the current object
 *  It is used when sharing is canceled
 *  @param blockCanceled
 *  @return void
 */
- (void) setCompletionCanceled:(CompletionBlock) blockCanceled;

/**
 *  Setter method adding a block to the current object
 *  It is used when sharing has failed
 *  @param blockFailed
 *  @return void
 */
- (void) setCompletionFailed:(CompletionBlock) blockFailed;

/**
 *  Setter method adding a block to the current object
 *  It is used when sharing is saved (a mail for example)
 *  @param blockSaved
 *  @return void
 */
- (void) setCompletionSaved:(CompletionBlock) blockSaved;

/**
 *  Method in order to call the proper block thanks to result
 *  @param result
 */
- (void) completionResult:(typeResult)result;

@end
