//
// REComposeSheetView.m
// REComposeViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REComposeSheetView.h"
#import "REComposeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation REComposeSheetView

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
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"REComposeSheetView_Cancel", nil, [NSBundle mainBundle], @"Cancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
        
        UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"REComposeSheetView_Post", nil, [NSBundle mainBundle], @"Post", @"Post") style:REUIKitIsFlatMode() ? UIBarButtonItemStyleDone : UIBarButtonItemStyleBordered target:self action:@selector(postButtonPressed)];
        
        if (!REUIKitIsFlatMode()) {
            _navigationItem.leftBarButtonItem = cancelButtonItem;
            _navigationItem.rightBarButtonItem = postButtonItem;
        } else {
            UIBarButtonItem *leftSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            leftSeperator.width = 5.0;
            UIBarButtonItem *rightSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            rightSeperator.width = 5.0;
            _navigationItem.leftBarButtonItems = @[leftSeperator, cancelButtonItem];
            _navigationItem.rightBarButtonItems = @[rightSeperator, postButtonItem];
        }
        
        
        _textViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width - (REUIKitIsFlatMode() ? 20 : 0), frame.size.height - 44)];
        _textViewContainer.clipsToBounds = YES;
        _textViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textView = [[DEComposeTextView alloc] initWithFrame:CGRectMake(REUIKitIsFlatMode() ? 8 : 0, 0, frame.size.width - 100, frame.size.height - 47)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize: REUIKitIsFlatMode() ? 17 : 21];
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _textView.bounces = YES;
        
        [_textViewContainer addSubview:_textView];
        [self addSubview:_textViewContainer];
        
        _attachmentView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 84, 54, 84, 79)];
        [self addSubview:_attachmentView];
        
        _attachmentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(REUIKitIsFlatMode() ? 2 : 6, 2, 72, 72)];
        if (!REUIKitIsFlatMode()) {
            _attachmentImageView.layer.cornerRadius = 3.0f;
        }
        _attachmentImageView.layer.masksToBounds = YES;
        [_attachmentView addSubview:_attachmentImageView];
        
        _attachmentContainerView = [[UIImageView alloc] initWithFrame:_attachmentView.bounds];
        if (!REUIKitIsFlatMode()) {
            _attachmentContainerView.image = [UIImage imageNamed:@"REComposeViewController.bundle/AttachmentFrame"];
        }
        [_attachmentView addSubview:_attachmentContainerView];
        _attachmentView.hidden = YES;
      
        _attachmentViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attachmentViewButton.frame = _attachmentView.bounds;
        [_attachmentView addSubview:_attachmentViewButton];
    
        [self addSubview:_navigationBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_delegate) {
        UIViewController *delegate = _delegate;
        _navigationItem.title = delegate.title;
    }
}

- (void)cancelButtonPressed
{
    id<REComposeSheetViewDelegate> localDelegate = _delegate;
    if ([localDelegate respondsToSelector:@selector(cancelButtonPressed)])
        [localDelegate cancelButtonPressed];
}

- (void)postButtonPressed
{
    id<REComposeSheetViewDelegate> localDelegate = _delegate;
    if ([localDelegate respondsToSelector:@selector(postButtonPressed)])
        [localDelegate postButtonPressed];
}

@end
