//
//  MusicRecomCollectionReusableView.m
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MusicRecomCollectionReusableView.h"

@interface MusicRecomCollectionReusableView ()
{
    UILabel          *headTitleLab;
    UIButton         *moreBtn;
}
@end

@implementation MusicRecomCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 3, 13)];
        imgView.backgroundColor = [UIColor colorWithRed:249/255.0 green:77/255.0 blue:96/255.0 alpha:1.0];
        [self addSubview:imgView];
        
        headTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 200, 48)];
        headTitleLab.textColor = [UIColor blackColor];
        headTitleLab.textAlignment = NSTextAlignmentLeft;
        headTitleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [self addSubview:headTitleLab];
        
        moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kJL_W - 55, 8, 50, 48)];
        [moreBtn setImage:[UIImage imageNamed:@"k_A_more"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    headTitleLab.text = title;
}

-(void)moreBtnAction {
    if (self.MusicHeaderViewBlock) {
        self.MusicHeaderViewBlock ();
    }
}
@end
