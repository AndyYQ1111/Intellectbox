//
//  ToolManager.m
//  IntelligentBox
//
//  Created by KW on 2018/8/8.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ToolManager.h"

@implementation ToolManager
+ (instancetype)shareManage {
    static ToolManager *manage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[ToolManager alloc]init];
    });
    return manage;
}

//保存值
+ (void)saveDefauleData:(id)vaile key:(NSString *)key {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:vaile forKey:key];
    [defaults synchronize];
}

+ (NSString *)getDefaultData:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)removeDefaultData:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

+ (UIViewController*)viewController:(UIView *)view {
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark -mjrefresh
+ (void)addHeaderRefreshWithView:(UIScrollView *)tableview complete:(void (^ __nullable)(void))complete {
    MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (complete) {
            complete ();
        }
    }];
    tableview.mj_header = mjHeader;
}

+ (void)addFooterRefreshWithView:(UIScrollView *)tableview complete:(void (^ __nullable)(void))complete {
    
    MJRefreshAutoNormalFooter *mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (complete) {
            complete ();
        }
    }];
    [mjFooter setTitle:@"继续拖动加载更多" forState:MJRefreshStateIdle];
    [mjFooter setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    mjFooter.stateLabel.font = [UIFont systemFontOfSize:14];
    tableview.mj_footer = mjFooter;
}

//
+ (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
@end
