//
//  AppInfoGeneral.h
//  IntelligentBox
//
//  Created by kaka on 2018/3/23.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JL_IMAGE_URL @"img_url" //播放网络图片地址
#define JL_PLAY_INDEX @"play_index" //播放位置
#define JL_PLAY_START_TIME @"play_start_time" //播放开始时间
#define JL_PLAY_END_TIME @"play_end_time" //播放结束时间
#define JL_PLAY_PROGRESS @"play_progress" //播放进度值

@interface AppInfoGeneral : NSObject

/**
 记录起键值对
 
 @param value Value
 @param key key
 */
+ (void)setJLValue:(NSString *)value ForKey:(NSString *)key;
/**
 根据Key获取Value
 
 @param key key
 @return Value
 */
+ (NSString *)getValueForKey:(NSString *)key;
@end
