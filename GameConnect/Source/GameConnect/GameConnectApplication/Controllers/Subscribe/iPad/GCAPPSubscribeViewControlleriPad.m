//
//  GCAPPSubscribeViewControlleriPad.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 4/2/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPSubscribeViewControlleriPad.h"
#import "GCBluredImageSingleton.h"

@interface GCAPPSubscribeViewControlleriPad ()
{
    CGFloat diffBottom;
}
@end

@implementation GCAPPSubscribeViewControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setBluredBackground
{
    [self setBackgroundImage:[UIImage imageNamed:GCAPPBluredBackgroundWithNavbar]];
}

#pragma Keyboard Notifications
- (void)keyboardDidShow: (NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    diffBottom = self.view.frame.size.height - (self.v_containerSubscribe.superview.frame.origin.y + self.v_containerSubscribe.superview.frame.size.height) + (self.v_containerSubscribe.superview.frame.size.height - (self.v_containerSubscribe.frame.origin.y + self.v_containerSubscribe.frame.size.height));
    
    [self.v_containerSubscribe setFrame:CGRectMake(self.v_containerSubscribe.frame.origin.x,
                                                   self.v_containerSubscribe.frame.origin.y,
                                                   self.v_containerSubscribe.frame.size.width,
                                                   self.v_containerSubscribe.frame.size.height - (([[[UIDevice currentDevice]systemVersion]floatValue] >= 8) ? keyboardSize.height : keyboardSize.width) + diffBottom)];
    
    [subscribe.sc_scroll setContentSize:CGSizeMake(subscribe.sc_scroll.frame.size.width, subscribe.v_subscribeContent.frame.origin.y + subscribe.v_subscribeContent.frame.size.height)];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = nil;
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.v_containerSubscribe setFrame:CGRectMake(self.v_containerSubscribe.frame.origin.x, self.v_containerSubscribe.frame.origin.y, self.v_containerSubscribe.frame.size.width, self.v_containerSubscribe.frame.size.height + keyboardSize.width - diffBottom)];
    
    [subscribe.sc_scroll setContentSize:CGSizeMake(subscribe.sc_scroll.frame.size.width, subscribe.v_subscribeContent.frame.origin.y + subscribe.v_subscribeContent.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
