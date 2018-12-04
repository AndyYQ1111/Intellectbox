//
//  SearchCell.m
//  BTMate2
//
//  Created by DFung on 2017/11/17.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [DFUITools loadNib:@"SearchCell"];
    if (self) {
    
    }
    return self;
}


+(NSString*)ID{
    return @"SCCELL";
}




@end
