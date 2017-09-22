//
//  ViewController.h
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 19/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedModel.h"
#import "Article.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FeedModelDelegate>
{
// Array of web links to rss feeds for fetching content
NSArray* feedLinks;

// Property to hold a selected link
NSString* activeLink;
    
// Array of fetched articles
NSMutableArray* articles;
    
// A dictionary of feed models with feed Url as the key. Used for processing arrays of articles from particular feeds
NSMutableDictionary* feedDictionary;
    
// A refresh control to pull out new data
UIRefreshControl* refreshControl;
}

@property (weak, nonatomic) IBOutlet UITableView* tableView;

-(void) loadData;
-(void) configureRefreshControl;




@end

