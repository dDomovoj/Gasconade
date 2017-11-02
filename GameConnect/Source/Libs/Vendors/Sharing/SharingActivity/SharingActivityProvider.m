//
// Created by sbeyers on 3/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharingActivityProvider.h"
#import "Extends+Libs.h"

@implementation SharingActivityProvider


- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    NSLog(@"SharingActivityProvider : itemForActivityType => %@", activityType);

    id shareReturn = nil;
    NSString *type = @"";
    
    // customize the sharing string for facebook, twitter, weibo, and google+
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        type = @"facebook";
    }
    else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        type = @"twitter";
    }
    else if ([activityType isEqualToString:UIActivityTypeMail]) {
        type = @"mail";
    }
    else if ([activityType isEqualToString:UIActivityTypeAddToReadingList]) {
        type = @"readingfacebook";
    }
    else if ([activityType isEqualToString:UIActivityTypeAirDrop]) {
        type = @"airdrop";
    }
    else if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
        type = @"copy";
    }
//    else if ([activityType isEqualToString:@"com.captech.googlePlusSharing"]) {
//        shareReturn = [NSString stringWithFormat:@"Attention Google+: %@", shareString];
//    }
    else {
        type = @"default";
    }

    NSDictionary *dic = [self.elementsSharing getXpathNilDictionary:type];
    if (dic){
        NSString *text = [dic getXpathNilString:@"text"];
        NSURL *url = [dic getXpath:@"link" type:[NSURL class] def:nil];
        
        if (text) {
            shareReturn = text;
        }
        if (url) {
            shareReturn = url;
        }
    }

    return shareReturn;
}


- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end
