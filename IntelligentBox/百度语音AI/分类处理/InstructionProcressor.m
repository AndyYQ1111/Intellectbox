//
//  InstructionProcressor.m
//  IntelligentBox
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "InstructionProcressor.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation InstructionProcressor

+(void)handleWithDictionary:(NSDictionary *)resultDic{

    float value = [[AVAudioSession sharedInstance] outputVolume];
    MPVolumeView *volumeView   = [[MPVolumeView alloc] init];
    UISlider *volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    //音量增加
    if ([resultDic[@"intent"] isEqualToString:@"volume_up"]) {
        value = value + 0.2f;
        if (value>=1.0f) {
            value = 1.0f;
        }
            // change system volume, the value is between 0.0f and 1.0f
        [volumeViewSlider setValue:value animated:NO];
        // send UI control event to make the change effect right now. 立即生效
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    //音量减少
    if ([resultDic[@"intent"] isEqualToString:@"volume_down"]) {
        value = value - 0.2f;
        if (value<=0) {
            value = 0.0f;
        }
            // change system volume, the value is between 0.0f and 1.0f
        [volumeViewSlider setValue:value animated:NO];
        // send UI control event to make the change effect right now. 立即生效
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

@end
