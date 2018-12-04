//
//  JL_BDSpeechAI.h
//  IntelligentBox
//
//  Created by DFung on 2017/11/14.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <DFUnits/DFUnits.h>
#import <JL_BLE/JL_BLE.h>

#import <BD_ARS/BD_ARS.h>

#import "JL_BDSpeaker.h"

/**
 *  识别出的原话
 */
#define kJL_BDTalk      @"JL_BDTalk"

/**
 *  语音识别结果
 */
#define kJL_BDResult    @"JL_BDResult"

/**
 *  唤醒回调
 */
#define kJL_BDWakeUp    @"JL_WAKEUP"

/**
 *  开始播放【合成语音】
 */
#define kJL_SPEAK_START @"JL_SPEAK_START"

/**
 *  已播放完【合成语音】
 */
#define kJL_SPEAK_END   @"JL_SPEAK_END"

@interface JL_BDSpeechAI : NSObject
@property(nonatomic,strong)NSString * BD_API_KEY;
@property(nonatomic,strong)NSString * BD_SECRET_KEY;
@property(nonatomic,strong)NSString * BD_APP_ID;

@property(nonatomic, strong) BDSEventManager *asrEventManager;
@property(nonatomic, strong) BDSEventManager *wakeupEventManager;

+(id)sharedMe;
-(void)setBD_ApiKey:(NSString*)ak
          SecretKey:(NSString*)sk
              AppId:(NSString*)ai;

-(void)speechRecognizeText:(NSString*)text;
-(void)speechRecognizePath:(NSString*)path;
-(void)wakeupStart;
-(void)wakeupStop;
-(void)speakTxt:(NSString*)txt;
-(void)speakTxt:(NSString*)txt Result:(SPEAK_END)ret;
 
+(void)talkWrite:(NSDictionary*)dic;
+(NSArray*)talkRed;
+(void)talkRemove;

@end
