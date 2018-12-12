//
//  UIButton+TitleAndImage.m
//  Medical
//
//  Created by YueAndy on 2018/1/2.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "UIButton+TitleAndImage.h"

@implementation UIButton (TitleAndImage)
+(UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
}
@end
