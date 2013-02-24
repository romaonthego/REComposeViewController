//
//  RWTwitterAccountActionSheet.m
//  REComposeViewControllerExample
//
//  Created by Ryan Wilcox on 2/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "TwitterAccountActionSheet.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@implementation TwitterAccountActionSheet

- (void) presentFromViewController: (UIViewController*) parentViewController {
    _parentViewController = parentViewController;
     ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        // Get the list of Twitter accounts.
        _accountsArray = [accountStore accountsWithAccountType:accountType];
        
        [self performSelectorOnMainThread:@selector(populateSheetAndShow:) withObject:_accountsArray waitUntilDone:NO];
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ACAccount* account = [_accountsArray objectAtIndex:buttonIndex];
    
    if (self.completionBlock)
        self.completionBlock(account.username);
}


#pragma mark - Private methods

-(void)populateSheetAndShow:(NSArray *) accountsArray {
    NSMutableArray *buttonsArray = [NSMutableArray array];
    [accountsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [buttonsArray addObject:((ACAccount*)obj).username];
    }];
    
    
    NSLog(@"%@", buttonsArray);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for( NSString *title in buttonsArray)
        [actionSheet addButtonWithTitle:title];
    actionSheet.title = @"Twitter Accounts";
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1;
    [actionSheet showInView:_parentViewController.view];
}

@end
