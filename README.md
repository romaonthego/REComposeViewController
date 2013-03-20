# REComposeViewController with Image Picking support

Replicates functionality of SLComposeViewController introduced in iOS 6.0. You can create composers for any social network out there. REComposeViewController doesn't provide logic for sharing, only its visual part.

![Screenshot of REComposeViewController](https://github.com/romaonthego/REComposeViewController/raw/master/Screenshot.png "REComposeViewController Screenshot")

## Requirements
* Xcode 4.5 or higher
* Apple LLVM compiler
* iOS 5.0 or higher
* ARC

## Demo

Build and run the `REComposeViewControllerExample` project in Xcode to see `REComposeViewController` in action.

## Installation

### via CocoaPods

The recommended approach for installating REComposeViewController is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Edit your Podfile and add REComposeViewController:

``` bash
$ edit Podfile
platform :ios, '5.0'
pod 'REComposeViewController', '~> 2.0'
```

Install into your Xcode project:

``` bash
$ pod install
```

### Simple Install

All you need to do is drop `REComposeViewController` files into your project, and add `#include "REComposeViewController.h"` to the top of classes that will use it.

## Example Usage

``` objective-c
REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
composeViewController.title = @"Social Network";
composeViewController.hasAttachment = YES;
// preattach image or let the user pick one.
// composeViewController.attachmentImage = [UIImage imageNamed:@"Flower.jpg"];
composeViewController.text = @"Hi there!";
[composeViewController presentFromRootViewController];
```

Set completion handler:

``` objective-c
composeViewController.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
    [composeViewController dismissViewControllerAnimated:YES completion:nil];

    if (result == REComposeResultCancelled) {
        NSLog(@"Cancelled");
    }

    if (result == REComposeResultPosted) {
        NSLog(@"Text = %@", composeViewController.text);
        NSLog(@"Image = %@", composeViewController.attachmentImage);
    }
};
```

Alternatively, you may want to set your controller to conform to `REComposeViewControllerDelegate` protocol to receive notifications when user cancels / posts.

``` objective-c
...
composeViewController.delegate = self;
...
```


``` objective-c
- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result
{
    [composeViewController dismissViewControllerAnimated:YES completion:nil];

    if (result == REComposeResultCancelled) {
        NSLog(@"Cancelled");
    }

    if (result == REComposeResultPosted) {
        NSLog(@"Text = %@", composeViewController.text);
        NSLog(@"Image = %@", composeViewController.attachmentImage);
    }
}
```

## Customization

REComposeViewController navigation bar can be customized via [UIAppearance](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIAppearance_Protocol/Reference/Reference.html). You use the `UIAppearance` protocol to get the appearance proxy for a class. You customize the appearance of instances of a class by sending appearance modification messages to the class’s appearance proxy.

Example:
``` objective-c
[composeViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
composeViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:194/255.0 alpha:1];
composeViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:29/255.0 green:118/255.0 blue:143/255.0 alpha:1];
```

## Credits

Partially based on [DEFacebookComposeViewController](https://github.com/sakrist/FacebookSample) and [DETweetComposeViewController](https://github.com/doubleencore/DETweetComposeViewController).

## Contact

Roman Efimov

- https://github.com/romaonthego
- https://twitter.com/romaonthego
- romefimov@gmail.com

## License

REComposeViewController is available under the MIT license.

Copyright © 2013 Roman Efimov.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
