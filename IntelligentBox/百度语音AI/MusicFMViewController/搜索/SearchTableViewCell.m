//
//  SearchTableViewCell.m
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell ()
@property (nonatomic, strong) UIImageView *faceImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation SearchTableViewCell

+ (instancetype)cellWithTableView:(UITableView*)tableView {
    static NSString *ID = @"SearchTableViewCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SearchTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.clipsToBounds = YES;
        
        self.faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 165, 90 )];
        self.faceImgView.layer.masksToBounds = YES;
        self.faceImgView.layer.cornerRadius = 5;
        //self.faceImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.faceImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + 165, 20, kJL_W - 200, 20)];
        self.titleLabel.textColor = TITLE_COLOER;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + 165, 45, kJL_W - 200, 15)];
        self.timeLabel.textColor = GRAY_COLOER;
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLabel];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(15, self.faceImgView.frame.origin.y + CGRectGetHeight(self.faceImgView.frame), 70, 30);
        [self.deleteBtn setImage:[UIImage imageNamed:@"k61_delete"] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.deleteBtn setTitleColor:[UIColor colorWithRed:179 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.hidden = YES;
        [self.contentView addSubview:self.deleteBtn];
        
    }
    return self;
}

- (void)assignWithFace:(NSString *)face title:(NSString *)title duration:(NSString *)duration btnTitle:(NSString *)btnTitle {
    
    [self.faceImgView sd_setImageWithURL:[NSURL URLWithString:face] placeholderImage:PLACE_IMAGE];
    self.titleLabel.text = title;
    self.timeLabel.text = duration;
    
    if (btnTitle) {
        self.deleteBtn.hidden = NO;
        [self.deleteBtn setTitle:btnTitle forState:UIControlStateNormal];
    }
}

- (void)deleteBtnAction {
    if (self.SearchTableViewCellBlock) {
        self.SearchTableViewCellBlock();
    }
}

@end
