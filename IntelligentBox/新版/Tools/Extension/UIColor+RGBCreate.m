//
//  UIColor+RGBCreate.m
//  爱学习
//
//  Created by YueAndy on 2017/11/30.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

#import "UIColor+RGBCreate.h"

@implementation UIColor (RGBCreate)
+(UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b{
    return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1];
}
@end
