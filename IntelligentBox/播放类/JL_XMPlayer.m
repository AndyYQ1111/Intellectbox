//
//  JL_XMPlayer.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/15.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "JL_XMPlayer.h"
#import "STKAudioPlayer.h"


@interface JL_XMPlayer()<STKAudioPlayerDelegate>{

    AVAudioPlayer   *player;
    NSTimer         *wakeupTimer;
    int             wakeTime;
    
    NSObject        *nowObject;
    int             itemIndex;
    NSTimer         *dataCheck;
    
    STKAudioPlayer  *audioPlayer;
    XM_BLOCK        xm_block;
}
@end

@implementation JL_XMPlayer

+(instancetype)sharedInstance{
    
    static JL_XMPlayer *playerMe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerMe = [[JL_XMPlayer alloc] init];
    });
    return playerMe;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addNote];
        audioPlayer = [[STKAudioPlayer alloc] init];
        audioPlayer.delegate = self;
    }
    return self;
}

-(void)addNote{
    //[DFNotice add:kJL_BDWakeUp Action:@selector(wakeUpBaiduSpeek:) Own:self];
}

-(void)setPlayListArray:(NSArray *)playListArray {
    _playListArray = playListArray;
    [self play];
}

-(void)play {
    
}


-(void)playItem:(NSString *)urlStr {
    [audioPlayer play:urlStr];
}


-(void)playItem:(NSString*)urlStr Block:(XM_BLOCK)block {
    xm_block = block;
    [audioPlayer play:urlStr];
}


-(void)resume{

    
}

-(void)pause{
    
}

-(void)next{
    
    if (_playListArray.count>0) {

        itemIndex++;
        
        if (itemIndex >= (_playListArray.count-1)) {
            itemIndex=0;
        }
    }
}


-(void)previous{
    
    if (_playListArray.count>0) {
        
        itemIndex--;
        
        if (itemIndex < 0) {
            itemIndex = (int)_playListArray.count-1;
        }
    }
}

-(void)stop{
    xm_block = nil;
    [audioPlayer stop];
}


/**
 seeks to a specific time (in seconds)

 @param value time in seconds
 */
-(void)seekToTime:(double)value{
    

}


#pragma mark <- 百度唤醒了 ->
-(void)wakeUpBaiduSpeek:(NSNotification *)note {
    
    [wakeupTimer invalidate];
    wakeupTimer = nil;
    wakeTime = 0;
    
    wakeupTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wakeupTimerAdd) userInfo:nil repeats:YES];
    [wakeupTimer fire];
    
    [self pause];
    
}

-(void)wakeupTimerAdd{
    
    wakeTime++;
    if (wakeTime>5) {
        [wakeupTimer invalidate];
        wakeupTimer = nil;
        [self resume];
    }
    
}


-(void)checkTheUIData{
    

    
}
                        
#pragma mark <- delegate ->
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId{
    
    
    
}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    
    if (progress>=duration) {
        if (xm_block) {
            xm_block();
            xm_block = nil;
        }
        //[DFNotice post:@"TALK_OVER" Object:nil];
    }
    
}

- (void)audioPlayer:(nonnull STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(nonnull NSObject *)queueItemId {
    
}


- (void)audioPlayer:(nonnull STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    
}


- (void)audioPlayer:(nonnull STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    
}





@end
