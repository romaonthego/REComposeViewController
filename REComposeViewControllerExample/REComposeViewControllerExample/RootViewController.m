//
//  RootViewController.m
//  REComposeViewControllerExample
//
//  Created by Roman Efimov on 10/19/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "REComposeViewController.h"
#import "ModalViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"REComposeViewController";
    
    // For iOS 7
    //
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UIButton *socialExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    socialExampleButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0f, 20, 200, 40);
    socialExampleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [socialExampleButton addTarget:self action:@selector(socialExampleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [socialExampleButton setTitle:@"Some social network" forState:UIControlStateNormal];
    [self.view addSubview:socialExampleButton];
    
    UIButton *tumblrExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tumblrExampleButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0f, 70, 200, 40);
    tumblrExampleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [tumblrExampleButton addTarget:self action:@selector(tumblrExampleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [tumblrExampleButton setTitle:@"Tumblr" forState:UIControlStateNormal];
    [self.view addSubview:tumblrExampleButton];
    
    UIButton *foursquareExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    foursquareExampleButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0f, 120, 200, 40);
    foursquareExampleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [foursquareExampleButton addTarget:self action:@selector(foursquareExampleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [foursquareExampleButton setTitle:@"Foursquare" forState:UIControlStateNormal];
    [self.view addSubview:foursquareExampleButton];
    
    UIButton *presentedVCExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    presentedVCExampleButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0f, 170, 200, 40);
    presentedVCExampleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [presentedVCExampleButton addTarget:self action:@selector(presentVCButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [presentedVCExampleButton setTitle:@"Presented ViewController" forState:UIControlStateNormal];
    [self.view addSubview:presentedVCExampleButton];
}

#pragma mark -
#pragma mark Button actions

- (void)socialExampleButtonPressed
{
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.title = @"Social Network";
    composeViewController.hasAttachment = YES;
    composeViewController.delegate = self;
    composeViewController.text = @"Test";
    [composeViewController presentFromRootViewController];
}

- (void)tumblrExampleButtonPressed
{
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.title = @"Tumblr";
    composeViewController.hasAttachment = YES;
    composeViewController.attachmentImage = [UIImage imageNamed:@"Flower.jpg"];
    composeViewController.delegate = self;
    [composeViewController presentFromRootViewController];
}

- (void)foursquareExampleButtonPressed
{
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.hasAttachment = YES;
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foursquare-logo"]];
    titleImageView.frame = CGRectMake(0, 0, 110, 30);
    composeViewController.navigationItem.titleView = titleImageView;
    composeViewController.placeholderText = @"Test";
    
    // UIApperance setup
    //
    if (!REUIKitIsFlatMode()) {
        [composeViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
        composeViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:194/255.0 alpha:1];
        composeViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:29/255.0 green:118/255.0 blue:143/255.0 alpha:1];
    } else {
        composeViewController.navigationBar.tintColor = [UIColor colorWithRed:27/255.0 green:108/255.0 blue:181/255.0 alpha:1.0];
    }
    
    // Alternative use with REComposeViewControllerCompletionHandler
    //
    composeViewController.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
        
        if (result == REComposeResultCancelled) {
            NSLog(@"Cancelled");
        }
        
        if (result == REComposeResultPosted) {
            NSLog(@"Text: %@", composeViewController.text);
        }
    };
    
    [composeViewController presentFromRootViewController];
}

- (void)presentVCButtonPressed
{
    [self presentViewController:[ModalViewController new] animated:YES completion:nil];
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
