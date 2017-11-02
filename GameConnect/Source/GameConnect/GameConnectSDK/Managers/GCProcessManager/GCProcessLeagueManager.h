//
//  GCProcessLeagueManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"

#import "GCAPPMasterViewController.h"

/*
 ** GCProcessLeagueManager
 */
@protocol GCProcessLeagueManagerDelegate <GCProcessManagerDelegate>
@optional
/* League */
-(void) GCDidSelectLeague:(GCLeagueModel *)leagueModel fromViewController:(GCLeaguesViewController *)leaguesViewController;

-(void) GCDidRequestLeaguesFrom:(GCMasterViewController *)senderViewController;

/* League Edition */
-(void) GCDidRequestLeagueInvitation:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

-(void) GCDidRequestLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

-(void) GCDidSaveLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCLeagueEditionViewController *)leagueEditionViewController;

-(void) GCDidDeleteLeague:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

-(void) GCDidQuitLeague:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

@end

@interface GCProcessLeagueManager : GCProcessManager

@property (weak, nonatomic) id<GCProcessLeagueManagerDelegate> delegate;
/* League */
-(void) selectItemInLeaguesList:(GCLeagueModel *)leagueModel atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCLeaguesViewController *)leaguesViewController;

-(void) requestLeaguesFromViewController:(GCMasterViewController *)senderViewController;

/* League Edition */
-(void) requestLeagueInvitation:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

-(void) requestLeagueEdition:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

-(void) leagueModifcationSaved:(GCLeagueModel *)leagueModel fromViewController:(GCLeagueEditionViewController *)leagueEditionViewController;

-(void) leagueDeleted:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

-(void) leagueQuit:(GCLeagueModel *)leagueModel fromViewController:(GCAPPMasterViewController *)senderViewController;

@end
