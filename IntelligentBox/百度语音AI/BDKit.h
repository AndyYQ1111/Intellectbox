//
//  BDKit.h
//  BDKit
//
//  Created by DFung on 2018/10/23.
//  Copyright © 2018年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <DFUnits/DFUnits.h>

typedef void(^BD_SPEAK_END) (void);
typedef void(^BD_SPEAK_DATA)(NSData*data);
typedef void(^BD_SPEAK_ASR) (NSDictionary*info);

@interface BDKit : NSObject
@property(nonatomic,strong)NSString * BD_API_KEY;
@property(nonatomic,strong)NSString * BD_SECRET_KEY;
@property(nonatomic,strong)NSString * BD_APP_ID;
@property(nonatomic,assign)int        BD_PER;       //0为普通女声，1为普通男生，3为情感合成-度逍遥，4为情感合成-度丫丫
@property(nonatomic,assign)int        BD_SPD;       //语速，取值0-15，默认为5中语速
@property(nonatomic,assign)int        BD_PIT;       //音调，取值0-15，默认为5中语调
@property(nonatomic,assign)int        BD_VOL;       //音量，取值0-15，默认为5中音量
@property(nonatomic,assign)BOOL       BD_CACHE;     //是否保存PCM缓存
#pragma mark - 语音合成 TTS
-(void)sayWords:(NSString*)text;
-(void)sayWords:(NSString *)text End:(BD_SPEAK_END)end;
-(void)sayWords:(NSString *)text End:(BD_SPEAK_END)end IsCache:(BOOL)cache;
-(void)sayWords:(NSString *)text Data:(BD_SPEAK_DATA)data;

-(void)sayStop;
-(void)sayQuit;
-(BOOL)hasSpeakEnd;

#pragma mark - 语音识别 ASR
-(void)asrPath:(NSString*)path Asr:(BD_SPEAK_ASR)asr;
@end
