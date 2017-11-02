//
//  GCProcessEventManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessEventManager.h"
#import "Extends+Libs.h"

@implementation GCProcessEventManager
CREATE_INSTANCE

/* Event */
-(void) selectItemInEventsList:(id)data atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCEventsViewController *)eventsViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    if (!data)
        DLog(@"Data doesn't exist at NSIndexPath %@", [indexPath description]);
    
    BOOL delegateFound = NO;
    if ([data isKindOfClass:[GCEventModel class]])
    {
        
        if ([self.delegate respondsToSelector:@selector(GCDidSelectEvent:atIndexPath:fromViewController:)])
        {
            [self.delegate GCDidSelectEvent:data atIndexPath:indexPath fromViewController:eventsViewController];
            delegateFound = YES;
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(GCDidSelecElement:atIndexPath:fromViewController:)])
        {
            [self.delegate GCDidSelecElement:data atIndexPath:indexPath fromViewController:eventsViewController];
            delegateFound = YES;
        }
    }
    if (delegateFound == NO)
        DLog(@"Delegate<GCEventsViewControllerDelegate> should implement wether didSelectEvent:inCollectionView: or didSelecElement:inCollectionView:");
}
@end
