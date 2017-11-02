//
//  GCAPPLeagueRankingsViewController+GCAPPUI.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPLeagueRankingsViewController+GCAPPUI.h"

@implementation GCAPPLeagueRankingsViewController (GCAPPUI)

-(void)setUpNavbarButton
{
    if (isLeagueOwner)
    {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"modify_league_icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickModifyLeague:)];
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

-(void)clickModifyLeague:(id)sender
{
    [self showOptionsOnLeague];
}

-(void)showOptionsOnLeague
{
    if (isLeagueOwner)
    {
        [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"gc_options", nil)
                                 delegate:self
                        cancelButtonTitle:NSLocalizedString(@"gc_cancel", nil)
                   destructiveButtonTitle:NSLocalizedString(@"gc_delete", nil)
                        otherButtonTitles:NSLocalizedString(@"gc_modify", nil), NSLocalizedString(@"gc_add_people", nil), nil]
         showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        return ; // Waiting for GAMECONNECT PLATFORM to implement it!
        [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"gc_options", nil)
                                     delegate:self
                            cancelButtonTitle:NSLocalizedString(@"gc_cancel", nil)
                       destructiveButtonTitle:NSLocalizedString(@"gc_quit", nil)
                            otherButtonTitles:nil]
         showInView:[UIApplication sharedApplication].keyWindow];
    }
}


#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex)
    {
        if (isLeagueOwner)
        {
            if (buttonIndex == 0)
            {
                // DELETE
                UIAlertView *alertConfirmDeletion = [[UIAlertView alloc] initWithTitle:nil
                                                                               message:NSLocalizedString(@"gc_confirm_delete_league", nil)
                                                                              delegate:self
                                                                     cancelButtonTitle:NSLocalizedString(@"gc_popup_no", nil) otherButtonTitles:NSLocalizedString(@"gc_popup_yes", nil), nil];
                alertConfirmDeletion.tag = 4242;
                [alertConfirmDeletion show];
            }
            else if (buttonIndex == 1)
                [self goToLeagueEdition];
            else if (buttonIndex == 2)
                [self goToLeagueInvitation];
        }
        else
        {
            return ; // Waiting for GAMECONNECT PLATFORM to implement it!
            if (buttonIndex == 0)
            {
                // Quit
                UIAlertView *alertConfirmQuitting = [[UIAlertView alloc] initWithTitle:nil
                                                                               message:NSLocalizedString(@"gc_confirm_quit_league", nil)
                                                                              delegate:self
                                                                     cancelButtonTitle:NSLocalizedString(@"gc_popup_no", nil)otherButtonTitles:NSLocalizedString(@"gc_popup_yes", nil), nil];
                alertConfirmQuitting.tag = 2323;
                [alertConfirmQuitting show];
            }
        }
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == 4242) // Delete
            [self deleteLeague];
        else if (alertView.tag == 2323) // Quit
            [self quitLeague];
    }
}

@end
