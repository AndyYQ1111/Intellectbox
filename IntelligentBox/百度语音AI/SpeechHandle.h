//
//  SpeechHandle.h
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/16.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLDefine.h"

//TTS
#import "AISTTSPlayer.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"
#import <AVFoundation/AVFoundation.h>

@interface SpeechHandle : NSObject

#define Domain_weather       @"weather"
#define Domain_music         @"music"
#define Domain_train         @"train"
#define Domain_flight        @"flight"
#define Domain_map           @"map"
#define Domain_joke          @"joke"
#define Domain_translation   @"translation"
#define Domain_player        @"player"
#define Domain_person        @"person"
#define Domain_calculator    @"calculator"
#define Domain_calendar      @"calendar"
#define Domain_alarm         @"alarm"
#define Domain_story         @"story"
#define Domain_radio         @"radio"
#define Domain_instruction   @"instruction"
#define Domain_novel         @"novel"

@property (nonatomic, strong) AISTTSPlayer* player;

@property(nonatomic)BOOL isReminder;

@property(nonatomic,strong) AVAudioPlayer *cutToPlayer;

+(instancetype)sharedInstance;
-(void)playCutToMusic;
-(void)stopCutTopMusic;
@end
