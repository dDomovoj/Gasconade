//
//  MailNetwork.m
//  FbProto
//
//  Created by Mathieu Lanoy on 05/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//

#import "MailNetwork.h"
#import "AbstractNetwork.h"

NSString* const MAIL_ID = @"mail";


@implementation MailNetwork

- (void) share
{
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        NSAssert(self.controller, @"ViewController must not be nil.");
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        if (self.item.title && [self.item.title length] > 0)
        {
            [controller setSubject:self.item.title];
        }
        if (self.item.recipient && [self.item.recipient length] > 0)
        {
            [controller setToRecipients:[NSArray arrayWithObject:self.item.recipient]];
        }
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
        if (self.item.image_url && [self.item.image_url length] > 0)
        {
            [emailBody appendString:[NSString stringWithFormat:@"<img src='%@' />", self.item.image_url]];
        }
        if (self.item.desc  && [self.item.desc length] > 0)
        {
            [emailBody appendString:[NSString stringWithFormat:@"<p>%@</p>", self.item.desc]];
        }
        if (self.item.url)
        {
            [emailBody appendString:[NSString stringWithFormat:@"<p><a href='%@'>%@</a></p>", self.item.url, self.item.url]];
        }
        [emailBody appendString:@"</body></html>"];
        
        if (self.item.image)
        {
            NSData *data = UIImagePNGRepresentation(self.item.image);
            [controller addAttachmentData:data mimeType:@"image/png" fileName:@"image"];
        }

        [controller setMessageBody:emailBody isHTML:YES];
        
        if (controller)
        {
            [self.controller presentViewController:controller animated:YES completion:nil];
        }
    }
    else
    {
        NSString *deviceType = [UIDevice currentDevice].model;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Your %@ must have an email account set up", @""), deviceType]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)mailController  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultSent:
            [self completionResult:typeDone];
            
            break;
            
        case MFMailComposeResultCancelled:
            [self completionResult:typeCanceled];
            
            break;
            
        case MFMailComposeResultFailed:
            [self completionResult:typeFailed];
            
            break;
            
        case MFMailComposeResultSaved:
            [self completionResult:typeSaved];
            
            break;
            
        default:
            break;
    }
    
    [mailController dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
