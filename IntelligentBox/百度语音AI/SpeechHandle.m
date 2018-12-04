//
//  SpeechHandle.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/16.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "SpeechHandle.h"
#import "PlayerProcessor.h"
#import "MusicProcessor.h"
#import "PersonProcessor.h"
#import "WeatherProcessor.h"
#import "CalculatorProcessor.h"
#import "CalendarProcessor.h"
#import "AlarmProcessor.h"
#import "JokeProcessor.h"
#import "StoryProcessor.h"
#import "RadiosProcessor.h"
#import "InstructionProcressor.h"
#import "NovelProcressor.h"
#import "JL_XMPlayer.h"
#import "JLDefine.h"
#import "OldTreeManager.h"
#import <DFUnits/DFUnits.h>
#import "MusicMainModel.h"
#import "AlarmObject.h"

static NSString *serverUrl;
static int receiveNoticeCount;

@interface SpeechHandle()<AISTTSPlayerDelegate>{
    
    JL_BDSpeaker    *baiduSpeaker;
    DFTips          *loadingView;
    
    NSTimer    *dateCheck;
    NSDate      *alarmDate;
    NSString    *tips;
    NSMutableArray *currentArray;
    NSMutableArray *textArray;
    int index;
    int _cs;
    NSString * _mUrl;
    AVSpeechUtterance*utteranceZJ;
    AVSpeechSynthesisVoice *voiceZJ;
    AVSpeechSynthesizer *synthZJ;
    
    //服务器返回的model
    AnswerModel *sModel;
    int times;
    NSTimeInterval delay;
    
    NSTimer *timer;
    
    //当序幕长度超过100d个字时，用来分开在线合成序幕
    BOOL isPrologue;
    //当序幕很长的分割成数组；
    NSMutableArray *prologueArr;
    //当前播放的序幕片段序号
    int prologueIndex;
}
@property(nonatomic,strong)NSString *textContent;
@end

@implementation SpeechHandle

+(instancetype)sharedInstance{
    
    static SpeechHandle *spMe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        spMe = [[SpeechHandle alloc] init];
    });
    return spMe;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self addNote];
        //用于【语音】转【文字】
        baiduSpeaker = [[JL_BDSpeaker alloc] init];
        baiduSpeaker.BD_APP_ID     = @"11793460";
        baiduSpeaker.BD_API_KEY    = @"LI6jYDGdUGRWDqVK0ZPxnFQQ";
        baiduSpeaker.BD_SECRET_KEY = @"oE6cEkTmrql1EMqllz25Vpb2BYoae4j3";
        
        self->currentArray = [NSMutableArray array];
        prologueArr = [NSMutableArray array];
        prologueIndex = 0;
        _isReminder = NO;
        isPrologue = NO;
        times = 0;
        
        //TTS初始化
        [self setAudioConfig];
        [self initTTS];
        //TTS初始化
        
        
        
        //转场音效播放
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"cutTo" ofType:@"mp3"];
        // (2)把音频文件转化成url格式
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        NSError *error = nil;
        self.cutToPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.cutToPlayer.numberOfLoops =10;
        // 准备播放
        [self.cutToPlayer prepareToPlay];
        
    }
    return self;
}

- (void)getInterServerUrl:(NSNotification *)noti {
    serverUrl = [noti object];
}

#pragma mark - 获取得录音文件
-(void)noteRecordPath:(NSNotification*)note {
    int op = [[note object] intValue];  //0:speex开始 1:speex结束 2:手机录音结束
    if (op == 0) {
        return;
    }
    
    __weak typeof(self) wSelf = self;
    UIWindow *win = [DFUITools getWindow];
    NSString *path = kFIND_PCM;
    
    if (path) {
        [baiduSpeaker asrPath:path Asr:^(NSDictionary *info) {
            [JL_BLE_Cmd cmdSpeexEnd];
            
            NSArray *arr = info[@"result"];
            if (arr.count > 0) {
                NSString *text = arr[0];
                [wSelf getBaiduText:text];
                
            }else {
                /*
                 int err = [info[@"err_no"] intValue];
                 NSString *err_txt = nil;
                 
                 if (err == 3301) {
                 err_txt = @"抱歉，我没听清楚。";
                 }else if (err == 3308) {
                 err_txt = @"你说得太多了，我记不住。";
                 }else{
                 err_txt = @"抱歉，服务器异常。";
                 }
                 */
            }
        }];
        
    }else{
        [JL_BLE_Cmd cmdSpeexEnd];
        [DFNotice post:@"speech_end" Object:nil];
        
        [DFUITools showText:@"语音传输失败." onView:win delay:1.0];
        NSLog(@"Err:录音文件不存在.");
    }
}


