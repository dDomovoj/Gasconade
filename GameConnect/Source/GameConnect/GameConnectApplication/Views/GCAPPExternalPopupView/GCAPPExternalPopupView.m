//
//  GCAPPExternalPopupView.m
//  TVA Sports Second Screen
//
//  Created by Guillaume on 19/08/14.
//  Copyright (c) 2014 Netco Sports. All rights reserved.
//

#import "GCAPPExternalPopupView.h"
#import "NSObject+NSObject_Xpath.h"
#import "GCAPPDefines.h"
#import "GCConfManager.h"

@implementation GCAPPExternalPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    { }
    return self;
}

-(void)initFontAndColors
{
    [self.lb_title setFont:CONFFONTBOLDSIZE(19)];
    [self.lb_title setTextColor:CONFCOLORFORKEY(@"external_panel_message_lb")];
    
    [self.lb_message setFont:CONFFONTITALICSIZE(14)];
    [self.lb_message setTextColor:CONFCOLORFORKEY(@"external_panel_message_lb")];
    
    [self.bt_start setTitleColor:CONFCOLORFORKEY(@"external_panel_header_bt") forState:UIControlStateNormal];
    [self.bt_start setBackgroundColor:CONFCOLORFORKEY(@"external_panel_header_bg")];
}

-(void)updatePopupWithData:(NSDictionary *)data
{
    [self initFontAndColors];
    
    NSString *title = [data getXpathEmptyString:@"title"];
    NSString *message = [data getXpathEmptyString:@"message"];
    
    if (message && [message isKindOfClass:[NSString class]])
    {
        [self.lb_title setText:title];
        [self.lb_message setText:message];
    }
    [self.bt_start setTitle:NSLocalizedString(@"gc_play", nil) forState:UIControlStateNormal];
}

- (IBAction)clickOnStart:(id)sender
{
    if (self.callBackClickPopup)
        self.callBackClickPopup();
}

@end
