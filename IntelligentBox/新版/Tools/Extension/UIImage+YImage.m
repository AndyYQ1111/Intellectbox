//
//  UIImage+YImage.m
//  FMT
//
//  Created by YueAndy on 2018/2/26.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "UIImage+YImage.h"

@implementation UIImage (YImage)
///缩放图片
+ (instancetype)resizeImage:(NSString *)imgName {
    
    UIImage *backImage = [UIImage imageNamed:imgName];
    //缩放图片
    backImage =  [backImage stretchableImageWithLeftCapWidth:backImage.size.width / 2 topCapHeight:backImage.size.height / 2];
    return backImage;
}
@end
