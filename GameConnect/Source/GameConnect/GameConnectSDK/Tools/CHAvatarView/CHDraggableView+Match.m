//
//  CHDraggableView+Match.m
//
//  Created by Édouard RICHARD on 18.12.13
//  Copyright (c) 2013 Édouard RICHARD. All rights reserved.
//

#import "CHDraggableView+Match.h"
#import "CHMatchView.h"
#import "Extends+Libs.h"
//#import "UINotificationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CHDraggableView (Match)

+ (id)draggableViewWithView:(UIView *)view
{
    CHDraggableView *dragView = [[CHDraggableView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    dragView.tag = 4242;
    view.center = CGPointMake(CGRectGetMidX(dragView.bounds), CGRectGetMidY(dragView.bounds));
    [dragView.layer setCornerRadius:dragView.frame.size.width/2.0];
    [dragView addSubviewToBonce:view];
    [view setFrame:CGRectInset(dragView.bounds, 4, 4)];
    [dragView setNeedsDisplay];
    return dragView;
}

+ (id)draggableViewWithMatch:(NSDictionary *)match
{
    CHDraggableView *view = [[CHDraggableView alloc] initWithFrame:CGRectMake(0, 0, 61, 61)];
//    view.element = match;
    view.tag = [[match getXpathEmptyString:@"uid"] intValue];
//    [view setBackgroundColor:[UIColor redColor]];
    
    CHMatchView *matchView = [[[NSBundle mainBundle] loadNibNamed:@"CHMatchView" owner:nil options:nil] getObjectsType:[CHMatchView class]];
//    CHMatchView *matchView = [[CHMatchView alloc] initWithFrame:CGRectInset(view.bounds, 4, 4)];
    [matchView setMyMatch:match];
    matchView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));

    [view addSubviewToBonce:matchView];

    [matchView setFrame:CGRectInset(view.bounds, 4, 4)];
//    [matchView setBackgroundColor:[UIColor redColor]];
    [matchView.v_content.layer setCornerRadius:(matchView.frame.size.width / 2.0) + 2];
    
//    UINotificationView *notifView =  [[UINotificationView alloc] initWithFrame:CGRectMake(2, -1, 22, 22)] ;
//    [view addSubview:notifView];
//    [notifView setNb:-1];
    
//    view.notifView = notifView;
    
    return view;
}


@end
