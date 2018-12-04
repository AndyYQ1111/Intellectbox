//
//  MusicProcessor.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MusicProcessor.h"
#import "JL_XMPlayer.h"



@implementation MusicProcessor


+(void)handleWithDictionary:(NSDictionary *)resultDic{
    
    
    
    NSDictionary *mainObjc = resultDic[@"object"];
    NSString *nameStr = mainObjc[@"name"];
    NSString *artistStr;
    if (mainObjc[@"byartist"]) {
        artistStr = mainObjc[@"byartist"][0];
    }
    
    /*---- 百度共用接口 ---*/
    NSString *txt ;
    if (nameStr && artistStr) {
        txt = [NSString stringWithFormat:@"%@ %@",nameStr,artistStr];
    }else{
        if (nameStr) txt = nameStr;
        if (artistStr) txt = artistStr;
    }
    
    [JL_BDMusic searchMusic_2:txt Result:^(NSArray *arr ,NSString *more) {
        if (arr.count > 0){
            int rd = arc4random() % arr.count;
            
            NSDictionary *rd_dic = arr[rd];
            NSString *rd_author = rd_dic[@"MS_AUTHOR"];
            NSString *rd_name   = rd_dic[@"MS_NAME"];
            NSLog(@"play--> %d",rd);

//            NSMutableArray *mArr = [NSMutableArray new];
//            for (int i = 0 ; i< arr.count; i++) {
//
//                NSDictionary *ms_dic = arr[i];
//                NSString *ms_name   = ms_dic[@"MS_NAME"];
//                NSString *ms_author = ms_dic[@"MS_AUTHOR"];
//                NSString *ms_pic    = ms_dic[@"MS_PIC"];
//                NSString *ms_url    = ms_dic[@"MS_URL"];
//            }
        
            
            [DFAction mainTask:^{
                NSString *str = [NSString stringWithFormat:@"正在播放 %@《%@》",rd_author?:@"",rd_name?:@"歌曲"];
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":str}];
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":more}];
                
                [[JL_XMPlayer sharedInstance] pause];
                [[JL_BDSpeechAI sharedMe] speakTxt:str Result:^{
                    
                }];
            }];
            
        }else{
            [DFAction mainTask:^{
                [DFNotice post:kJL_BDTalk Object:@{@"TYPE":@"0",@"TEXT":@"抱歉,我没找到这些音乐。"}];
                [[JL_XMPlayer sharedInstance] pause];
                [[JL_BDSpeechAI sharedMe] speakTxt:@"抱歉,我没找到这些音乐。"];
            }];
        }
    }];
    
//    NSMutableString *tmpStr = [[NSMutableString alloc] init];
//    if (nameStr || artistStr) {
//        if (nameStr)
//            [tmpStr appendString:nameStr];
//        if (artistStr) {
//            [tmpStr appendString:@""];
//            [tmpStr appendString:artistStr];
//        }
//        //            [[JL_XMPlayer sharedInstance] searchSourceWithKeyWord:tmpStr WithCount:20];
//
//    }else{
//
//        for (NSString *key in mainObjc) {
//            [tmpStr appendString:mainObjc[key]];
//        }
//        //            [[JL_XMPlayer sharedInstance] searchSourceWithKeyWord:tmpStr WithCount:20];
//    }
//
//    [[JL_XMSearch sharedInstance] searchSourceWithKeyWordAll:tmpStr WithCount:20];
    
    
}


@end
