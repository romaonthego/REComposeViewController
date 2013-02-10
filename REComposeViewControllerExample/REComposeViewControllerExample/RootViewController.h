//
//  RootViewController.h
//  REComposeViewControllerExample
//
//  Created by Roman Efimov on 10/19/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REComposeViewController.h"

@class TwitterAccountActionSheet;
@interface RootViewController : UIViewController <REComposeViewControllerDelegate>

@property (strong) TwitterAccountActionSheet* currentAccountPicker;
@end
