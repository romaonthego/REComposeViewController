//
//  RootViewController.m
//  REComposeViewControllerExample
//
//  Created by Roman Efimov on 10/19/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "REComposeViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    UIButton *socialExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    socialExampleButton.frame = CGRectMake(60, 10, 200, 40);
    [socialExampleButton addTarget:self action:@selector(socialExampleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [socialExampleButton setTitle:@"Some social network" forState:UIControlStateNormal];
    [self.view addSubview:socialExampleButton];
    
    UIButton *tumblrExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tumblrExampleButton.frame = CGRectMake(60, 60, 200, 40);
    [tumblrExampleButton addTarget:self action:@selector(tumblrExampleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [tumblrExampleButton setTitle:@"Tumblr" forState:UIControlStateNormal];
    [self.view addSubview:tumblrExampleButton];
    
    UIButton *foursquareExampleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    foursquareExampleButton.frame = CGRectMake(60, 110, 200, 40);
    [foursquareExampleButton addTarget:self action:@selector(foursquareExampleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [foursquareExampleButton setTitle:@"Foursquare" forState:UIControlStateNormal];
    [self.view addSubview:foursquareExampleButton];
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
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (void)tumblrExampleButtonPressed
{
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.title = @"Tumblr";
    composeViewController.hasAttachment = YES;
    composeViewController.attachmentImage = [UIImage imageNamed:@"Flower.jpg"];
    composeViewController.delegate = self;
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (void)foursquareExampleButtonPressed
{
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.hasAttachment = YES;
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foursquare-logo"]];
    titleImageView.frame = CGRectMake(0, 0, 110, 30);
    composeViewController.navigationItem.titleView = titleImageView;
    
    // UIApperance setup
    
    [composeViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    composeViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:194/255.0 alpha:1];
    composeViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:29/255.0 green:118/255.0 blue:143/255.0 alpha:1];
    
    // Alternate use with REComposeViewControllerCompletionHandler
    composeViewController.completionHandler = ^(REComposeResult result) {
        if (result == REComposeResultCancelled) {
            NSLog(@"Cancelled");
        }
        
        if (result == REComposeResultPosted) {
            NSLog(@"Text = %@", composeViewController.text);
        }
    };
    
    [self presentViewController:composeViewController animated:YES completion:nil];
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
    if (result == REComposeResultCancelled) {
        NSLog(@"Cancelled");
    }
    
    if (result == REComposeResultPosted) {
        NSLog(@"Text = %@", composeViewController.text);
    }
}

@end
