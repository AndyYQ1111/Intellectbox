//
//  JL_Listen.m
//  IntelligentBox
//
//  Created by DFung on 2018/3/21.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "JL_Listen.h"
#import "JL_XMPlayer.h"
#import "SpeechHandle.h"

@interface JL_Listen(){
    int      inputType;     //0:Sco电话通道   1:speex
    int      recordType;    //1:设备录音  2:手机录音
    NSString *recordPath;   //录音路径
    NSString *speexPath;    //speex路径
    void     *vad_hdl;      //断句算法
    BOOL     isBackground;
}
@end

@implementation JL_Listen
@synthesize audioRecoder;

+(id)sharedMe{
    static JL_Listen *ME = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ME = [[self alloc] init];
    });
    return ME;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self recordMode:4];
        
        recordType = 0;
        DFAudioFormat *format = [DFAudioFormat new];
        format.mSampleRate = 16000;
        format.mBitsPerChannel = 16;
        format.mChannelsPerFrame = 1;
        format.mFormatID = kAudioFormatLinearPCM;
        audioRecoder = [[DFAudio alloc] init];
        [audioRecoder setRecorderFormat:format];
        [self addNote];
    }
    return self;
}

-(void)recordMode:(int)mode {
    /*--- 1:耳机采麦 ---*/
    if (mode == 1) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                                               error:nil];
    }
    
    /*--- 2:手机采麦 ---*/
    if (mode == 2) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:AVAudioSessionCategoryOptionAllowBluetoothA2DP
                                               error:nil];
    }
    
    /*--- 3:手机公放 ---*/
    if (mode == 3) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    
    /*--- 4:后台播放 ---*/
    if (mode == 4) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
}


-(void)newRecordPath{
    recordPath = kFIND_PCM;
    if (recordPath) [DFFile removePath:recordPath];
    recordPath = kMAKE_PCM;
    
    speexPath = kFIND_SPEEX;
    if (speexPath) [DFFile removePath:speexPath];
    speexPath = kMAKE_SPEEX;
}

