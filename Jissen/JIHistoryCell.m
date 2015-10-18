//
//  JIHistoryCell.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/17/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

// http://jainmarket.blogspot.com/2009/05/creating-custom-table-view-cell.html

#import "JIHistoryCell.h"

@implementation JIHistoryCell







//- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
//        // Initialization code
//        primaryLabel = [[UILabel alloc]init];
//        primaryLabel.textAlignment = UITextAlignmentLeft;
//        primaryLabel.font = [UIFont systemFontOfSize:14];
//        secondaryLabel = [[UILabel alloc]init];
//        secondaryLabel.textAlignment = UITextAlignmentLeft;
//        secondaryLabel.font = [UIFont systemFontOfSize:8];
//        myImageView = [[UIImageView alloc]init];
//        [self.contentView addSubview:primaryLabel];
//        [self.contentView addSubview:secondaryLabel];
//        [self.contentView addSubview:myImageView];
//        
//    }
//    return self;
//}
//
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    CGRect contentRect = self.contentView.bounds;
//    CGFloat boundsX = contentRect.origin.x;
//    CGRect frame;
//    frame= CGRectMake(boundsX+10 ,0, 50, 50);
//    myImageView.frame = frame;
//    
//    frame= CGRectMake(boundsX+70 ,5, 200, 25);
//    primaryLabel.frame = frame;
//    
//    frame= CGRectMake(boundsX+70 ,30, 100, 15);
//    secondaryLabel.frame = frame;
//}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}





@end
