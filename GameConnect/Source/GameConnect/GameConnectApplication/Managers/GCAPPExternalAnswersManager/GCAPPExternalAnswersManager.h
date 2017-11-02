//
//  GCAPPExternalAnswersManager.h
//  TVA Sports Second Screen
//
//  Created by Guillaume on 06/08/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCAPPExternalAnswersViewController.h"

typedef enum
{
  eGCPlayGameConnect,
  eGCActivateExternalPanel,
    
} eGCExternalActions;

@interface GCAPPExternalAnswersManager : NSObject

@property (weak, nonatomic) UIViewController *applicationRootViewController;

-(GCAPPExternalAnswersViewController *)initializeExternalPanel;

-(void) notifyUserAboutGameConnectWithBlockOnceSelected:(void(^)(eGCExternalActions actionType))completion;

@end
