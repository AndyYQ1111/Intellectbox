//
//  songListTbCell.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/16.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "songListTbCell.h"

@implementation songListTbCell



-(instancetype)init{
    
    self = [[NSBundle mainBundle] loadNibNamed:@"songListTbCell" owner:nil options:nil][0];
    
    if (self) {
      
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
