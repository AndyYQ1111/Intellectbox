//
//  AlarmProcessor.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AlarmProcessor.h"
#import "JLDefine.h"
#import "JL_XMPlayer.h"

@interface AlarmProcessor(){

    NSTimer    *dateCheck;
    NSTimeInterval targetTime;
    NSDate      *alarmDate;
    NSString    *tips;
}

@end

@implementation AlarmProcessor


+(instancetype)shareInstance{

    static AlarmProcessor *AMe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        AMe = [[AlarmProcessor alloc] init];
        
    });
    
    
    return AMe;
    
    
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        [DFNotice add:kJL_SPEAK_END Action:@selector(speedkOver:) Own:self];
    }
    return self;
}


-(void)handleWithDictionary:(NSDictionary *)resultDic{
    
    NSDictionary *mainObjc = resultDic[@"object"];
    NSString *timeStr = mainObjc[@"time"];
    NSString *dateStr = mainObjc[@"date"];
    NSString *dateTime = [NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
    NSDateFormatter *dataFormate = [[NSDateFormatter alloc] init];
    [dataFormate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    alarmDate = [dataFormate dateFromString:dateTime];
    
    NSDate *nowDate = [NSDate date];
    
    targetTime = [nowDate timeIntervalSince1970];

    [dateCheck invalidate];
    dateCheck = nil;
    dateCheck = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dateTimeAdd) userInfo:nil repeats:YES];

 
    NSString *resultStr = [NSString stringWithFormat:@"好的，将在%@提醒%@",mainObjc[@"_time"],mainObjc[@"_event"]];
    [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":resultStr}];
    
    [[JL_BDSpeechAI sharedMe] speakTxt:resultStr];
    tips = mainObjc[@"_event"];
    

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

-(void)speedkOver:(NSNotification *)note{
    
    
    
}

@end
