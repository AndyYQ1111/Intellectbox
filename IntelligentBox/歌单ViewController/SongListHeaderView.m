//
//  SongListHeaderView.m
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SongListHeaderView.h"

@interface SongListHeaderView ()
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation SongListHeaderView

+ (instancetype)headerViewWithTableView:(UITableView*)tableView {
    static NSString *ID = @"SongListHeaderView";
    SongListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[SongListHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        NSArray *array = @[@"正序", @"倒序"];
        for (int i = 0; i < array.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15 + 50 * i, 0, 40, 30);
            btn.tag = 10 + i;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:GRAY_COLOER forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:249 / 255.0 green:77 / 255.0 blue:96 / 255.0 alpha:1.0] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
        }
        
        //k61_play
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"k61_play"]];
        imgView.frame = CGRectMake(kJL_W - 25, 10, 10, 10);
        [self.contentView addSubview:imgView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kJL_W - 90, 0, 60, 30)];
        titleL.text = @"上回播放";
        titleL.textColor = TITLE_COLOER;
        titleL.font = [UIFont systemFontOfSize:14];
        titleL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:titleL];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(kJL_W - 90, 0, 80, 30);
        btn2.tag = 12;
        [btn2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn2];
    }
    return self;
}

- (void)setSelectedIndex:(int)selectedIndex {
    self.selectedBtn.selected = NO;
    self.selectedBtn = [self.contentView viewWithTag:10 + selectedIndex];
    self.selectedBtn.selected = YES;
}

- (void)buttonAction:(UIButton *)sender {
    if (self.SongListHeaderViewBlock) {
        self.SongListHeaderViewBlock(sender.tag);
    }
}
@end
