//
//  JITweetCell.h
//  Jissen
//
//  Created by Satoru Sasozaki on 10/9/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JIBaseCell.h"
#import "TWTweet.h"

@interface JITweetCell : JIBaseCell

@property (nonatomic, weak) UILabel *tweet;
- (NSString *)limitTweet:(NSString *)tweet;



@end
