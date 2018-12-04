//
//  AISTTSPlayer.h
//  DUILite_ios_CloudTTS
//
//  Created by hc on 2017/11/17.
//  Copyright © 2017年 speech. All rights reserved.
//

/*!
 
 @header AISTTSPlayer.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.0
 
 */

#import <Foundation/Foundation.h>


/*!
 实现回调的代理协议AISTTSPlayerDelegate
 */
@protocol AISTTSPlayerDelegate <NSObject>

@optional
/*!
 合成完成时的回调
 */
-(void)onAISTTSInitCompletion;


/*!
 播放完成时的回调
 */
-(void)onAISTTSPlayCompletion;

/*!
 发生错误时的回调
 
 @param error 错误
 */
-(void)onAISTTSError:(NSError *)error;


@end


/*!
 在线合成引擎AISTTSPlayer接口说明
 */
@interface AISTTSPlayer : NSObject


/*!
 合成代理对象
 */
@property (nonatomic,weak) id<AISTTSPlayerDelegate> delegate;

/*!
 设置待合成的文本信息
 */
@property (nonatomic, strong) NSString * refText;


/*!
 设置语速，范围是[0.7, 2]，1表示正常语速，数值越小语速越快；默认是正常语速
 */
@property (nonatomic, assign) float speed;


/*!
 设置音量，范围是[10, 100]，数值越小表示声音越轻；正常80
 */
@property (nonatomic, assign) float volume;


/*!
 设置发音人，有如下取值:
 
     zhilingf 甜美女神
 
     gdgm 沉稳钢叔
 
     geyou 淡定葛爷
 
     hyanif 邻家女声
 
     xijunm 标准男声
 
     qianranf 可爱童声
 
     tahuaf 标准女声
 */
@property (nonatomic, strong) NSString * speaker;


/*!
 指定合成类型，取值为：text|ssml, 默认为text
 */
@property (nonatomic, strong) NSString * ttsType;

@property (nonatomic, strong) NSNumber * cache;

/*!
 开启在线合成引擎，开始合成
 */
- (void)startTTS;


/*!
 关闭在线合成引擎，停止合成
 */
- (void)stopTTS;


/*!
 暂停在线合成引擎，暂停合成播放
 */
- (void)pauseTTS;



/*!
 恢复在线合成引擎，继续合成播放
 */
- (void)continueTTS;


-(void)setDuiServer:(NSString*)server;

@end
