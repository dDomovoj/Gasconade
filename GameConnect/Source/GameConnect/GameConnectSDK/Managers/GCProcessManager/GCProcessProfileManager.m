//
//  GCProcessProfileManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessProfileManager.h"
#import "Extends+Libs.h"

@implementation GCProcessProfileManager
CREATE_INSTANCE

/* Profile */

-(void) selectItemInPlayedEventList:(id)data atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
    if (![self checkDelegate:self.delegate])
        return ;

    if (!data)
    {
        DLog(@"Data doesn't exist at NSIndexPath %@", [indexPath description]);
    }
    
    if ([data isKindOfClass:[GCEventModel class]])
    {
        if ([self.delegate respondsToSelector:@selector(GCDidSelectPlayedEvent:atIndexPath:fromViewController:)])
                [self.delegate GCDidSelectPlayedEvent:data atIndexPath:indexPath fromViewController:profileViewController];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(GCDidSelectElement:atIndexPath:fromViewController:)])
            [self.delegate GCDidSelectElement:data atIndexPath:indexPath fromViewController:profileViewController];
    }
}



-(void) selectItemInTrophiesList:(GCTrophyModel *)trophie atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    if (!trophie || ![trophie isKindOfClass:[GCTrophyModel class]])
        DLog(@"Trophie doesn't exist at NSIndexPath %@", [indexPath description]);
    
    
    if ([self.delegate respondsToSelector:@selector(GCDidSelectTrophie:atIndexPath:fromViewController:)])
        [self.delegate GCDidSelectTrophie:trophie atIndexPath:indexPath fromViewController:profileViewController];
}

-(void) shareTrophy:(GCTrophyModel *)trophyModel fromViewController:(GCPushInfoViewController *)pushInfoViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!trophyModel || ![trophyModel isKindOfClass:[GCTrophyModel class]])
        DLog(@"TrophyModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCShareTrophy:fromViewController:)])
        [self.delegate GCShareTrophy:trophyModel fromViewController:pushInfoViewController];
    
}

/* Profile Edition */
-(void) requestProfileEdition:(GCGamerModel *)gamerModel fromViewController:(UIViewController *)viewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    if (!gamerModel || ![gamerModel isKindOfClass:[GCGamerModel class]])
    {
        DLog(@"UserModel doesn't exist!");
    }
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestProfileEdition:fromViewController:)])
        [self.delegate GCDidRequestProfileEdition:gamerModel fromViewController:viewController];
}

-(void) requestImagePickerFromViewController:(GCProfileEditionViewController *)profileEditionViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestImagePickerFromViewController:)])
        [self.delegate GCDidRequestImagePickerFromViewController:profileEditionViewController];
}

-(void) profileEditionSavedFomViewController:(GCProfileEditionViewController *)profileEditionViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GCDidSaveProfileModicationFromViewController:)])
        [self.delegate GCDidSaveProfileModicationFromViewController:profileEditionViewController];
}


@end
