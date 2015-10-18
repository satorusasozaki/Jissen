//
//  TWTweet.h
//  Jissen
//
//  Created by Satoru Sasozaki on 10/9/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWTweet : NSObject

@property (nonatomic,strong) NSString *text;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)tweetWithDictionary:(NSDictionary *)d;

@end
