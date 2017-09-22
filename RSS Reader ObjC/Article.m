//
//  Article.m
//  RSS Reader ObjC
//
//  Created by Vitaly Shpinyov on 19/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

#import "Article.h"


// Article class holding article attributes
@implementation Article

- (id) init
{
    _title = @"";
    _timestamp  = @"";
    _timestampAsDate = nil;
    _timestampShort = @"";
    _link = @"";
    _image = @"";
    _text = @"";

    return self;
}

@end
