//
//  CalendarProcessor.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "CalendarProcessor.h"
//#import "JLDefine.h"
//#import "JL_BDSpeechAI.h"
#import "JL_XMPlayer.h"

@implementation CalendarProcessor

+(void)handleWithDictionary:(NSDictionary *)resultDic{

    NSDictionary *mainObjc = resultDic[@"object"];
    NSString *resultStr =  [NSString stringWithFormat:@"%@",mainObjc[@"ANSWER"]];
    [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":resultStr}];
    
    [[JL_XMPlayer sharedInstance] pause];
    [[JL_BDSpeechAI sharedMe] speakTxt:resultStr];


}

@end
