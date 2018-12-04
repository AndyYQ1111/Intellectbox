//
//  DownloadCell.m
//  CMD_APP
//
//  Created by Ezio on 2018/1/31.
//  Copyright © 2018年 DFung. All rights reserved.
//

#import "DownloadCell.h"
#import "JLDefine.h"

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [DFUITools loadNib:@"DownloadCell"];
    if (self) {
        
    }
    return self;
    
}

@end
