//
//  LocalMusicViewController.h
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/26.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JL_BLEUsage.h"
#import "MissionVC.h"

@interface LocalMusicViewController : MissionVC

@property(nonatomic,weak)DFAudioPlayer *mAudioPlayer;
@property(nonatomic,weak)NSMutableArray *mItemArray;
@end
