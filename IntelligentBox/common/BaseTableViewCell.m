//
//  BaseTableViewCell.m
//  IntelligentBox
//
//  Created by KW on 2018/8/7.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            self.preservesSuperviewLayoutMargins = NO;
            self.separatorInset = UIEdgeInsetsZero;
            self.layoutMargins = UIEdgeInsetsZero;
        }else {
            self.separatorInset = UIEdgeInsetsZero;
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
