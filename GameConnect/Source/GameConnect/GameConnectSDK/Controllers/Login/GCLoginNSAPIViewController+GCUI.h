//
//  GCLoginNSAPIViewController+GCUI.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 06/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCLoginNSAPIViewController.h"
#import "NsSnUserManager.h"

@interface GCLoginNSAPIViewController (GCUI)

-(void)initLoginView;
-(void)expandThirdPartyViewContainerFor:(eNsSnThirdPartyConnection)thirdParty;
-(void)resignConnectResponder;

@end
