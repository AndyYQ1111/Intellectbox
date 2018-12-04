
//
//  SearchNavView.m
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SearchNavView.h"

@interface SearchNavView () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTF;
@end

@implementation SearchNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, SNavigationBarHeight - 40, 40, 40);
        [backBtn setImage:[UIImage imageNamed:@"k_E_0002"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(50, SNavigationBarHeight - 35, kJL_W - 65, 30)];
        bgView.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:242 / 255.0 blue:246 / 255.0 alpha:1.0];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 3;
        [self addSubview:bgView];
        
        self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, bgView.frame.size.width - 20, 30)];
        self.searchTF.placeholder = @"请输入关键词";
        self.searchTF.textColor = TITLE_COLOER;
        self.searchTF.font = [UIFont systemFontOfSize:14];
        self.searchTF.delegate = self;
        self.searchTF.returnKeyType = UIReturnKeySearch;
        [bgView addSubview:self.searchTF];
        
    }
    return self;
}

- (void)setSearchStr:(NSString *)searchStr {
    self.searchTF.text = self.searchStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length <= 0) {
        [DFUITools showText:@"请输入搜索关键字" onView:self delay:1.5];
        return NO;
    }
    if (self.SearchBlock) {
        self.SearchBlock(textField.text);
    }
    
    return YES;
}


- (void)backAction {
    if (self.DismissBlock) {
        self.DismissBlock();
    }
}

@end
