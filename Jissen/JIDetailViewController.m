//
//  JIDetailViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/1/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JIDetailViewController.h"
#import <PureLayout/PureLayout.h>

@interface JIDetailViewController ()
@property (nonatomic,strong) UILabel *tweetLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) CGRect labelFrame;


@end

@implementation JIDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tweetLabel];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    if (!self.didSetupConstraints) {
        self.view.backgroundColor = [UIColor whiteColor];
//        [self.tweetLabel autoCenterInSuperview];
        [self.tweetLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f];
        [self.tweetLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f];
        [self.tweetLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:75];
//        [self.tweetLabel sizeToFit];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}


- (UILabel *)tweetLabel
{
    if (!_tweetLabel) {
//        CGRect labelFrame = CGRectMake(10.0f, 10.0f, 300.0f, 25.0f);
        _tweetLabel = [UILabel newAutoLayoutView];
        _tweetLabel.textColor = [UIColor blackColor];
        _tweetLabel.font = [_tweetLabel.font fontWithSize:20];
        _tweetLabel.text = self.tweet;
        _tweetLabel.numberOfLines = 0;
        _tweetLabel.textAlignment =  NSTextAlignmentLeft;
        _tweetLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _tweetLabel.layer.borderWidth = 1.0;
    }
    return _tweetLabel;
}


@end
