//
//  CalculatorProcessor.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "CalculatorProcessor.h"
//#import "JL_BDSpeechAI.h"
//#import "JLDefine.h"
#import "JL_XMPlayer.h"

@implementation CalculatorProcessor

+(void)handleWithDictionary:(NSDictionary *)resultDic{

    NSDictionary *mainObjc = resultDic[@"object"];
    NSString *resultStr =  [NSString stringWithFormat:@"计算的结果是：%@",mainObjc[@"answer"]];
    
    [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":resultStr}];
    [[JL_XMPlayer sharedInstance] pause];
    [[JL_BDSpeechAI sharedMe] speakTxt:resultStr];
    

}


@end
