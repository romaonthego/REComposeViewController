//
// REComposeViewController.m
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

#import "REComposeViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kSheetViewWidthPad 400
#define kSheetViewWidthPhoneLandscape 472
#define kSheetViewWidthPhonePortrait 312

#define kSheetViewHeightPhone 202
#define kSheetViewHeightPad 300

#define kContainerVerticalOffsetPadLandscape 316
#define kContainerVerticalOffsetPhoneLandscape 216

#define kContainerVerticalOffsetPadPortrait 416
#define kContainerVerticalOffsetPhonePortrait 216

#define kPaperClipIntersect 73

#define isPortrait [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown


@interface REComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/**
 gray view that obscures back view
 */
@property (strong, readonly, nonatomic) REComposeBackgroundView *backgroundView;

/**
 horisontal screen-width view determine position and height of dialog view
 */
@property (strong, readonly, nonatomic) UIView *containerView;

/**
 dialog view inside _backView(determine width and origin.x)
 */
@property (strong, readonly, nonatomic) REComposeSheetView *sheetView;
@property (assign, readwrite, nonatomic) BOOL userUpdatedAttachment;
@property (assign, readwrite, nonatomic) REComposeResult result;

@end

@implementation REComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cornerRadius = (REUIKitIsFlatMode()) ? 6 : 10;
        NSInteger sheetWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kSheetViewWidthPad : UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? kSheetViewWidthPhoneLandscape : kSheetViewWidthPhonePortrait;
        _sheetView = [[REComposeSheetView alloc] initWithFrame:CGRectMake(0, 0, sheetWidth, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kSheetViewHeightPad : kSheetViewHeightPhone)];
        self.tintColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    }
    return self;
}

- (int)currentWidth
{
    UIScreen *screen = [UIScreen mainScreen];
    return (!UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) ? screen.bounds.size.width : screen.bounds.size.height;
}

- (void)loadView
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.view = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger sheetWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kSheetViewWidthPad : UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? kSheetViewWidthPhoneLandscape : kSheetViewWidthPhonePortrait;
    NSInteger sheetHeight = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kSheetViewHeightPad : kSheetViewHeightPhone;
    
    _backgroundView = [[REComposeBackgroundView alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.centerOffset = CGSizeMake(0, - self.view.frame.size.height / 2);
    _backgroundView.alpha = 0;
    if (REUIKitIsFlatMode()) {
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    [self.view addSubview:_backgroundView];

    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, sheetHeight)];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sheetWidth, sheetHeight)];
    _backView.center = CGPointMake(_containerView.frame.size.width / 2, _containerView.frame.size.height / 2);
    _backView.layer.cornerRadius = _cornerRadius;
    if (!REUIKitIsFlatMode()) {
        [self setShadowForView:_backView];
    }
    _backView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    _sheetView.frame = _backView.bounds;
    _sheetView.layer.cornerRadius = _cornerRadius;
    _sheetView.clipsToBounds = YES;
    _sheetView.delegate = self;
    if (REUIKitIsFlatMode()) {
        _sheetView.backgroundColor = self.tintColor;
    }
    
    [_backView addSubview:_sheetView];
    [_containerView addSubview:_backView];
    [self.view addSubview:_containerView];
    
    
    if (!REUIKitIsFlatMode()) {
        [self setPaperClip];
    }
        
    if (!_attachmentImage)
        _attachmentImage = [UIImage imageNamed:@"REComposeViewController.bundle/URLAttachment"];
    
    _sheetView.attachmentImageView.image = _attachmentImage;
    [_sheetView.attachmentViewButton addTarget:self
                                        action:@selector(didTapAttachmentView:)
                              forControlEvents:UIControlEventTouchUpInside];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];

    _backgroundView.frame = _rootViewController.view.bounds;
    
    if (REUIKitIsFlatMode()) {
        [self layoutWithOrientation:self.interfaceOrientation width:self.view.frame.size.width height:self.view.frame.size.height];
        self.containerView.alpha = 0;
        [self.sheetView.textView becomeFirstResponder];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            [self.sheetView.textView becomeFirstResponder];
            [self layoutWithOrientation:self.interfaceOrientation width:self.view.frame.size.width height:self.view.frame.size.height];
        }];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        if (REUIKitIsFlatMode()) {
                            self.containerView.alpha = 1;
                        }
                        self.backgroundView.alpha = 1;
    } completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];

}

- (void)setShadowForView:(UIView *)view{
    view.layer.shadowOpacity = 0.7;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(3, 5);
    view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) cornerRadius:_cornerRadius].CGPath;
    view.layer.shouldRasterize = YES;
}

- (void)setPaperClip{
        _paperclipView = [[UIImageView alloc] initWithFrame:CGRectMake(_sheetView.frame.size.width + _backView.frame.origin.x - kPaperClipIntersect, 60, 79, 34)];
        _paperclipView.image = [UIImage imageNamed:@"REComposeViewController.bundle/PaperClip"];
        [_containerView addSubview:_paperclipView];
        [_paperclipView setHidden:YES];
}

- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    _rootViewController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)layoutWithOrientation:(UIInterfaceOrientation)interfaceOrientation width:(NSInteger)width height:(NSInteger)height
{
    NSInteger sheetWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kSheetViewWidthPad : UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? kSheetViewWidthPhoneLandscape : kSheetViewWidthPhonePortrait;
    NSInteger sheetHeight = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kSheetViewHeightPad : kSheetViewHeightPhone;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGRect frame = _containerView.frame;
        
        NSInteger verticalOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kContainerVerticalOffsetPadLandscape : kContainerVerticalOffsetPhoneLandscape;
        
        frame.origin.y = height - verticalOffset - sheetHeight;
        if (frame.origin.y < 20) frame.origin.y = 20;
        _containerView.frame = frame;
        
        _containerView.clipsToBounds = YES;
    } else {
        CGRect frame = _containerView.frame;
        
        NSInteger verticalOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kContainerVerticalOffsetPadPortrait : kContainerVerticalOffsetPhonePortrait;
        
        frame.origin.y = height - verticalOffset - sheetHeight;
        if (frame.origin.y < 20) frame.origin.y = 20;
        _containerView.frame = frame;
    }
    
    if (!REUIKitIsFlatMode()) {
        [self setPaperClip];
    }
    
    _backView.center = CGPointMake(self.view.center.x, _backView.center.y);
    _sheetView.frame = _backView.bounds;

    
    _paperclipView.hidden = !_hasAttachment;
    _sheetView.attachmentView.hidden = !_hasAttachment;
    
    [_sheetView.navigationBar sizeToFit];
    
    if (!REUIKitIsFlatMode()) {
        [self setShadowForView:_backView];
    }
    
    CGRect attachmentViewFrame = _sheetView.attachmentView.frame;
    attachmentViewFrame.origin.x = _sheetView.frame.size.width - 84;
    attachmentViewFrame.origin.y = _sheetView.navigationBar.frame.size.height + 10;
    _sheetView.attachmentView.frame = attachmentViewFrame;
    
    CGRect textViewFrame = _sheetView.textView.frame;
    textViewFrame.size.width = !_hasAttachment ? _sheetView.textViewContainer.frame.size.width : _sheetView.textViewContainer.frame.size.width - 84;
    textViewFrame.size.width -= REUIKitIsFlatMode() ? 14 : 0;
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
    __typeof(&*self) __weak weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (REUIKitIsFlatMode()) {
          if (_result == REComposeResultPosted) {
//            facebook and twitter style in iOS7
            CGRect frame = weakSelf.containerView.frame;
            frame.origin.y = 0 - weakSelf.containerView.frame.size.height;
            weakSelf.containerView.frame = frame;
          }
          self.containerView.alpha = 0;
        } else {
            CGRect frame = weakSelf.containerView.frame;
            frame.origin.y =  weakSelf.rootViewController.view.frame.size.height;
            weakSelf.containerView.frame = frame;
        }
    }];
    
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.backgroundView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [weakSelf.view removeFromSuperview];
                         [weakSelf removeFromParentViewController];
                         if (completion)
                             completion();
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

- (void)setAttachmentImage:(UIImage *)attachmentImage
{
    _attachmentImage = attachmentImage;
    _sheetView.attachmentImageView.image = _attachmentImage;
}

- (NSString *)text
{
    return _sheetView.textView.text;
}

- (void)setText:(NSString *)text
{
    _sheetView.textView.text = text;
}

- (NSString *)placeholderText
{
    return _sheetView.textView.placeholder;
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _sheetView.textView.placeholder = placeholderText;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.sheetView.backgroundColor = tintColor;
}

#pragma mark -
#pragma mark REComposeSheetViewDelegate

- (void)cancelButtonPressed
{
    _result = REComposeResultCancelled;
    id<REComposeViewControllerDelegate> localDelegate = _delegate;
    if (localDelegate && [localDelegate respondsToSelector:@selector(composeViewController:didFinishWithResult:)]) {
        [localDelegate composeViewController:self didFinishWithResult:REComposeResultCancelled];
    }
    if (_completionHandler)
        _completionHandler(self, REComposeResultCancelled);
}

- (void)postButtonPressed
{
    _result = REComposeResultPosted;
    id<REComposeViewControllerDelegate> localDelegate = _delegate;
    if (localDelegate && [localDelegate respondsToSelector:@selector(composeViewController:didFinishWithResult:)]) {
        [localDelegate composeViewController:self didFinishWithResult:REComposeResultPosted];
    }
    if (_completionHandler)
        _completionHandler(self, REComposeResultPosted);
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)didTapAttachmentView:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // If our device has a cmera, we want to take a picture, otherwise we just pick from the library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }

    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self setAttachmentImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    self.userUpdatedAttachment = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.sheetView.textView becomeFirstResponder];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.sheetView.textView becomeFirstResponder];
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

- (void)viewOrientationDidChanged:(NSNotification *)notification
{
    [self layoutWithOrientation:self.interfaceOrientation width:self.view.frame.size.width height:self.view.frame.size.height];
}

@end
