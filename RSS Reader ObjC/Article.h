//
//  Article.h
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 19/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic)  NSString*    title;
@property (nonatomic)  NSString*    timestamp;
@property (nonatomic)  NSDate*      timestampAsDate;
@property (nonatomic)  NSString*    timestampShort;
@property (nonatomic)  NSString*    link;
@property (nonatomic)  NSString*    image;
@property (nonatomic)  NSString*    text;

@end
