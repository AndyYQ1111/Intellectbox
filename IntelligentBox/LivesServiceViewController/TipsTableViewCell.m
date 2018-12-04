//
//  TipsTableViewCell.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "TipsTableViewCell.h"

@implementation TipsTableViewCell



-(instancetype)init{
    
    self = [[NSBundle mainBundle] loadNibNamed:@"TipsTableViewCell" owner:nil options:nil][0];
    
    if (self) {
        _mainView.layer.cornerRadius = 10;
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
