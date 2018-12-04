//
//  BaseViewController.m
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseNavigationView *navView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, kJL_W, SNavigationBarHeight) title:self.vcTitle];
    [self.view addSubview:navView];
    
    if (self.rightImage) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(kJL_W - 45, SNavigationBarHeight - 40, 40, 40);
        [self.rightBtn setImage:self.rightImage forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:self.rightBtn];
    }
    
    WeakSelf
    navView.KWBaseBackBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)rightBtnAction {
    if (self.KWRightBtnBlock) {
        self.KWRightBtnBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
