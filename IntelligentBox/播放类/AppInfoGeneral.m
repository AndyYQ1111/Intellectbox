//
//  AppInfoGeneral.m
//  IntelligentBox
//
//  Created by kaka on 2018/3/23.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AppInfoGeneral.h"

@implementation AppInfoGeneral

/**
 记录起键值对
 
 @param value Value
 @param key key
 */
+ (void)setJLValue:(NSString *)value ForKey:(NSString *)key{
    
    NSUserDefaults *usdf = [NSUserDefaults standardUserDefaults];
    [usdf setObject:value forKey:key];
    
}


/**
 根据Key获取Value
 
 @param key key
 @return Value
 */
+ (NSString *)getValueForKey:(NSString *)key{
    
    NSUserDefaults *usdf = [NSUserDefaults standardUserDefaults];
    NSString *value = [usdf objectForKey:key];
    return value;
}
@end
