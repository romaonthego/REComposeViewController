//
// REComposeViewController.h
// REComposeViewController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
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

#import <UIKit/UIKit.h>
#import "REComposeSheetView.h"
#import "REComposeBackgroundView.h"

enum REComposeResult {
    REComposeResultCancelled,
    REComposeResultPosted
};
typedef enum REComposeResult REComposeResult;

@class REComposeViewController;

typedef void (^REComposeViewControllerCompletionHandler)(REComposeViewController *composeViewController, REComposeResult result);

@protocol REComposeViewControllerDelegate;

@interface REComposeViewController : UIViewController <REComposeSheetViewDelegate, DEComposeTextViewDelegate, UITextViewDelegate> {
    REComposeSheetView *_sheetView;
    REComposeBackgroundView *_backgroundView;
    UIView *_backView;
    UIView *_containerView;
    UIImageView *_paperclipView;
    BOOL _hasAttachment;
    UIImage *_attachmentImage;
}

- (UINavigationItem *)navigationItem;
- (UINavigationBar *)navigationBar;
- (NSString *)text;
- (void)setText:(NSString *)text;

- (BOOL)hasAttachment;
- (void)setHasAttachment:(BOOL)hasAttachment;

- (UIImage *)attachmentImage;
- (void)setAttachmentImage:(UIImage *)attachmentImage;

- (void) setAccountName: (NSString*) newAccountName;

@property (copy, nonatomic) REComposeViewControllerCompletionHandler completionHandler;
@property (weak, nonatomic) id <REComposeViewControllerDelegate> delegate;
@property (assign, readwrite, nonatomic) NSInteger cornerRadius;

@end

@protocol REComposeViewControllerDelegate <NSObject>

- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result;

@optional
/*
 delegates may implement method. If it is implemented and returns a non-NULL object, activates the From line (which may be used to switch accounts)
 */
- (NSString*) defaultAccountName;

/*
 Delegates that implement the defaultAccountName method must implement this. This
 method is expected to display and let the user pick from the appropriate variety of accounts.
 When the user has selected you should call setAccountName to populate the From line of this view
 controller correctly.
*/
- (void) displayAccountsPicker: (REComposeViewController*) viewController;
@end
