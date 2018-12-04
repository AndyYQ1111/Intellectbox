//
//  KWCarouselView.h
//  KWViwepager
//
//  Created by WEISON on 17/1/13.
//  Copyright © 2017年 siso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWCarouselView : UIView
/** 本地图片数组*/
@property (nonatomic,strong) NSArray *imgArray;
/** 网络图片数组*/
@property (nonatomic,strong) NSArray *imgUrlArray;
/** 定时器时间间隔*/
@property (nonatomic,assign) NSInteger timeInterval;
/** PageControl未选中颜色*/
@property (nonatomic,strong) UIColor *pageTintColor;
/** PageControl选中颜色*/
@property (nonatomic,strong) UIColor *currentPageTintColor;
/** 图片点击调用*/

@property (nonatomic,strong) NSTimer *timer;


- (void)didSelectAtIndexBlock:(void (^)(NSInteger index))block;

- (instancetype)initWithFrame:(CGRect)frame placeholderImg:(UIImage *)img;
@end
