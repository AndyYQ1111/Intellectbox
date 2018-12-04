//
//  DUILiteAuth.h
//  DUILiteAuth
//
//  Created by aispeech009 on 22/11/2017.
//  Copyright © 2017 aispeech009. All rights reserved.
//


/*!
 
 @header DUILiteAuth.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.0
 
 */

#import <Foundation/Foundation.h>

/*!
 用户回调代理协议DUILiteDelegat
 */
@protocol DUILiteDelegate <NSObject>

@optional

/*!
 发生错误时执行
 
 @param error  错误信息
 */
-(void) onAuthError:(NSString*) error;

/*!
 授权回调

 @param message 授权是否成功
 */
-(void) onAuthResult:(BOOL) message;

@end


/*!
 基础引擎DUILite接口说明
 */
@interface DUILiteAuth : NSObject


/*!
 协议代理对象
 */
@property (nonatomic,assign) id<DUILiteDelegate>authDelegate;

/*!
 创建实例
 
 @return 返回一个实例
 */
+(id)sharedInstance;


/*!
 获取实例
 
 @return 返回一个实例
 */
+(id)getInstance;


/*!
 销毁实例
 */
+(void)dellocInstance;


/*!
 设置基础引擎配置信息

 @param authDic 基础配置信息，开启授权:
 
        设置产品发布的ID
 
        设置用户标识userId
 
        设置产品对应的API_Keys
 
 */
+(void)setAuthConfig:(id)deledage config:(NSMutableDictionary*)authDic;


/*!
 获取基础配置信息

 @return 以字典形式返回基础配置信息
 */
+(NSMutableDictionary*)getAuthConfig;


/*!
 设置是否打印基础引擎的log信息, 默认NO(不打印log)
 
 @param value 设置为YES, SDK 会输出log信息可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
 */
+ (void)setLogEnabled:(BOOL)value;

@end
