//
//  WeatherProcessor.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "WeatherProcessor.h" 
#import "GetLocalization.h"
#import "JL_XMPlayer.h"

@implementation WeatherProcessor


+(void)handleWithDictionary:(NSDictionary *)resultDic{


    NSDictionary *mainObjc = resultDic[@"object"];
    NSString *ct = mainObjc[@"_region"];
    if (ct) {
        ct = [ct stringByReplacingOccurrencesOfString:@"市" withString:@""];
        NSString *url = [NSString stringWithFormat:@"https://sapi.k780.com/?app=weather.today&weaid=%@&appkey=29735&sign=2bb4244d8075d4d9134921bea0072ec3&format=json",ct];
        NSString *eUrl = [DFHttp encodeURL:url];
        NSData *tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:eUrl]];
        if (tmpData.length == 0 ) return ;
        
        NSDictionary *mDic = [NSJSONSerialization JSONObjectWithData:(NSData*)tmpData
                                                             options:(NSJSONReadingMutableLeaves)
                                                               error:nil];
        
        [DFAction mainTask:^{
            if ([mDic[@"success"] isEqual:@"1"]) {
                NSString * citynm = mDic[@"result"][@"citynm"];
                NSString * temperature_curr = mDic[@"result"][@"temperature_curr"];
                NSString * weather = mDic[@"result"][@"weather"];
                NSString * wind = mDic[@"result"][@"wind"];
                
                NSString *txt = [NSString stringWithFormat:@"%@天气 %@ 气温%@ 风向%@",citynm,weather,temperature_curr,wind];
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":txt}];
                [[JL_XMPlayer sharedInstance] pause];
                [[JL_BDSpeechAI sharedMe] speakTxt:txt];
            }else{
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":@"抱歉没听清楚,请再说一遍。"}];
                [[JL_XMPlayer sharedInstance] pause];
                [[JL_BDSpeechAI sharedMe] speakTxt:@"抱歉没听清楚,请再说一遍。"];
            }
        }];
            
    }else{
        
        [[GetLocalization sharedInstance] startUpdateLocalization:^(NSString *city) {
            
            city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            NSString *url = [NSString stringWithFormat:@"https://sapi.k780.com/?app=weather.today&weaid=%@&appkey=29735&sign=2bb4244d8075d4d9134921bea0072ec3&format=json",city];
            NSString *eUrl = [DFHttp encodeURL:url];
            NSData *tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:eUrl]];
            if (tmpData.length == 0 ) return ;
            
            NSDictionary *mDic = [NSJSONSerialization JSONObjectWithData:(NSData*)tmpData
                                                                 options:(NSJSONReadingMutableLeaves)
                                                                   error:nil];
            
            [DFAction mainTask:^{
                if ([mDic[@"success"] isEqual:@"1"]) {
                    NSString * citynm = mDic[@"result"][@"citynm"];
                    NSString * temperature_curr = mDic[@"result"][@"temperature_curr"];
                    NSString * weather = mDic[@"result"][@"weather"];
                    NSString * wind = mDic[@"result"][@"wind"];
                    
                    NSString *txt = [NSString stringWithFormat:@"%@天气 %@ 气温%@ 风向%@",citynm,weather,temperature_curr,wind];
                    [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":txt}];
                    [[JL_XMPlayer sharedInstance] pause];
                    [[JL_BDSpeechAI sharedMe] speakTxt:txt];
                }else{
                    [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":@"抱歉没听清楚,请再说一遍。"}];
                    [[JL_XMPlayer sharedInstance] pause];
                    [[JL_BDSpeechAI sharedMe] speakTxt:@"抱歉没听清楚,请再说一遍。"];
                }
            }];
            
            
            
        }];

        
        
        
    }
    
    
}

@end
