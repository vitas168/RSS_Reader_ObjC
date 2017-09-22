//
//  DetailViewController.h
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 21/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView* webView;
@property (nonatomic) NSString* linkToLoad;

-(IBAction)backTapped:(UIButton *)sender;

-(void) loadLink;

@end
