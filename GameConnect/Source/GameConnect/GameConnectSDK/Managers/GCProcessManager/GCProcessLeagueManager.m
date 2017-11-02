//
//  GCProcessLeagueManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessLeagueManager.h"
#import "Extends+Libs.h"

@implementation GCProcessLeagueManager
CREATE_INSTANCE

/* League */
-(void) selectItemInLeaguesList:(GCLeagueModel *)leagueModel atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCLeaguesViewController *)leaguesViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if (!leagueModel || ![leagueModel isKindOfClass:[GCLeagueModel class]])
        DLog(@"LeagueModel is not correct !");
    
    if ([self.delegate respondsToSelector:@selector(GCDidSelectLeague:fromViewController:)])
        [self.delegate GCDidSelectLeague:leagueModel fromViewController:leaguesViewController];
}

-(void) requestLeaguesFromViewController:(GCMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestLeaguesFrom:)])
        [self.delegate GCDidRequestLeaguesFrom:senderViewController];
}

/* League Edition */
-(void) requestLeagueInvitation:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestLeagueInvitation:fromViewController:)])
        [self.delegate GCDidRequestLeagueInvitation:leagueModel fromViewController:senderViewController];
}

-(void) requestLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidRequestLeagueEdition:fromViewController:)])
        [self.delegate GCDidRequestLeagueEdition:leagueModel fromViewController:senderViewController];
}

-(void) leagueDeleted:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;

    if ([self.delegate respondsToSelector:@selector(GCDidDeleteLeague:fromViewController:)])
    {
        [self.delegate GCDidDeleteLeague:leagueModel fromViewController:senderViewController];
    }
}

-(void) leagueQuit:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidQuitLeague:fromViewController:)])
    {
        [self.delegate GCDidQuitLeague:leagueModel fromViewController:senderViewController];
    }
}

-(void) leagueModifcationSaved:(GCLeagueModel *)leagueModel fromViewController:(GCLeagueEditionViewController *)leagueEditionViewController
{
    if (![self checkDelegate:self.delegate])
        return ;
    
    if ([self.delegate respondsToSelector:@selector(GCDidSaveLeagueEdition:fromViewController:)])
        [self.delegate GCDidSaveLeagueEdition:leagueModel fromViewController:leagueEditionViewController];
}
@end
