//
//  REComposeViewController.m
//  REComposeViewControllerExample
//
//  Created by Roman Efimov on 10/19/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "REComposeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface REComposeViewController ()

@end

@implementation REComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cornerRadius = 10;
        _sheetView = [[REComposeSheetView alloc] initWithFrame:CGRectMake(0, 0, self.currentWidth - 8, 202)];
    }
    return self;
}

- (int)currentWidth
{
    UIScreen *screen = [UIScreen mainScreen];
    return (!UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) ? screen.bounds.size.width : screen.bounds.size.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundView = [[REComposeBackgroundView alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.centerOffset = CGSizeMake(0, - self.view.frame.size.height / 2);
    _backgroundView.alpha = 0;
    
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 202)];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _backView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, self.currentWidth - 8, 202)];
    _backView.layer.cornerRadius = _cornerRadius;
    _backView.layer.shadowOpacity = 0.7;
    _backView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backView.layer.shadowOffset = CGSizeMake(3, 5);
    
    _sheetView.frame = _backView.bounds;
    _sheetView.layer.cornerRadius = _cornerRadius;
    _sheetView.clipsToBounds = YES;
    _sheetView.delegate = self;
    
    [self.view addSubview:_backgroundView];
    [_containerView addSubview:_backView];
    [self.view addSubview:_containerView];
    [_backView addSubview:_sheetView];
    
    _paperclipView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 77, 60, 79, 34)];
    _paperclipView.image = [UIImage imageNamed:@"REComposeViewController.bundle/PaperClip"];
    [_containerView addSubview:_paperclipView];
    [_paperclipView setHidden:YES];
    
    if (!_attachmentImage)
        _attachmentImage = [UIImage imageNamed:@"REComposeViewController.bundle/URLAttachment"];
    
    _sheetView.attachmentImageView.image = _attachmentImage;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_sheetView.textView becomeFirstResponder];
    
    [UIView animateWithDuration:0.4 animations:^{
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            [self layoutWithOrientation:self.interfaceOrientation width:self.view.frame.size.height height:self.view.frame.size.width];
        } else {
            [self layoutWithOrientation:self.interfaceOrientation width:self.view.frame.size.width height:self.view.frame.size.height];
        }
    }];
    
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        _backgroundView.alpha = 1;
    } completion:nil];
}

- (void)layoutWithOrientation:(UIInterfaceOrientation)interfaceOrientation width:(NSInteger)width height:(NSInteger)height
{
    NSInteger offset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60 : 4;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGRect frame = _containerView.frame;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            offset *= 2;
        }
        
        NSInteger verticalOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 316 : 216;
        
        NSInteger containerWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? _containerView.frame.size.height : _containerView.frame.size.width;
        frame.origin.y = (width - verticalOffset - containerWidth) / 2;
        if (frame.origin.y < 0) frame.origin.y = 0;
        _containerView.frame = frame;
        
        _containerView.clipsToBounds = YES;
        _backView.frame = CGRectMake(offset, 0, height - offset*2, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 202 : 140);
        _sheetView.frame = _backView.bounds;
        
        CGRect paperclipFrame = _paperclipView.frame;
        paperclipFrame.origin.x = height - 73 - offset;
        _paperclipView.frame = paperclipFrame;
    } else {
        CGRect frame = _containerView.frame;
        frame.origin.y = (height - 216 - _containerView.frame.size.height) / 2;
        if (frame.origin.y < 0) frame.origin.y = 0;
        _containerView.frame = frame;
        _backView.frame = CGRectMake(offset, 0, width - offset*2, 202);
        _sheetView.frame = _backView.bounds;
        
        CGRect paperclipFrame = _paperclipView.frame;
        paperclipFrame.origin.x = width - 73 - offset;
        _paperclipView.frame = paperclipFrame;
    }
    
    _paperclipView.hidden = !_hasAttachment;
    _sheetView.attachmentView.hidden = !_hasAttachment;
    
    [_sheetView.navigationBar sizeToFit];
    
    CGRect attachmentViewFrame = _sheetView.attachmentView.frame;
    attachmentViewFrame.origin.x = _sheetView.frame.size.width - 84;
    attachmentViewFrame.origin.y = _sheetView.navigationBar.frame.size.height + 10;
    _sheetView.attachmentView.frame = attachmentViewFrame;
    
    CGRect textViewFrame = _sheetView.textView.frame;
    textViewFrame.size.width = !_hasAttachment ? _sheetView.frame.size.width : _sheetView.frame.size.width - 84;
    _sheetView.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, _hasAttachment ? -85 : 0);
    textViewFrame.size.height = _sheetView.frame.size.height - _sheetView.navigationBar.frame.size.height - 3;
    _sheetView.textView.frame = textViewFrame;
    
    CGRect textViewContainerFrame = _sheetView.textViewContainer.frame;
    textViewContainerFrame.origin.y = _sheetView.navigationBar.frame.size.height;
    textViewContainerFrame.size.height = _sheetView.frame.size.height - _sheetView.navigationBar.frame.size.height;
    _sheetView.textViewContainer.frame = textViewContainerFrame;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [_sheetView.textView resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _containerView.frame;
        frame.origin.y = self.view.frame.size.height;
        _containerView.frame = frame;
    }];
    
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [super dismissViewControllerAnimated:NO completion:nil];
                     }];
}

#pragma mark -
#pragma mark Accessors

- (UINavigationItem *)navigationItem
{
    return _sheetView.navigationItem;
}

- (UINavigationBar *)navigationBar
{
    return _sheetView.navigationBar;
}

- (UIImage *)attachmentImage
{
    return _attachmentImage;
}

- (void)setAttachmentImage:(UIImage *)attachmentImage
{
    _attachmentImage = attachmentImage;
    _sheetView.attachmentImageView.image = _attachmentImage;
}

- (BOOL)hasAttachment
{
    return _hasAttachment;
}

- (void)setHasAttachment:(BOOL)hasAttachment
{
    _hasAttachment = hasAttachment;
 //   [self layoutWithOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark -
#pragma mark REComposeSheetViewDelegate

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutWithOrientation:interfaceOrientation width:self.view.frame.size.width height:self.view.frame.size.height];
}

@end
