//
//  GCProcessProfileManager.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/3/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"

@protocol GCProcessProfileManagerDelegate <GCProcessManagerDelegate>
@optional
/* Profile */

-(void) GCDidSelectPlayedEvent:(GCEventModel *)playedEvent atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController;

-(void) GCDidSelectElement:(id)dataElement atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController;

-(void) GCDidSelectTrophie:(GCTrophyModel *)trophie atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController;

-(void) GCDidRequestProfileEdition:(GCGamerModel *)gamerModel fromViewController:(UIViewController *)viewController;

-(void) GCShareTrophy:(GCTrophyModel *)trophyModel fromViewController:(GCPushInfoViewController *)pushInfoViewController;

/* Profile Edition */
-(void) GCDidRequestImagePickerFromViewController:(GCProfileEditionViewController *)profileEditionViewController;

-(void) GCDidSaveProfileModicationFromViewController:(GCProfileEditionViewController *)profileEditionViewController;

@end

@interface GCProcessProfileManager : GCProcessManager

@property (weak, nonatomic) id<GCProcessProfileManagerDelegate> delegate;
/* Profile */
-(void) selectItemInPlayedEventList:(GCEventModel *)event atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController;

-(void) selectItemInTrophiesList:(GCTrophyModel *)trophie atIndexPath:(NSIndexPath *)indexPath fromViewController:(GCProfileViewController *)profileViewController;

-(void) requestProfileEdition:(GCGamerModel *)gamerModel fromViewController:(UIViewController *)viewController;

-(void) shareTrophy:(GCTrophyModel *)trophyModel fromViewController:(GCPushInfoViewController *)pushInfoViewController;

/* Profile Edition */
-(void) requestImagePickerFromViewController:(GCProfileEditionViewController *)profileEditionViewController;

-(void) profileEditionSavedFomViewController:(GCProfileEditionViewController *)profileEditionViewController;

@end

