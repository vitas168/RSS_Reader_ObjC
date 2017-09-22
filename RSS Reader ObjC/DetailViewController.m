//
//  DetailViewController.m
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 21/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    [self loadLink];
    
}

// Return to View Controller
- (IBAction)backTapped:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


// Load rss article URL into Web view
-(void) loadLink {
    
    // Check if link was initialized before the web view is loaded
    assert(_linkToLoad != nil);
    
    // Create a URL object instance
    NSURL* url = [[NSURL alloc] initWithString: _linkToLoad];
    
    // Create a request instance
    NSURLRequest* request = [NSURLRequest requestWithURL: url];
    
    // Load the request url
    [_webView loadRequest:request];
    
}


@end
