//
//  GCAPPGameViewControlleriPad.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 21/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCAPPGameViewControlleriPad.h"
#import "GCBluredImageSingleton.h"
#import "GCAPPDefines.h"

@interface GCAPPGameViewControlleriPad ()
@end

@implementation GCAPPGameViewControlleriPad

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