#pragma mark - 手机【开始录音】
-(BOOL)recordStart {
    if (recordType == 0) {
        [self newRecordPath];
        
        /*--- 暂停APP音频播放 ---*/
        [DFAudioPlayer didPauseLast];
        
        /*--- 手机公放（模式） ---*/
        [self recordMode:3];
        
        /*--- 手机请求录音 ---*/
        recordType = 2;
        [audioRecoder didRecorderStart];
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - 手机【结束录音】
-(void)recordStop{
    if (recordType == 2) {
        recordType = 0;
        [audioRecoder didRecorderStop];
        
        [self recordMode:4];

        /*--- 回调【手机录音】 ---*/
        [DFNotice post:kJL_RECORD_PATH Object:@(2)];
    }
}

#pragma mark - 设备【开始录音】
-(void)noteSpeexStart:(NSNotification*)note{
    
    NSArray *arr = [note object];
    inputType = [arr[0] intValue];
    //int num_1 = [arr[1] intValue];
    
    /*--- 电话链路 ---*/
    if (inputType == 0) {
        if (recordType == 0) {
            NSLog(@"Sco --> Start");

            [self newRecordPath];
            
            /*--- 暂停TTS音频播放 ---*/
            [[JL_XMPlayer sharedInstance] stop];
            
            /*--- 暂停APP音频播放 ---*/
            [DFAudioPlayer didPauseLast];
            
            /*--- 开启Vad ---*/
            int need_buf_size = vad_get_need_buf_size();
            vad_hdl = malloc(need_buf_size);
            vad_init(vad_hdl, 10, 51);
            
            /*--- 耳机采麦（模式） ---*/
            [self recordMode:1];
            
            /*--- 设备请求录音 ---*/
            recordType = 1;
            [DFAction subTask:^{
                AudioServicesPlaySystemSound(1113);//提示音
                [self->audioRecoder didRecorderStart];
            }];
            
            /*--- 回调【设备录音】开始 ---*/
            [DFNotice post:kJL_RECORD_PATH Object:@(0)];
            
            [DFAction mainTask:^{
                /*--- UI正在识别 ---*/
                [DFNotice post:@"speech_start" Object:nil];
            }];
        }
    }
    
    
    /*--- speex ---*/
    if (inputType == 1) {
        if (recordType == 0) {
            NSLog(@"speex --> Start");
            //开始之前停止tts播放
            [[SpeechHandle sharedInstance] stopCutTopMusic];

            [self newRecordPath];
            
            /*--- 暂停TTS音频播放 ---*/
            [[JL_XMPlayer sharedInstance] stop];
            
            /*--- 暂停APP音频播放 ---*/
            [DFAudioPlayer didPauseLast];
            
            /*--- 设备请求录音 ---*/
            recordType = 1;
            
            /*--- 回调【设备录音】开始 ---*/
            [DFNotice post:kJL_RECORD_PATH Object:@(0)];
            
            [DFAction mainTask:^{
                /*--- UI正在识别 ---*/
                [DFNotice post:@"speech_start" Object:nil];
            }];
        }
    }
}

#pragma mark - 设备【录音数据】回调（方式：speex）
-(void)noteSpeexData:(NSNotification*)note{
    NSData *data = [note object];
    NSLog(@"speex --> %lu",(unsigned long)data.length);
    [DFFile writeData:data endFile:speexPath];
}

-(void)noteSpeexStop:(NSNotification*)note{
    //转场音乐
    [[SpeechHandle sharedInstance] playCutToMusic];
    NSLog(@"speex --> STOP");
    [DFAction mainTask:^{
        /*--- UI关闭识别 ---*/
        [DFNotice post:@"speech_end" Object:nil];
    }];
    
    /*--- 关闭录音 ---*/
    recordType = 0;
    
    /*--- speex解码 ---*/
    [JL_Speex speex:speexPath OutPcm:recordPath];
    
    /*--- 回调【设备录音】结束 ---*/
    [DFNotice post:kJL_RECORD_PATH Object:@(1)];
}

-(void)noteSpeakBreak:(NSNotification*)note{
    NSLog(@"speex --> BREAK");
    [DFAction mainTask:^{
        /*--- UI关闭识别 ---*/
        [DFNotice post:@"speech_end" Object:nil];
    }];
}


#pragma mark - 设备【录音数据】回调（方式：电话链路Soc）
static NSMutableData *mRest= nil;
static int rec_state = 0;
-(void)noteRecordData:(NSNotification*)note{
    NSData *data = [note object];
    
    /*--- 设备请求录音 ---*/
    if (recordType == 1) {
        if (!mRest) mRest = [NSMutableData new];
        [mRest appendData:data];
        
        int len = (int)[mRest length];
        char buf[320];
        
        int i = 0;
        while (1) {
            int sum = 320*i;
            if (sum+320 <= len) {
                memcpy(buf, [mRest bytes]+sum, 320);
                
                int ret = vad_main(vad_hdl, (int*)buf);
                NSLog(@"Sco -->rec len: %ld vad:%d",(long)len,ret);
                
                /*--- 开始断句 ---*/
                if (rec_state == 0 && ret == 1) {
                    NSLog(@"Sco --> 开始断句");
                }
                
                /*--- 正在录音 ---*/
                if (rec_state == 1 && ret == 1) {
                    NSData *buf_320 = [DFTools data:mRest R:sum L:320];
                    [DFFile writeData:buf_320 endFile:recordPath];
                }
                
                /*--- 结束断句 ---*/
                if (rec_state == 1 && ret == 2) {
                    NSLog(@"Sco --> 结束断句");
                    
                    /*--- 关闭录音 ---*/
                    recordType = 0;
                    [audioRecoder didRecorderStop];
                    
                    
                    //if (!isBackground) {
                        [self recordMode:4];
                    //}
                    
                    /*--- 关闭Vad ---*/
                    free(vad_hdl);
                    
                    /*--- 告诉设备：APP已录完语音 ---*/
                    [JL_BLE_Cmd cmdAppVoiceEnd];
                    
                    /*--- 回调【设备录音】 ---*/
                    [DFAction mainTask:^{
                        [DFNotice post:kJL_RECORD_PATH Object:@(1)];
                    }];
                }
                rec_state = ret;
                
            }else{
                int rest = len - sum;
                mRest = [NSMutableData dataWithData:[DFTools data:mRest R:sum L:rest]];
                NSLog(@"Sco --> save rest : %d",rest);
                break;
            }
            i++;
        }
    }
    
    /*--- 手机请求录音 ---*/
    if (recordType == 2) {
//        NSLog(@"red --> len:");
        [DFFile writeData:data endFile:recordPath];
    }
}

#pragma mark - 设备【录音状态】回调
-(void)noteRecordState:(NSNotification*)note{
    int st = [[note object] intValue];
    if (st == DFAudio_ST_STOP)      NSLog(@"DFAudio_ST_STOP");
    if (st == DFAudio_ST_RECORDING) NSLog(@"DFAudio_ST_RECORDING");
}

#pragma mark - 后台处理
-(void)noteAppBackground:(NSNotification*)note{
    [self recordStop];
    isBackground = YES;
    
    //保持后台BLE 数据收发；
    [DFAction delay:0.5 Task:^{
        [[JL_BLE_Core sharedMe] keepCMD_90:YES];
    }];
}

#pragma mark - 前台处理
-(void)noteAppForeground:(NSNotification*)note{
    isBackground = NO;
}


#pragma mark - 设备配置
-(void)noteConfigInfo:(NSNotification*)note{
    NSData *buf = [note object];
    NSData *buf_0 = [DFTools data:buf R:3 L:1];
    uint8_t val_0 = (uint8_t)[DFTools dataToInt:buf_0];
    
    //每一bit含义，0：不使能 1:使能
    _isMIC     = (val_0>>0)&0x01;//BIT(0):手机mic语音识别使能
    _isCLOCK   = (val_0>>1)&0x01;//BIT(1):闹钟使能
    _isFILE    = (val_0>>2)&0x01;//BIT(2):设备文件浏览使能
    _isCONTACT = (val_0>>3)&0x01;//BIT(3):语音电话本使能
    _isMAP     = (val_0>>4)&0x01;//BIT(4):地图导航使能
    _isIPOD    = (val_0>>5)&0x01;//BIT(5):本地音乐使能
    
    [DFNotice post:@"kUI_IS_CLOCK" Object:@(_isCLOCK)];
 
}

#pragma mark - 方案私有命令
-(void)noteUserCmd:(NSNotification*)note{
    NSData *uData = [note object];
    NSData *uData_op = [DFTools data:uData R:0 L:1];
    
    NSInteger op = [DFTools dataToInt:uData_op];
    /*--- 【APP】使用0x98 ---*/
    if (op == 0x98) {
        NSLog(@"user data ==> %@",uData);
        NSData *uData_cmd = [DFTools data:uData R:1 L:2];
        NSInteger cmd = [DFTools dataToInt:uData_cmd];
        
        if(cmd == 0x06){
            [DFNotice post:@"DISCONNECT_BT" Object:nil];
        }
    }
}

-(void)addNote{
    [DFNotice add:kCMD_SPEEX_START Action:@selector(noteSpeexStart:) Own:self];
    [DFNotice add:kCMD_SPEEX_STOP    Action:@selector(noteSpeexStop:) Own:self];
    [DFNotice add:kCMD_SPEEX_OUT     Action:@selector(noteSpeexStop:) Own:self];
    [DFNotice add:kCMD_SPEEX_BREAK   Action:@selector(noteSpeakBreak:)Own:self];
    [DFNotice add:kBT_REC_SPEEX_DATA Action:@selector(noteSpeexData:) Own:self];
    
    [DFNotice add:kCMD_CNF_INFO Action:@selector(noteConfigInfo:) Own:self];
    [DFNotice add:kCMD_USER_1   Action:@selector(noteUserCmd:) Own:self];
    
    [DFNotice add:kDFAudio_REC     Action:@selector(noteRecordData:) Own:self];//录音数据
    [DFNotice add:kDFAudio_ST      Action:@selector(noteRecordState:)Own:self];//录音状态
    [DFNotice add:UIApplicationDidEnterBackgroundNotification
           Action:@selector(noteAppBackground:) Own:self];
    [DFNotice add:UIApplicationWillEnterForegroundNotification
           Action:@selector(noteAppForeground:) Own:self];
}

-(void)dealloc{
    [DFNotice remove:kCMD_USER_1 Own:self];
    [DFNotice remove:kCMD_SPEEX_START Own:self];
    [DFNotice remove:kCMD_SPEEX_STOP  Own:self];
    [DFNotice remove:kCMD_SPEEX_OUT   Own:self];
    [DFNotice remove:kCMD_SPEEX_BREAK  Own:self];
    [DFNotice remove:kBT_REC_SPEEX_DATA Own:self];
    
    [DFNotice remove:kCMD_CNF_INFO Own:self];


    [DFNotice remove:kDFAudio_REC     Own:self];
    [DFNotice remove:kDFAudio_ST      Own:self];
    [DFNotice remove:UIApplicationDidEnterBackgroundNotification Own:self];
    [DFNotice remove:UIApplicationWillEnterForegroundNotification Own:self];
    [audioRecoder didRecorderRelease];
}
@end
