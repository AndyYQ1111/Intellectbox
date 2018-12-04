//
//  PlayMusicViewController.h
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/18.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLDefine.h"
#import "MissionVC.h"

@interface PlayMusicViewController : MissionVC

@property (nonatomic,weak) DFAudioPlayer *audioManager;
@property (nonatomic,strong) UISlider * volumeSlider;
@end
