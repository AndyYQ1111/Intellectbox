//
//  UIButton+ImageCreate.m
//  Medical
//
//  Created by YueAndy on 2017/12/27.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import "UIButton+ImageCreate.h"

@implementation UIButton (ImageCreate)

+(UIButton *)buttonWithNormalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button sizeToFit];
    return button;
}
@end
