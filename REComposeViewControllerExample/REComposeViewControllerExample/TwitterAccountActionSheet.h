//
//  RWTwitterAccountActionSheet.h
//  REComposeViewControllerExample
//
//  Created by Ryan Wilcox on 2/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A simple ActionSheet that abstracts away the "list and pick the user's Twitter accounts".
 
*/
@interface TwitterAccountActionSheet : NSObject<UIActionSheetDelegate> {
    UIViewController* _parentViewController;
    NSArray* _accountsArray;
}

@property (nonatomic, copy) void (^completionBlock)(NSString* selectedAccountName); // will be called at the end with the username the user picked

- (void) presentFromViewController: (UIViewController*) parentViewController;

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
