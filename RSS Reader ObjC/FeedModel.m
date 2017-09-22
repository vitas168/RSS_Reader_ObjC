//
//  FeedModel.m
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 19/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import "FeedModel.h"
@import UIKit;
@import Foundation;

#define INITIAL_DATETIME_MASK   @"EEE, dd MMM yyyy HH:mm:ss Z"
#define TARGET_DATETIME_MASK    @"dd MMM, HH:mm"
#define LOCALE_RU               @"ru_RU"
#define LOCALE_EN               @"en_GB"

@implementation FeedModel


// MARK: - Initializers
- (id) init {

    self = [super init];
    if (self) {
    
        // A collection of articles produced by parsing rss feed
        _articles = [[NSMutableArray alloc] init];
        
        // Temporary string variable
        attrString = @"";
        
        // Article attributes
        title = @"";
        timestamp = @"";
        link = @"";
        descr = @"";
        
        // URL property of the class
        rssUrl = @"";
    
    }
    return self;
}

- (id) initWithFeedURLString : (NSString*) url {
    if ([self init]) {
        rssUrl = url;
        return self;
    }
    else {
        return nil;
    }
}
    
    // MARK: - Initiation of XML parser
    
    // This function starts parsing a particular RSS feed
- (void) getArticles {
        
    // Flush Articles array to avoid duplication at refresh
    [_articles removeAllObjects];

    @try {
        // Create a URL object
        NSURL* url = [NSURL URLWithString:rssUrl];
        assert(url != nil);
    
        // Create a parser object
        NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL: url];
        assert(parser != nil);

        // Set a delegate and start parsing
        parser.delegate = self;
        [parser parse];
    }
    @catch (NSException* exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        NSLog(@"FeedModel: getArticles executed");
    }
}
    
    // MARK: - XMLParser methods
    
    // We only need Item, Title, Link, Image (enclosure) and Description tags
- (void)  parser : (NSXMLParser*)parser didStartElement: (NSString*)elementName namespaceURI: (NSString*)namespaceURI qualifiedName: (NSString*)qName attributes: (NSMutableArray*)attributeDict {
}
    
    // Read characters between starting and closing tags
- (void) parser : (NSXMLParser*)parser foundCharacters: (NSString*)string {
    attrString = [attrString stringByAppendingString:string];
}
    
    // Tag is processed, article attributes are set
- (void) parser : (NSXMLParser*) parser didEndElement: (NSString*)elementName namespaceURI: (NSString*)namespaceURI qualifiedName: (NSString*) qName {

        if ([elementName isEqualToString: @"title"]) {
            title = attrString;
        }
        if ([elementName isEqualToString: @"description"]) {
            descr = attrString;
        }
        
        if ([elementName isEqualToString: @"link"]) {
            link = attrString;
        }
        if ([elementName isEqualToString: @"pubDate"]) {
            timestamp = attrString;
        }
        
        // When another item is found, new article is added to the array of articles
        if ([elementName isEqualToString: @"item"]) {
            
            // Create new article
            article = [[Article alloc] init];
            
            // Set up its attributes
            article.title = [title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            article.timestamp = [timestamp stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            article.timestampAsDate = [self formatTimestampAsDate : timestamp initialMask: INITIAL_DATETIME_MASK targetLocale: LOCALE_EN];
            article.timestampShort = [self formatTimestamp : timestamp initialMask: INITIAL_DATETIME_MASK targetMask: TARGET_DATETIME_MASK sourceLocale: LOCALE_EN targetLocale: LOCALE_RU];
            article.text = [descr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            article.link = [link stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            // Add article to array
            [_articles addObject:article];
  
        }
        attrString = @"";
}
    
    // Parsing is finished, inform the delegate
- (void) parserDidEndDocument : (NSXMLParser*)parser {
        
    assert(self.delegate != nil);
    [self.delegate articlesReady: rssUrl];
    
}
    
    // MARK: - Date formatter functions
    
    // Format date string according to a given mask and locale, and return a string
- (NSString*) formatTimestamp : (NSString*)timedate initialMask: (NSString*)initialMask targetMask: (NSString*)targetMask sourceLocale: (NSString*)sourceLocale targetLocale: (NSString*)targetLocale {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString* formattedDate = [timedate stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

        formatter.dateFormat = initialMask;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:sourceLocale];
    
        NSDate* actualDate = [formatter dateFromString:formattedDate];
        assert(actualDate != nil);
    
        formatter.dateFormat = targetMask;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:targetLocale];
        formattedDate = [formatter stringFromDate:actualDate];

        return formattedDate;
    
    }
    
    // Format date string according to a given mask and return a date
- (NSDate*) formatTimestampAsDate : (NSString*)timedate initialMask: (NSString*)initialMask targetLocale: (NSString*)targetLocale {
        
        NSString* formattedDate = [timedate stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = initialMask;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:targetLocale];
    
        NSDate* actualDate = [formatter dateFromString:formattedDate];
        if (actualDate != nil) {
            return actualDate;
        } else {
            return nil;
        }
}

@end