// 原杰里SDK的方法
-(void)jieliSDK{
    WeakSelf
    
    NSMutableArray *listArarry = [NSMutableArray array];
    //    self->textArray = [[NSMutableArray alloc]initWithCapacity:10];
//    NSString *urlCD = sModel.answerAudioUrl;
    
    self->_mUrl = sModel.answerAudioUrl;
    
    
    //要 有闹钟
    if([sModel.servcie isEqualToString:@"clock"] || [sModel.servcie isEqualToString:@"reminder"]){
        
        NSString *delayTime = sModel.dateTime;
        NSDateFormatter *dataFormate = [[NSDateFormatter alloc] init];
        [dataFormate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        self->alarmDate = [dataFormate dateFromString:delayTime];
        NSDate *nowData = [NSDate date];
        delay = [DFTime gapOfDateA:self->alarmDate DateB:nowData];
        
        
        NSString * timeS = sModel.dateTime;
        NSString * xianzai = [self getsTheCurrentTime];
        NSInteger yuyue = [self dateToTimeStampAtThe:timeS];
        NSInteger xianz = [self dateToTimeStampAtThe:xianzai];
        
        AlarmObject *item_1 = [AlarmObject new];
        if (xianz > yuyue) {
            NSLog(@"过期时间不处理");
        }else{
            NSLog(@"预定闹钟");
            uint8_t mode = 0x01;//单次
            if ([sModel.repeat isEqualToString:@"1"]) {
                //每天
                NSArray * cycArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
                for (NSString *num in cycArray) {
                    uint8_t tmp = 0x01;
                    int n = [num intValue];
                    uint8_t tmp_n = tmp<<n;
                    mode = mode|tmp_n;
                }
            }
            NSArray *array = [timeS componentsSeparatedByString:@" "]; //
            NSArray *timeArray = [array[1] componentsSeparatedByString:@":"]; //
            item_1.mode  = mode;
            item_1.name  = sModel.content;
            item_1.hour  = (uint8_t)[timeArray[0] integerValue];//小时
            item_1.min   = (uint8_t)[timeArray[1] integerValue];//分钟
            item_1.index = 0;
            item_1.state = YES;//开启闹钟
            [JL_BLE_Cmd cmdAddAlarmClockWithIndex:item_1.index
                                             Hour:item_1.hour
                                              Min:item_1.min
                                       repeatMode:item_1.mode
                                            CName:item_1.name
                                            State:item_1.state];
            [DFAction delay:0.5 Task:^{
                [JL_BLE_Cmd cmdGetAlarmClock];
            }];
        }
    }
    
    else if(![sModel.tag isEqualToString:@"1"]){
        for (int i = 0; i < sModel.audioList.count; i ++) {
            AudioListModel *audioModel = sModel.audioList[i];
            //播放界面值
            MusicOfPhoneMode *tempModel = [MusicOfPhoneMode new];
            tempModel.mTitle = audioModel.title;
            tempModel.mUrl = [audioModel.playUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            tempModel.mMediaItem = @"序幕播报";
            tempModel.mIndex = i+1;
            [self->currentArray addObject:tempModel];
            //                [[JL_BDSpeechAI sharedMe] speakTxt:@""];
            if (sModel.audioList.count-1 == i) {
                self->_mUrl = audioModel.playUrl;
            }
            if ((audioModel.title.length > 0 && ![audioModel.title isEqualToString:@" "])) {
                //播放界面值
                MusicOfPhoneMode *tempModel = [MusicOfPhoneMode new];
                tempModel.mTitle = audioModel.title;
                tempModel.mUrl = audioModel.playUrl;
                tempModel.mIndex = i;
                //记录界面值
                [listArarry addObject:[weakSelf apiResponseToDictionary:audioModel]];
            }
            
        }
        if(self->currentArray.count>0){
            [[DFAudioPlayer sharedMe_2] setNetPaths:self->currentArray];
            [[DFAudioPlayer sharedMe_2] setMMode:DFAudioPlayer_ALL_LOOP];
            [[DFAudioPlayer sharedMe_2] didPlay:0];
        }
        
        //对于歌曲列表中, title全为空的情况, 不显示
        if (listArarry.count > 0) {
            [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"2", @"TEXT" : sModel.answerText, @"LIST" : listArarry}];
        }
    }
}

#pragma mark -语音转文字后到后台获取资源
- (void)getInterData:(NSString *)text {
    
//    text = @"设置15秒钟后的闹钟";
//    serverUrl = @"http://121.42.196.244:4112/";
    
    
    NSString *url = [NSString stringWithFormat:@"%@goform/GetResultByIntelligent", serverUrl];
    NSDictionary *paraDic = @{
                              @"devId" : [ToolManager getDefaultData:DEVICE_ID] ? [ToolManager getDefaultData:DEVICE_ID] : @"",
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @"",
                              @"text" : text
                              };
    NSLog(@"%@?devId=%@&BTAddress=&token=%@&text=%@",url,[ToolManager getDefaultData:DEVICE_ID] ? [ToolManager getDefaultData:DEVICE_ID] : @"",[ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @"",text);
    
    [[AFManagerClient sharedClient] postRequestWithUrl:url parameters:paraDic success:^(id responseObject) {
        //移除上次播放内容
        [self->synthZJ stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        
        AnswerModel *model = [MTLJSONAdapter modelOfClass:[AnswerModel class] fromJSONDictionary:responseObject error:NULL];
        
        if([model.result isEqualToString:@"ok"]) {
            self->sModel = model;
            self->index = 0;
            [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"0", @"TEXT" : self->sModel.answerText}];
            [self->currentArray removeAllObjects];
            /***********************TTS***********************/
            long count = 80;
            if(model.answerText.length > count){
                self->isPrologue = YES;
                self->prologueIndex = 0;
                //需要分割的次数
                NSString *string1 = [model.answerText stringByReplacingOccurrencesOfString:@"，" withString:@","];
                string1 = [string1 stringByReplacingOccurrencesOfString:@"," withString:@",·"];
                string1 = [string1 stringByReplacingOccurrencesOfString:@"。" withString:@"。·"];
                string1 = [string1 stringByReplacingOccurrencesOfString:@"." withString:@".·"];
                int times = (int)(string1.length / count);
                
                [self->prologueArr removeAllObjects];
                for (int i= 0; i <= times+1; i++) {
                    //需要分割的字符串
                    NSString *string2 = @"";
                    if(string1.length < count){
                        string2 = [string1 substringToIndex:string1.length];
                        count = string1.length;
                    }else{
                        string2 = [string1 substringToIndex:count];
                    }
                    
                    NSArray *array = [string2 componentsSeparatedByString:@"·"];
                    
                    NSString *prologueItem = @"";
                    NSString *lastStr = [array lastObject];
                    if(array.count==1){
                        prologueItem = lastStr;
                        //剩下的字符串
                        string1 = [string1 substringFromIndex:count];
                    }else{
                        //需要播放的字符串
                        prologueItem = [string2 substringToIndex:(count-lastStr.length)];
                        //剩下的字符串
                        string1 = [string1 substringFromIndex:(count-lastStr.length)];
                    }
                    prologueItem = [prologueItem stringByReplacingOccurrencesOfString:@"·" withString:@""];
                    NSLog(@"%@",prologueItem);
                    
                    [self->prologueArr addObject:prologueItem];
                    if(i == 0){
                        /***********************TTS***********************/
                        [self ttsStartAction:prologueItem];
                    }
                }
            }
            else{
                [self ttsStartAction:self->sModel.answerText];
            }
            
        }else {
            NSLog(@"解析失败");
        }
    }failure:^(NSError *error) {
        NSLog(@"请求超时");
        [DFUITools showText:@"语音传输失败." onView:[DFUITools getWindow] delay:1.0];
    }];
}

#pragma mark TTS 播放序幕
-(void)playPrologue:(int)index{
    NSString *prologueItem = prologueArr[index];
    [self ttsStartAction:prologueItem];
}

#pragma mark 已经播放完成
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    //移除上次播放内容
    [synthZJ stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}
- (void)indexPathRow:(NSNotification *)note {
    NSDictionary *dic = note.object;
    index = [[dic objectForKey:@"row"] intValue];
    index = 0;
}
//播报结束
- (void)musicState:(NSNotification *)note {
    MusicOfPhoneMode *currentModel = [DFAudioPlayer currentPlayer].mNowItem;
    //    if ([note.object isEqualToString:@"DF_PLAY"]) {
    //        receiveNoticeCount ++;
    //    }
    if (([note.object isEqualToString:@"DF_FINISH"] || [note.object isEqualToString:@"DF_PAUSE"])) {
        if (index == 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                receiveNoticeCount = 0;
                [[DFAudioPlayer currentPlayer] didPause];
            });
            NSLog(@"结束了");
        }
        if ([_mUrl isEqualToString:currentModel.mUrl]) {
            index++;
        }else{
            index = 0;
        }
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  %d   %@        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",index,currentModel.mUrl);
    }
    
    if ([currentModel.mMediaItem isEqualToString:@"序幕播报"]) {
    }
}

