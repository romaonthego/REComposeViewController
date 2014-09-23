//
//  ModalViewController.m
//  REComposeViewControllerExample
//
//  Created by Antol Peshkov on 23.09.14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "ModalViewController.h"
#import "REComposeViewController.h"

@interface ModalViewController () <REComposeViewControllerDelegate>

@end

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *socialExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    socialExampleButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0f, 140, 200, 40);
    socialExampleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [socialExampleButton addTarget:self action:@selector(socialExampleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [socialExampleButton setTitle:@"Some social network" forState:UIControlStateNormal];
    [self.view addSubview:socialExampleButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0f, 170, 200, 40);
    backButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"< Back" forState:UIControlStateNormal];
    [self.view addSubview:backButton];
}

- (void)socialExampleButtonPressed
{
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.title = @"Social Network";
    composeViewController.hasAttachment = YES;
    composeViewController.delegate = self;
    composeViewController.text = @"Test";
    [composeViewController presentFromRootViewController];
}

- (void)backButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark REComposeViewControllerDelegate

- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result
{
    [composeViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (result == REComposeResultCancelled) {
        NSLog(@"Cancelled");
    }
    
    if (result == REComposeResultPosted) {
        NSLog(@"Text: %@", composeViewController.text);
    }
}

@end
