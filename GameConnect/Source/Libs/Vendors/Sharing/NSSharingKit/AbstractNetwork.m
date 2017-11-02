//
//  AbstractNetwork.m
//  FbProto
//
//  Created by Mathieu Lanoy on 04/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//
#import <objc/runtime.h>
#import "AbstractNetwork.h"

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define BLOCK_DONE                      @"BlockDone"

#define BLOCK_CANCELED                  @"BlockCanceled"

#define BLOCK_FAILED                    @"BlockFailed"

#define BLOCK_SAVED                     @"BlockSaved"

@implementation AbstractNetwork

@synthesize controller = _controller, item = _item, name = _name, logo = _logo, networkId = _networkId;

#pragma mark METHODS

- (id) init
{
    self = [super init];
    if (self)
    {
        self.index = -1;
    }
    return self;
}
- (void) share
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%@ must be override in a subclass", NSStringFromSelector(_cmd)];
}

- (void) shareWithDatas: (NSDictionary *) datas
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%@ must be override in a subclass", NSStringFromSelector(_cmd)];
}

#pragma mark - BLOCKS

- (void) setCompletionDone:(CompletionBlock)blockDone
{
    objc_setAssociatedObject(self, BLOCK_DONE, blockDone, OBJC_ASSOCIATION_COPY);
}

- (void) setCompletionCanceled:(CompletionBlock)blockCanceled
{
    objc_setAssociatedObject(self, BLOCK_CANCELED, blockCanceled, OBJC_ASSOCIATION_COPY);
}

- (void) setCompletionFailed:(CompletionBlock)blockFailed
{
    objc_setAssociatedObject(self, BLOCK_FAILED, blockFailed, OBJC_ASSOCIATION_COPY);
}

- (void) setCompletionSaved:(CompletionBlock)blockSaved
{
    objc_setAssociatedObject(self, BLOCK_SAVED, blockSaved, OBJC_ASSOCIATION_COPY);
}

#pragma mark - RESULTS

- (void) completionResult:(typeResult)result
{
    switch (result) {
        case typeDone:
            [self done];
            
            break;
        case typeCanceled:
            [self cancelled];
            
            break;
            
        case typeFailed:
            [self failed];
            
            break;
            
        case typeSaved:
            [self saved];
            
            break;
            
        default:
            [self cancelled];
            
            break;
    }
}

- (void) done
{
    CompletionBlock _completionBlock = (CompletionBlock)objc_getAssociatedObject(self, BLOCK_DONE);
    if (_completionBlock != nil)
    {
        _completionBlock();
    }
}

- (void) cancelled
{
    CompletionBlock _canceledBlock = (CompletionBlock)objc_getAssociatedObject(self, BLOCK_CANCELED);
    if (_canceledBlock != nil)
    {
        _canceledBlock();
    }
}

- (void) failed
{
    CompletionBlock _completionBlock = (CompletionBlock)objc_getAssociatedObject(self, BLOCK_FAILED);
    if (_completionBlock != nil)
    {
        _completionBlock();
    }
}

- (void) saved
{
    CompletionBlock _completionBlock = (CompletionBlock)objc_getAssociatedObject(self, BLOCK_SAVED);
    if (_completionBlock != nil)
    {
        _completionBlock();
    }
}

@end