- (NSDictionary *)apiResponseToDictionary:(AudioListModel *)response {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (response.title) {
        [dict setValue:response.title ? response.title : @"unknow" forKey:@"title"];
    }
    if (response.playUrl) {
        [dict setValue:response.playUrl forKey:@"url"];
    }
    return dict;
}

#pragma mark <- 获取到百度检测语音 ->
-(void)getBaiduText:(NSString *)text {
    /*--- 原话展示 ---*/
    [DFAction mainTask:^{
        [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"1", @"TEXT" : text}];
        [self getInterData:text ];
    }];
    
    
    /*
     [[OldTreeManager sharedInstance] oldTreeAnalysisText:text
     Result:^(OTAnalysisResult *result,
     BOOL status)
     {
     __weak typeof(self) wSelf = self;
     NSString *url = result.talkUrl;
     //NSLog(@"res:%@",result);
     
     if (result.talkValue.length > 0) {
     [DFAction mainTask:^{
     [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":(NSString *)result.talkValue}];
     }];
     
     [[JL_XMPlayer sharedInstance] playItem:url Block:^{
     [wSelf dealWith:result];
     }];
     }else {
     [wSelf dealWith:result];
     }
     }];
     */
}


-(void)dealWith:(OTAnalysisResult*)analysisResult {
    int field = analysisResult.field;
    
    //百科问答
    if (field == 0) {
        // *--- 继续播放上一个player的音乐
        //[DFAudioPlayer didContinueLast];
        DFAudioPlayer *audio = [DFAudioPlayer currentPlayer];
        [audio didContinue];
    }
    //点歌
    if (field == 1) {
        
        NSString *playId = nil;
        
        if (analysisResult.songUrl) {
            
            OTSongInfo *songInfo = [[OTSongInfo alloc] init];
            songInfo.getId      = analysisResult.songId;
            songInfo.songUrl    = analysisResult.songUrl;
            songInfo.songAuthor = analysisResult.songAuthor;
            songInfo.title      = analysisResult.songName;
            songInfo.songName   = analysisResult.songName;
            
            MusicOfPhoneMode *model = [[MusicOfPhoneMode alloc] init];
            model.mIndex     = 0;
            model.mUrl       = analysisResult.songUrl;
            model.mMediaItem = songInfo;
            NSArray *array   = @[model];
            
            [[DFAudioPlayer sharedMe_2] setNetPaths:array];
            playId = songInfo.getId;
            NSLog(@"--->1 play index %@",playId);
            
        }
        if (![analysisResult.albumId isEqualToString:@"0"]) {
            
            [[OldTreeManager sharedInstance] oldTreequeryAlbum:analysisResult.albumId
                                                       TimeOut:30
                                                       TimeCnt:1
                                                        Result:^(OTAlbumInfo *result)
             {
                 if (result) {
                     if (result.songCount>0) {
                         NSMutableString *string = [NSMutableString new];
                         for (NSString *str in  result.songNameArray) {
                             if (string.length<1) {
                                 [string appendString:str];
                             }else{
                                 NSString *tmpStr = [NSString stringWithFormat:@"\n%@",str];
                                 [string appendString:tmpStr];
                             }
                         }
                         
                         [DFAction mainTask:^{
                             //[DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":string}];
                         }];
                     }
                     
                     if (result.songArray.count>0) {
                         //请求详细的歌曲信息
                         [[OldTreeManager sharedInstance] oldTreePlaySongInfo:result.songArray
                                                                      TimeOut:30
                                                                      TimeCnt:1
                                                                       Result:^(NSArray *result)
                          {
                              if (result) {
                                  int play_index = 0;
                                  NSMutableString *tmpStrIng = [NSMutableString string];
                                  NSMutableArray *listArray = [NSMutableArray array];
                                  NSMutableArray *tmpArray = [NSMutableArray new];
                                  for (int i = 0;i<result.count;i++) {
                                      
                                      OTSongInfo *songitem = result[i];
                                      MusicOfPhoneMode *model = [MusicOfPhoneMode new];
                                      model.mIndex = i;
                                      model.mTitle = songitem.songName;
                                      model.mUrl = songitem.songUrl;
                                      model.mTime = songitem.timelen;
                                      model.mMediaItem = songitem;
                                      NSLog(@"--->2 play index %@",songitem.songId);
                                      
                                      NSString *getId = songitem.songId;
                                      if ([getId isEqual:playId]) {
                                          play_index = i;
                                          NSLog(@"---> play index %d",play_index);
                                      }
                                      
                                      if (model.mUrl && model.mTitle) {
                                          [tmpArray addObject:model];
                                          [tmpStrIng appendString:[NSString stringWithFormat:@"%@ \n",model.mTitle]];
                                          [listArray addObject:[OTSongInfo apiResponseToDictionary:songitem]];
                                      }
                                  }
                                  
                                  NSMutableArray *mResult = [NSMutableArray array];
                                  for (NSString *string in listArray) {
                                      if (![mResult containsObject:string]) {
                                          [mResult addObject:string];
                                      }
                                  }
                                  [listArray setArray:mResult];
                                  
                                  [DFAction mainTask:^{
                                      [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"2", @"TEXT":tmpStrIng,@"LIST":listArray}];
                                      [[DFAudioPlayer sharedMe_2] setNetPaths:tmpArray];
                                  }];
                                  
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      [[DFAudioPlayer sharedMe] didStop];
                                      [[DFAudioPlayer sharedMe_2] didPlay:play_index];
                                  });
                              }
                          }];
                     }else{
                         [[DFAudioPlayer sharedMe_2] didPlay:0];
                     }
                 }else{
                     [[DFAudioPlayer sharedMe_2] didPlay:0];
                 }
             }];
        }else{
            [[DFAudioPlayer sharedMe_2] didPlay:0];
        }
    }
    //播放控制
    if (field == 2) {
        DFAudioPlayer_TYPE now_type = [DFAudioPlayer currentType];
        DFAudioPlayer *player = [DFAudioPlayer currentPlayer];
        static float volume = 0.5;
        
        if (now_type == DFAudioPlayer_TYPE_NET) {
            volume = player.mNetPlayer.mPlayer.volume;
        }else{
            volume = player.mPlayer.volume;
        }
        
        [DFAction mainTask:^{
            int intention = analysisResult.intention;
            //上一曲;
            if (intention == 0) {
                NSString *previoustr = @"播放上一曲";
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"0", @"TEXT" : previoustr}];
                [[JL_BDSpeechAI sharedMe] speakTxt:previoustr Result:^{
                    [player didBefore];
                }];
            }
            //下一曲；
            if (intention == 1) {
                NSString *nextStr = @"播放下一曲";
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"0", @"TEXT" : nextStr}];
                [[JL_BDSpeechAI sharedMe] speakTxt:nextStr Result:^{
                    [player didNext];
                }];
            }
            //播放；
            if (intention == 2) {
                NSString *playStr = @"播放";
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"0", @"TEXT" : playStr}];
                [[JL_BDSpeechAI sharedMe] speakTxt:playStr Result:^{
                    [player didContinue];
                }];
            }
            //暂停；
            if (intention == 3) {
                NSString *pauseStr = @"暂停";
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"0", @"TEXT" : pauseStr}];
                [[JL_BDSpeechAI sharedMe] speakTxt:pauseStr Result:^{
                    [player didPause];
                }];
            }
            //停止播放;
            if (intention == 4) {
                NSString *pauseStr = @"停止播放";
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"0", @"TEXT" : pauseStr}];
                [[JL_BDSpeechAI sharedMe] speakTxt:pauseStr Result:^{
                    [player didPause];
                }];
            }
            //音量加
            if(intention == 5){
                NSString *str = @"调大音量";
                
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0", @"TEXT":str}];
                [[JL_BDSpeechAI sharedMe] speakTxt:str Result:^{
                    volume = volume + 0.1;
                    if (volume > 1.0f) volume = 1.0f;
                    [player setPhoneVolume:volume];
                    [player didContinue];
                }];
            }
            //音量减
            if(intention == 6){
                NSString *str = @"调小音量";
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":str}];
                [[JL_BDSpeechAI sharedMe] speakTxt:str Result:^{
                    volume = volume - 0.1;
                    if (volume < 0) volume = 0;
                    [player setPhoneVolume:volume];
                    [player didContinue];
                }];
            }
        }];
    }
    //智能提醒
    if (field == 3) {
        if(analysisResult.intention==1){ //不提醒
            [DFAction mainTask:^{
                NSString *cancelAlert=@"好的，那我不提醒你啦";
                [[JL_BDSpeechAI sharedMe] speakTxt:cancelAlert];
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":cancelAlert}];
            }];
        }else if(analysisResult.intention==0){ //提醒
            NSString *task = analysisResult.intentionParam1;
            NSString *time = analysisResult.intentionParam2;
            
            NSLog(@"---analysisResult---param1---%@",task); //事件
            NSLog(@"---analysisResult---param2---%@",time); //时间
            [self delayTime:time Task:task];
        }
    }
}

