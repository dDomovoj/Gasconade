//
//  GCProcessAuthentificationManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessAuthentificationManager.h"

@implementation GCProcessAuthentificationManager
CREATE_INSTANCE

/* Connect */
-(void) requestAuthentificationFrom:(GCConnectViewController *)connectViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestAuthentificationFrom:)])
        [self.delegate GCDidRequestAuthentificationFrom:connectViewController];
}

-(void) requestSubscribeFrom:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestSubscribeFrom:)])
        [self.delegate GCDidRequestSubscribeFrom:senderViewController];
}

-(void) endAuthentificationFrom:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidEndAuthentificationFrom:)])
        [self.delegate GCDidEndAuthentificationFrom:senderViewController];
}

@end
