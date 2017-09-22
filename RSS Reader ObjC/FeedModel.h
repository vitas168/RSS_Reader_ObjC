//
//  FeedModel.h
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 19/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

// Protocol containing a callback function for the Feed Model
@protocol FeedModelDelegate
@required
- (void) articlesReady : (NSString*) feedUrlString;
@end


@interface FeedModel : NSObject <NSXMLParserDelegate>
{
    // Single article used for creating array
    Article* article;
    
    // Temporary string variable
    NSString* attrString;
    
    // Article attributes
    NSString* title;
    NSString* timestamp;
    NSString* link;
    NSString* descr;
    
    // Delegate and URL properties of the class
    NSString* rssUrl;
}

// A collection of articles produced by parsing rss feed
@property (nonatomic, readonly) NSMutableArray *articles;

// Protocol delegate
@property (nonatomic, weak) id  <FeedModelDelegate> delegate;

- (id) initWithFeedURLString : (NSString*) url;

- (void) getArticles;

- (NSString*) formatTimestamp : (NSString*)timedate initialMask: (NSString*)initialMask targetMask: (NSString*)targetMask sourceLocale: (NSString*)sourceLocale targetLocale: (NSString*)targetLocale;

- (NSDate*) formatTimestampAsDate : (NSString*)timedate initialMask: (NSString*)initialMask targetLocale: (NSString*)targetLocale;

@end
