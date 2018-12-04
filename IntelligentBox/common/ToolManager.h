//
//  ToolManager.h
//  IntelligentBox
//
//  Created by KW on 2018/8/8.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolManager : NSObject
+ (instancetype _Nonnull )shareManage;
+ (void)saveDefauleData:(id _Nonnull )vaile key:(NSString *_Nonnull)key;
+ (NSString *_Nonnull)getDefaultData:(NSString *_Nonnull)key;
+ (void)removeDefaultData:(NSString *_Nonnull)key;
+ (UIViewController*_Nonnull)viewController:(UIView *_Nonnull)view;

+ (void)addHeaderRefreshWithView:(UIScrollView *_Nonnull)tableview complete:(void (^ __nullable)(void))complete;
+ (void)addFooterRefreshWithView:(UIScrollView *_Nonnull)tableview complete:(void (^ __nullable)(void))complete;

+ (NSString *_Nonnull)timeFormatted:(int)totalSeconds;
@end
