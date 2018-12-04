//
//  JLDefine.h
//  IntelligentBox
//
//  Created by DFung on 2017/11/14.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DFUnits/DFUnits.h>
#import <JL_BD_SDK/JL_BD_SDK.h>
#import <BD_ARS/BD_ARS.h>
#import "JL_BLEUsage.h"
#import "JL_Listen.h"

/**
     为团队工程代码的完善，我希望各位配合使用【DFUnit.framework】，提高工程代码易接手性，整洁性，可阅读性。
     请大家在日后每个项目都配合使用，现在列举几点必须使用的代码：
 
     1、屏幕宽高的宏。(代码如下)
 
     2、多语言的宏。（代码如下）
 
     3、UserDefaults 设置：
             [DFTools setUser:(id)objc forKey:(NSString*)key];
             id objc = [DFTools getUserByKey:(NSString*)key];
 
     4、NSNotificationCenter 通知中心：
             [DFNotice post:(NSString*)name Object:(id)object];
             [DFNotice add:(NSString*)name Action:(SEL)action Own:(id)own;];
             [DFNotice remove:(NSString*)name Own:(id)own];
 
     5、以及项目图片的名字为 k1_xxx@2x.png,k2_xxx@2x.png等有序的递增。
 
     (注：不要求在你们所新建SDK中使用以上代码，但是在SDK以外的项目工程必须使用，以后有必要的代码我再写出来。)
 */



/*--- 屏幕宽高 ---*/
#define kJL_W           [DFUITools screen_1_W]
#define kJL_H           [DFUITools screen_1_H]

/*--- 多语言 ---*/
#define kJL_GET         [DFUITools systemLanguage]                              //获取系统语言
#define kJL_SET(lan)    [DFUITools languageSet:@(lan)]                          //设置系统语言
#define kJL_TXT(key)    [DFUITools languageText:@(key) Table:@"Localizable"]    //多语言转换,"Localizable"根据项目的多语言包填写。

#define APP_SUOAI   1



#define WeakSelf __weak typeof(self) weakSelf = self;
// 是否是iPhone X
#define is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// Tabbar高度.   49 + 34 = 83
#define TabbarHeight        (is_iPhoneX ? 83.f : 49.f)
// Tabbar安全区域底部间隙
#define TabbarSafeBottomMargin  (is_iPhoneX ? 34.f : 0.f)
// 状态栏和导航高度
#define SNavigationBarHeight  (is_iPhoneX ? 88.f : 64.f)

#define TITLE_COLOER [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define GRAY_COLOER [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]

#define PLACE_IMAGE [UIImage imageNamed:@"k_A_test"]

#define DEVICE_ID @"deviceid"
//语音聊天界面URL
#define JL_INTER_SERVER_URL @"interServerUrl"

#import "UIImageView+WebCache.h"
#import "AFManagerClient.h"
#import "ToolManager.h"
#import "MJRefresh.h"
