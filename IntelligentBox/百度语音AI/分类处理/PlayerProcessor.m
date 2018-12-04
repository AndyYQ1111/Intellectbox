//
//  PlayerProcessor.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "PlayerProcessor.h"
#import "JL_XMPlayer.h"
#import "JLDefine.h"

@implementation PlayerProcessor

+(void)handleWithDictionary:(NSDictionary *)resultDic{

    NSDictionary *doActionDict = resultDic[@"object"];
    if ([doActionDict[@"action_type"] isEqualToString:@"previous"]) {
        [self switchPlayerBeChangeToPrevious];
    }
    if ([doActionDict[@"action_type"] isEqualToString:@"next"]) {
        [self switchPlayerBeChangeToNext];
    }
    if ([doActionDict[@"action_type"] isEqualToString:@"pause"]) {
        [self switchPlayerBeChangeToPause];
    }
    if ([doActionDict[@"action_type"] isEqualToString:@"play"]) {
        [self switchPlayerBeChangeToResume];
    }
    if ([doActionDict[@"action_type"] isEqualToString:@"exitplayer"]) {
        [self switchPlayerBeChangeToPause];
    }
    
}

+(void)switchPlayerBeChangeToPrevious{

    
}

+(void)switchPlayerBeChangeToNext{
    
    
}

+(void)switchPlayerBeChangeToPause{
   
    
}

+(void)switchPlayerBeChangeToResume{
    
    
}


@end
