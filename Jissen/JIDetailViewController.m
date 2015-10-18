//
//  JIDetailViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/1/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JIDetailViewController.h"

@interface JIDetailViewController ()
@property (nonatomic,strong) UILabel *tweetLabel;

@end

@implementation JIDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect labelFrame = CGRectMake(10.0f, 10.0f, 300.0f, 25.0f);
    labelFrame.origin.x = 37.5f;
    labelFrame.origin.y = 200.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    self.tweetLabel = label;
    self.tweetLabel.textColor = [UIColor blackColor];
    self.tweetLabel.text = self.tweet;
    self.tweetLabel.numberOfLines = 0;
    self.tweetLabel.textAlignment =  NSTextAlignmentCenter;
    self.tweetLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.tweetLabel.layer.borderWidth = 1.0;
    [self.tweetLabel sizeToFit];
    [self.view addSubview:self.tweetLabel];
}

@end
