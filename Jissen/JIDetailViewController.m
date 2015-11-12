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
// In the class header or class extension:
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) CGRect labelFrame;

// ...

@end

@implementation JIDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    labelFrame.origin.x = 37.5f;
//    labelFrame.origin.y = 200.0f;
//    [self.tweetLabel autoCenterInSuperview];
//    [self.tweetLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
//    [self.tweetLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];

    [self.view addSubview:self.tweetLabel];
    [self.view setNeedsUpdateConstraints];
}



// In the class implementation:
- (void)updateViewConstraints {
    if (!self.didSetupConstraints) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.tweetLabel autoCenterInSuperview];
     //   [self.tweetLabel autoSetDimensionsToSize:CGSizeMake(50.0, 50.0)];
        [self.tweetLabel sizeToFit];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}


- (UILabel *)tweetLabel
{
    if (!_tweetLabel) {
        CGRect labelFrame = CGRectMake(10.0f, 10.0f, 300.0f, 25.0f);
        _tweetLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _tweetLabel.textColor = [UIColor blackColor];
        _tweetLabel.text = self.tweet;
        _tweetLabel.numberOfLines = 0;
        _tweetLabel.textAlignment =  NSTextAlignmentCenter;
        _tweetLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _tweetLabel.layer.borderWidth = 1.0;
    }
    return _tweetLabel;
}


@end
