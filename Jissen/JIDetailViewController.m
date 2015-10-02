//
//  JIDetailViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/1/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JIDetailViewController.h"

@interface JIDetailViewController ()
@property (nonatomic,strong) UILabel *label;

@end

@implementation JIDetailViewController

- (void)viewDidLoad {
    /*
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc]init];
    self.label = label;
    self.label.text = self.tweet;
    [self.view addSubview:self.label];
*/
    

    self.view.backgroundColor = [UIColor whiteColor];
    CGRect labelFrame = CGRectMake(10.0f, 10.0f, 300.0f, 25.0f);
    labelFrame.origin.x = 37.5f;
    labelFrame.origin.y = 200.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    self.label = label;
    self.label.textColor = [UIColor blackColor];
    self.label.text = self.tweet;
    self.label.numberOfLines = 0;
    self.label.textAlignment =  NSTextAlignmentCenter;
    self.label.layer.borderColor = [UIColor blackColor].CGColor;
    self.label.layer.borderWidth = 1.0;

    [self.label sizeToFit];
    
    [self.view addSubview:self.label];
    


}



@end
