//
//  GCProcessManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/31/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCProcessManager.h"
#import "Extends+Libs.h"

@implementation GCProcessManager
CREATE_INSTANCE

-(BOOL) checkDelegate:(id)delegate
{
    if (!delegate)
    {
        DLog(@"Delegate doesn't exist !");
        return NO;
    }
    return YES;
}

@end


///* Cancellation */
//-(void) cancelAuthentificationFrom:(GCMasterViewController *)masterViewController
//{
//    if (![self checkDelegate])
//        return ;
//    
//    if ([self.delegate respondsToSelector:@selector(GCDidCancelAuthentificationFrom:)])
//        [self.delegate GCDidCancelAuthentificationFrom:masterViewController];
//}
//
//-(void) cancelAnswerFromViewController:(GCAnswersViewController *)answerViewController
//{
//    if (![self checkDelegate])
//        return ;
//    
//    if ([self.delegate respondsToSelector:@selector(GCDidCancelAnswerFrom:)])
//        [self.delegate GCDidCancelAnswerFrom:answerViewController];
//}
//
//-(void) cancelBadgeFromViewController:(GCBadgesViewController *)badgeViewController
//{
//    if (![self checkDelegate])
//        return ;
//
//    if ([self.delegate respondsToSelector:@selector(GCDidCancelBadgeFrom:)])
//        [self.delegate GCDidCancelBadgeFrom:badgeViewController];
//}
