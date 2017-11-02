//
//  GCInvitationFriendRender.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 18/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCInvitationGroupRender.h"
#import "Extends+Libs.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@interface GCInvitationGroupRender()
{
    UIViewController *myParentViewController;
}
-(IBAction)clickOnInvite:(id)sender;
@end

@implementation GCInvitationGroupRender

/*
 ** SetCell - Render
 */
-(void)setFontsAndColors
{
    [self.lb_friendName setFont:CONFFONTSIZE(21)];
    [self.lb_friendName setTextColor:CONFCOLORFORKEY(@"friends_name_lb")];
    
    [self.bt_invitation setBackgroundColor:CONFCOLORFORKEY(@"friends_invite_bg")];
    [self.bt_invitation setTitleColor:CONFCOLORFORKEY(@"friends_invite_bt") forState:UIControlStateNormal];
    [self.bt_invitation setTitle:NSLocalizedString(@"gc_invite", nil) forState:UIControlStateNormal];
    
    [self.iv_friendAvatar.layer setCornerRadius:self.iv_friendAvatar.frame.size.width/2];

    [self.v_borderAvatar.layer setCornerRadius:self.v_borderAvatar.frame.size.width/2];
    [self.v_borderAvatar setBackgroundColor:CONFCOLORFORKEY(@"avatar_border_bg")];
}

-(void)setCell:(id)elt vc:(UIViewController*)parentViewController indexPath:(NSIndexPath*)indexPath
{
    myParentViewController = parentViewController;
    if (elt && [elt isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *friend = elt;
        
        [self.lb_friendName setText:[SWF(@"%@ %@", [friend getXpathEmptyString:@"first_name"], [friend getXpathEmptyString:@"last_name"]) capitalizedString]];
        
        
       NSString *urlAvatarFacebook = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d", [elt getXpathEmptyString:@"id"], 300, 300];
        
        [self.v_borderAvatar startLoader];
        [self.iv_friendAvatar loadImageFromURL:urlAvatarFacebook ttl:[[[GCConfManager getInstance] getValue:GCConfigValueImageTTL] intValue] endblock:^(UIImageViewJA *image) {
            [self.v_borderAvatar stopLoader];
        }];
    }
    [self setFontsAndColors];
}

#pragma IIRenderGG Protocol
+(UICollectionReusableView *) getCell:(UICollectionReusableView *)cell forData:(id)dataElement indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView *)collectionView parentViewController:(UIViewController*)parentViewController
{
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:[GCInvitationGroupRender getIdentifierCell] owner:nil options:nil] getObjectsType:[GCInvitationGroupRender class]];
    
    [((GCInvitationGroupRender*)cell) setCell:dataElement vc:parentViewController indexPath:(NSIndexPath*)indexPath];
	return cell;
}

+(NSString *) getIdentifierCell
{
    return @"GCInvitationGroupRender";
}

- (IBAction)clickOnInvite:(id)sender
{
}

+(CGSize) getSizeCellforData:(id)elt indexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView
{
    return CGSizeMake(collectionView.frame.size.width, 62);
}


@end
