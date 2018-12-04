//
//  BaseNavigationView.m
//  IntelligentBox
//
//  Created by KW on 2018/8/9.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "BaseNavigationView.h"

@implementation BaseNavigationView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)aTitle {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, SNavigationBarHeight - 35, kJL_W - 120, 35)];
        titleLabel.textColor = TITLE_COLOER;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = aTitle;
        [self addSubview:titleLabel];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, SNavigationBarHeight - 40, 40, 40);
        [backBtn setImage:[UIImage imageNamed:@"k_E_0002"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
         
    }
    return self;
}

- (void)backAction {
    if (self.KWBaseBackBlock) {
        self.KWBaseBackBlock();
    }
}



@end
