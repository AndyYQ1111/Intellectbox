//
//  MusicCollectionCell.m
//  IntelligentBox
//
//  Created by KW on 2018/8/9.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MusicCollectionCell.h"

@implementation MusicCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat W = (kJL_W - 45) / 2;
        self.faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, 93.0 / 165.0 * W)];
        self.faceImgView.layer.masksToBounds = YES;
        self.faceImgView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.faceImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.faceImgView.frame) + 5, CGRectGetWidth(self.faceImgView.frame), 15)];
        self.titleLabel.textColor = TITLE_COLOER;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