-(void)delayTime:(NSString *)time Task:(NSString*)task{
    NSDateFormatter *dataFormate = [[NSDateFormatter alloc] init];
    [dataFormate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //[dataFormate setTimeZone:[NSTimeZone systemTimeZone]];//解决8小时时间差问题
    alarmDate = [dataFormate dateFromString:time];
    
    NSDate *nowData = [NSDate date];
    NSTimeInterval gap = [DFTime gapOfDateA:alarmDate DateB:nowData];
    NSLog(@"---->延时时间:%f",gap);
    
    
    [DFAction mainTask:^{
        NSString *resultStr = [NSString stringWithFormat:@"好的，将在%@提醒%@",time,task];
        [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":resultStr}];
        [[JL_BDSpeechAI sharedMe] speakTxt:resultStr];
    }];
    
    
    [DFAction delay:gap Task:^{
        NSString *resultStr = [NSString stringWithFormat:@"小杰提醒您，该%@了",task];
        [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":resultStr}];
        [[JL_BDSpeechAI sharedMe] speakTxt:resultStr];
        
        char buf[2] = {0x00,0x01};
        NSData *dat = [NSData dataWithBytes:buf length:2];
        [JL_BLE_Cmd cmdUser_1:0xB1 Buffer:dat];
        NSLog(@"延时处理。。。。。。。。");
    }];
}

-(void)dateTimeAdd{
    NSDate *nowDate = [NSDate date];
    
    if ([nowDate timeIntervalSince1970] > [alarmDate timeIntervalSince1970]) {
        NSLog(@"闹钟时间到了");
        NSString *resultStr = [NSString stringWithFormat:@"小杰提醒您，该%@了",tips];
        [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":resultStr}];
        [[JL_XMPlayer sharedInstance] pause];
        [[JL_BDSpeechAI sharedMe] speakTxt:resultStr];
        [dateCheck invalidate];
    }
}

#pragma mark Show等待UI
-(void)startLoadingView:(NSString*)text{
    UIWindow *win = [DFUITools getWindow];
    loadingView = [DFUITools showHUDWithLabel:text onView:win
                                        color:[UIColor blackColor]
                               labelTextColor:[UIColor whiteColor]
                       activityIndicatorColor:[UIColor whiteColor]];
    [DFAction delay:10.0 Task:^{
        [self->loadingView hide:YES];
    }];
}

#pragma mark Close等待UI
-(void)endLoadingView{
    [DFAction mainTask:^{
        [self->loadingView hide:YES];
    }];
}

-(void)addNote{
    [DFNotice add:kJL_RECORD_PATH Action:@selector(noteRecordPath:) Own:self];
    [DFNotice add:JL_INTER_SERVER_URL Action:@selector(getInterServerUrl:) Own:self];
    [DFNotice add:kDFAudioPlayer_NOTE Action:@selector(musicState:) Own:self];
    [DFNotice add:@"indexPathRow" Action:@selector(indexPathRow:) Own:self];
    
}

//获取时间戳
- (NSInteger)dateToTimeStampAtThe:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:date];
    return [lastDate timeIntervalSince1970];
}
//获取当前时间
- (NSString *)getsTheCurrentTime{
    NSDate * da = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * string = [formatter stringFromDate:da];
    return string;
}

-(void)dealloc{
    [DFNotice remove:kJL_RECORD_PATH Own:self];
    [DFNotice remove:JL_INTER_SERVER_URL Own:self];
    
    [DFNotice remove:kDFAudioPlayer_NOTE Own:self];
    [DFNotice remove:@"indexPathRow" Own:self];
    
}


#pragma mark TTS语音合成
/*TTS*/
- (void)setAudioConfig{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

-(void)initTTS{
    
    NSMutableDictionary *authConfigDic = [[NSMutableDictionary alloc] init];
    //[authConfigDic setObject:@"prod" forKey:K_AILAS_KEY];
    
    
    [authConfigDic setObject:@"sss" forKey:K_USER_ID]; //任意数字、字母组合
    [authConfigDic setObject:@"278576725" forKey:K_PRODUCT_ID];//用户产品ID
    [authConfigDic setObject:@"e984b9b0e9fa6d32821f48135c0232ab" forKey:K_API_KEYS];//用户授权key
    
    [DUILiteAuth setLogEnabled:YES];
    [DUILiteAuth setAuthConfig:self config:authConfigDic];
}

- (void)ttsStartAction:(NSString *)text {
    
    if (!self.player) {
        self.player = [[AISTTSPlayer alloc] init];
    }
    
    //设置协议委托对象
    self.player.delegate = self;
    
    //设置合成参数
    self.player.refText = text;
    self.player.speed = 0.9;
    self.player.volume = 95.0;
    self.player.speaker = @"lili1f_shangwu";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //开始合成
        [self.player startTTS];
    });
}

#pragma mark -AISTTSPlayerDelegate
//合成完成
-(void)onAISTTSInitCompletion{
    [self.cutToPlayer stop];
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"云端合成完成");
    dispatch_async(dispatch_get_main_queue(), ^{
        //        self.tipLabel.text = @"";
    });
}

