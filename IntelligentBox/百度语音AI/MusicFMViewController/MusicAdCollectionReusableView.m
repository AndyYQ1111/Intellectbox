//
//  MusicAdCollectionReusableView.m
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MusicAdCollectionReusableView.h"
#import "KWCarouselView.h"

@interface MusicAdCollectionReusableView ()
@property (nonatomic, strong) KWCarouselView *pagerView;
@property (nonatomic, strong) UIScrollView *sortScrollView;

@end

@implementation MusicAdCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pagerView];
        
        //分类菜单
        self.sortScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(self.pagerView.frame), kJL_W - 10, 80)];
        self.sortScrollView.showsHorizontalScrollIndicator = NO;
        self.sortScrollView.contentSize = CGSizeMake(kJL_W, 80);
        self.sortScrollView.clipsToBounds = YES;
        [self addSubview:self.sortScrollView];
        
        for (int i = 0; i < 30; i ++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(18 + (35 + 40) * i, 15, 35, 35)];
            imgView.image = PLACE_IMAGE;
            imgView.tag = 20 + i;
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius = 17.5;
            [self.sortScrollView addSubview:imgView];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = imgView.frame;
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.sortScrollView addSubview:btn];
        }
    }
    return self;
}

- (void)assignWithAd:(NSArray *)adArr sortArray:(NSArray *)sortArr {
    self.pagerView.imgUrlArray = adArr;
    
    for (int i = 0; i < sortArr.count; i ++) {
        UIImageView *imgView = [self.sortScrollView viewWithTag:20 + i];
        [imgView sd_setImageWithURL:sortArr[i] placeholderImage:PLACE_IMAGE];
        
    }
    self.sortScrollView.contentSize = CGSizeMake(18 * 2 + 35 * sortArr.count + 40 * (sortArr.count - 1), 80);
}

- (void)sortAction:(UIButton *)sender {
    if (self.MusicAdCellBlock) {
        self.MusicAdCellBlock (sender.tag);
    }
}

- (KWCarouselView *)pagerView {
    if (!_pagerView) {
        //160.0 / 375.0 * kJL_W
        _pagerView = [[KWCarouselView alloc] initWithFrame:CGRectMake(0, 0, kJL_W, 200) placeholderImg:PLACE_IMAGE];
        _pagerView.timeInterval = 3;
        _pagerView.pageTintColor = [UIColor whiteColor];
        _pagerView.currentPageTintColor = [UIColor lightGrayColor];
        
        WeakSelf
        [_pagerView didSelectAtIndexBlock:^(NSInteger index) {
            if (weakSelf.MusicAdCellBlock) {
                weakSelf.MusicAdCellBlock (index + 200);
            }
        }];
    }
    return _pagerView;
}
@end
