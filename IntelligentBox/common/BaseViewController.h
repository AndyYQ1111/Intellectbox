//
//  BaseViewController.h
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, copy) NSString *vcTitle;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) void(^KWRightBtnBlock)(void);
@end
