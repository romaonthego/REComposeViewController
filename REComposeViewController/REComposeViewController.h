//
//  REComposeViewController.h
//  REComposeViewControllerExample
//
//  Created by Roman Efimov on 10/19/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REComposeSheetView.h"
#import "REComposeBackgroundView.h"

enum REComposeResult {
    REComposeResultCancelled,
    REComposeResultPosted
};
typedef enum REComposeResult REComposeResult;

@protocol REComposeViewControllerDelegate;

@interface REComposeViewController : UIViewController <REComposeSheetViewDelegate> {
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

- (BOOL)hasAttachment;
- (void)setHasAttachment:(BOOL)hasAttachment;

- (UIImage *)attachmentImage;
- (void)setAttachmentImage:(UIImage *)attachmentImage;

@property (weak, nonatomic) id <REComposeViewControllerDelegate> delegate;
@property (assign, readwrite, nonatomic) NSInteger cornerRadius;

@end

@protocol REComposeViewControllerDelegate <NSObject>

- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result;

@end
