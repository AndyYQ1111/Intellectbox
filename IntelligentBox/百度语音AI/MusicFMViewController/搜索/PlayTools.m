//
//  PlayTools.m
//  IntelligentBox
//
//  Created by KW on 2018/8/15.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "PlayTools.h"
#import "FMDBHelper.h"

@implementation PlayTools

+ (instancetype)shareManage {
    static PlayTools *manage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[PlayTools alloc]init];
    });
    return manage;
}

- (void)playWithModel:(SearchDataModel *)songitem {
    [DFAudioPlayer didPauseLast];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    MusicOfPhoneMode *model = [MusicOfPhoneMode new];
    model.mIndex = 0;
    model.mUrl = songitem.playUrl;
    model.mTime = [songitem.duration intValue];
    //作为唯一标识符
    model.mMediaItem = songitem.trackId;
    model.mImgUrl = songitem.jpgUrl;
    [tmpArray addObject:model];
    
    [[DFAudioPlayer sharedMe_2] setNetPaths:tmpArray];
    [[DFAudioPlayer sharedMe_2] didPlay:0];
    
    //添加到历史记录
    [[FMDBHelper sharedInstance] updateWithSong:songitem];
}
@end
