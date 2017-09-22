//
//  ViewController.m
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 19/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

#define IOS_10PLUS ([[UIDevice currentDevice].systemVersion intValue] >= 10)
#define RSS_LINKS [[NSArray alloc] initWithObjects: @"https://dni.ru/rss.xml", @"https://www.vz.ru/rss.xml", nil]

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Array of web links to rss feeds for fetching content
    feedLinks = RSS_LINKS;
    
    // Array of fetched articles
    articles = [[NSMutableArray alloc] init];
    
    // A dictionary of feed models with feed Url as the key. Used for processing arrays of articles from particular feeds
    feedDictionary = [[NSMutableDictionary alloc] init];
    
    // Connect table view
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // Enable auto resizing for tableView rows
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;


    // Create and configure Refresh Control
    [self configureRefreshControl];

    // Get rss data
    [self loadData];
}


// MARK: - Data initalization
-(void) loadData {
    
    @autoreleasepool {

        // Call each link in array to fetch rss content
        FeedModel* fm;
        for (NSString* link in feedLinks) {
            fm = [[FeedModel alloc] initWithFeedURLString: link];
            [feedDictionary setValue:fm forKey:link];
            fm.delegate = self;
            [fm getArticles];
        }
    }
}


// Updating data here
-(void) refreshData : (id)sender {

    [self->articles removeAllObjects];
    [self loadData];
    [_tableView reloadData];
    [refreshControl endRefreshing];

}


// Create and configure Refresh Control
-(void) configureRefreshControl {

    refreshControl = [[UIRefreshControl alloc] init];

    if (IOS_10PLUS) {
        _tableView.refreshControl = refreshControl;
    } else {
        [_tableView addSubview:refreshControl];
    }
    
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Обновление данных ..." attributes:nil];
    refreshControl.tintColor = [UIColor colorWithRed:.25 green:.72 blue:.85 alpha:1.0];
}


// MARK: - Table view methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Article* selectedArticle = (Article*) self->articles[indexPath.row];
    activeLink = selectedArticle.link;
    [self performSegueWithIdentifier: @"segueShowDetail" sender: self];
    
}

// Set up a cell in table view
-(UITableViewCell*) tableView : (UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"prototypeCell"];
    UILabel* label = (UILabel*) [cell viewWithTag:2];
    NSString* timePart = [articles[indexPath.row] timestampShort];
    NSString* titlePart = [articles[indexPath.row] title];
    label.text = [[timePart stringByAppendingString:@": "] stringByAppendingString:titlePart];
    return cell;
}


// Return number of items
-(NSInteger) tableView : (UITableView*)tableView numberOfRowsInSection: (NSInteger)section {
    return [articles count];
}


// MARK: - Detail view loader
// Load selected link to detail view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    assert(activeLink != nil);
    
    // If link is selected load it as a property to destination view controller
    DetailViewController* detailVC = (DetailViewController*) [segue destinationViewController];
    detailVC.linkToLoad = activeLink;
    
}


// MARK: - Method(s) to process fetched articles
// Callback function of FeedModelDelegate protocol
- (void) articlesReady : (NSString*) feedUrlString {
    
    assert(feedUrlString != nil);
    
    // Receive articles from URL = feedUrlString
    FeedModel* feed = [feedDictionary objectForKey:feedUrlString];
    assert(feed != nil);
    
    // Add the articles to articles already fetched from other sources
    [self->articles addObjectsFromArray:feed.articles];

    // Sort the entire collection of articles in reverse chronological order
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestampAsDate" ascending:NO selector:@selector(compare:)];
    NSArray* sorted = [self->articles sortedArrayUsingDescriptors:@[sort]];
    
    self->articles = [sorted mutableCopy];
    
    // Refresh table view
    [_tableView reloadData];
    
}


@end
