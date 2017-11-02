//
//  MailNetwork.h
//  FbProto
//
//  Created by Mathieu Lanoy on 05/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AbstractNetwork.h"

extern NSString* const MAIL_ID;

@interface MailNetwork : AbstractNetwork<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@end
