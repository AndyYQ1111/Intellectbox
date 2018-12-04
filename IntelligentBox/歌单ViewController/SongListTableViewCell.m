//
//  SongListTableViewCell.m
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SongListTableViewCell.h"

@interface SongListTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@end

@implementation SongListTableViewCell

+ (instancetype)cellWithTableView:(UITableView*)tableView {
    static NSString *ID = @"SongListTableViewCell";
    SongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SongListTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kJL_W - 110, 20)];
        self.titleLabel.textColor = TITLE_COLOER;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, kJL_W - 30, 15)];
        self.durationLabel.textColor = GRAY_COLOER;
        self.durationLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.durationLabel];
        
        self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.collectBtn.frame = CGRectMake(kJL_W - 80, 0, 80, 80);
        [self.collectBtn setImage:[UIImage imageNamed:@"k61_sc1"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"k61_sc2"] forState:UIControlStateSelected];
        [self.collectBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.collectBtn];
        
    }
    return self;
}

- (void)assginWithTitle:(NSString *)title duration:(NSString *)duration isCollection:(BOOL)collection isplaying:(BOOL)playing {
    self.titleLabel.text = title;
    self.durationLabel.text = duration;
    self.collectBtn.selected = collection;
    if (playing) {
        self.titleLabel.textColor = [UIColor colorWithRed:251/255.0 green:44/255.0 blue:130.0/255.0 alpha:1];
    }else {
        self.titleLabel.textColor = TITLE_COLOER;
    }
}

- (void)collectionAction {
    if (self.SongListCellBlock) {
        self.SongListCellBlock();
    }
}
@end
