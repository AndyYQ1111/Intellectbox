//
//  JL_BDSpeaker.h
//  Test
//
//  Created by DFung on 2017/11/23.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SPEAK_END) (void);
typedef void(^SPEAK_DATA)(NSData*data);
typedef void(^SPEAK_ASR) (NSDictionary*info);

@interface JL_BDSpeaker : NSObject
@property(nonatomic,strong)NSString * BD_API_KEY;
@property(nonatomic,strong)NSString * BD_SECRET_KEY;
@property(nonatomic,strong)NSString * BD_APP_ID;


#pragma mark - 语音合成 TTS
-(void)sayWords:(NSString*)text;
-(void)sayWords:(NSString *)text End:(SPEAK_END)end;
-(void)sayWords:(NSString *)text Data:(SPEAK_DATA)data;

#pragma mark - 语音识别 ASR
-(void)asrPath:(NSString*)path Asr:(SPEAK_ASR)asr;

@end
