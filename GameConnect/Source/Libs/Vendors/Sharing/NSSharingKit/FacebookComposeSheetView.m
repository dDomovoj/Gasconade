//
//  FacebookComposeSheetView.m
//  FbProto
//
//  Created by Mathieu Lanoy on 06/12/12.
//  Copyright (c) 2012 Netcosports. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FacebookComposeSheetView.h"

@interface FacebookComposeSheetView()
{
    UIImageView *_attachmentContainerView;
}

@end

@implementation FacebookComposeSheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleRightMargin;
        
        _navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        _navigationBar.items = @[_navigationItem];
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
        _navigationItem.leftBarButtonItem = cancelButtonItem;
        
        UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Post", @"Post") style:UIBarButtonItemStyleBordered target:self action:@selector(postButtonPressed)];
        _navigationItem.rightBarButtonItem = postButtonItem;
        
        
        _textViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height - 44)];
        _textViewContainer.clipsToBounds = YES;
        _textViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 47)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:21];
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _textView.bounces = YES;
        [_textViewContainer addSubview:_textView];
        [self addSubview:_textViewContainer];
        
        _attachmentView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 84, 54, 84, 79)];
        [self addSubview:_attachmentView];
        
        _attachmentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 2, 72, 72)];
        _attachmentImageView.layer.cornerRadius = 3.0f;
        _attachmentImageView.layer.masksToBounds = YES;
        [_attachmentView addSubview:_attachmentImageView];
        
        _attachmentContainerView = [[UIImageView alloc] initWithFrame:_attachmentView.bounds];
        _attachmentContainerView.image = [UIImage imageNamed:@"NSShareKitResources.bundle/AttachmentFrame"];
        [_attachmentView addSubview:_attachmentContainerView];
        _attachmentView.hidden = YES;
        
        [self addSubview:_navigationBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_delegate) {
        _navigationItem.title = _delegate.title;
    }
}

- (void)cancelButtonPressed
{
    if ([_delegate respondsToSelector:@selector(cancelButtonPressed)])
        [_delegate cancelButtonPressed];
}

- (void)postButtonPressed
{
    if ([_delegate respondsToSelector:@selector(postButtonPressed)])
        [_delegate postButtonPressed];
}

@end