//播放完成
-(void)onAISTTSPlayCompletion{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"云端播放完成");
    
    if(isPrologue == YES){
        //继续播放序幕
        prologueIndex++;
        if(prologueIndex < prologueArr.count){
            [self playPrologue:prologueIndex];
        }else{
            isPrologue = NO;
        }
    }else{
        if([sModel.servcie isEqualToString:@"reminder"]){
            self->_textContent = [NSString stringWithFormat:@"%@", sModel.content];
            
            if(_isReminder==YES){
                [self performSelector:@selector(playCutTo) withObject:nil afterDelay:2];
            }else{
                [self jieliSDK];
                [self performSelector:@selector(playCutTo) withObject:nil afterDelay:delay];
                _isReminder = YES;
            }
        }else{
            [self jieliSDK];
        }
    }
}
-(void)playCutTo{
    times++;
    if(times<10){
        [DFNotice post:kJL_BDTalk Object:@{@"TYPE" : @"0", @"TEXT" : self->_textContent}];
        [self ttsStartAction:self->_textContent];
    }
}
-(void)playCutToMusic{
    [_cutToPlayer play];
}

-(void)stopCutTopMusic{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_player pauseTTS];
    [_player stopTTS];
    [_cutToPlayer stop];
    _isReminder = NO;
    isPrologue = NO;
    times = 0;
}

//错误
-(void)onAISTTSError:(NSError *)error{
    NSLog(@"%s error = %@",__FUNCTION__,error);
    dispatch_async(dispatch_get_main_queue(), ^{
        //        self.tipLabel.text = @"合成失败";
    });
}
-(void) onAuthResult:(BOOL) message{
    NSLog(@"auth is %@", message ? @"YES" : @"NO");
}

-(void) onAuthError:(NSString*) error{
    NSLog(@"authError is %@", error);
}

/*TTS*/

@end
