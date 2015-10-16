//
//  TWTweet.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/9/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "TWTweet.h"

@implementation TWTweet

// Create actual tweet text from dictionary


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
    }
    return self;
}



@end
