//
//  REComposeSheetView.h
//  REComposeViewControllerExample
//
//  Created by Roman Efimov on 10/19/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEComposeTextView.h"

@protocol REComposeSheetViewDelegate;

@interface REComposeSheetView : UIView {
    UIImageView *_attachmentContainerView;
}

@property (readonly, nonatomic) UIView *attachmentView;
@property (readonly, nonatomic) UIImageView *attachmentImageView;
@property (weak, readwrite, nonatomic) UIViewController <REComposeSheetViewDelegate> *delegate;
@property (readonly, nonatomic) UINavigationItem *navigationItem;
@property (readonly, nonatomic) UINavigationBar *navigationBar;
@property (readonly, nonatomic) UIView *textViewContainer;
@property (readonly, nonatomic) DEComposeTextView *textView;

@end

@protocol REComposeSheetViewDelegate <NSObject>

- (void)cancelButtonPressed;
- (void)postButtonPressed;

@end