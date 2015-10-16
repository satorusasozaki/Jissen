//
//  JITweetCell.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/9/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JITweetCell.h"

@implementation JITweetCell

// http://jslim.net/blog/2013/03/22/ios-create-uitableview-with-custom-cell-programmatically/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *tweet = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 30)];
        [self.contentView addSubview:tweet];
        self.tweet = tweet;
    }
    return self;
}


- (NSString *)limitTweet:(NSString *)tweet {
    if (tweet.length > 10) {
        tweet = [NSString stringWithFormat:@"%@%@", [tweet substringToIndex:10], @"..."];
    }
    return tweet;
}



@end
