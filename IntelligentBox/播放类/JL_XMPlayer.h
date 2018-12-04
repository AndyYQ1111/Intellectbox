//
//  JL_XMPlayer.h
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/15.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLDefine.h"


#define PLAYER_STATUS_NOTE    @"PLAYER_STATUS_NOTE"


typedef enum : NSUInteger {
    MODEL_Single,
    MODEL_Sequential,
    MODEL_Cycle,
    MODLE_Random,
} MODEL_Type;

typedef void(^XM_BLOCK)(void);


@interface JL_XMPlayer : NSObject

//@"PLAYER_STATUS_NOTE"
@property (nonatomic,strong) NSArray *playListArray;
@property (nonatomic,strong) NSString *keyWord;
@property (nonatomic,assign) MODEL_Type modelType;

+(instancetype)sharedInstance;

-(void)playItem:(NSString*)urlStr;

-(void)playItem:(NSString*)urlStr Block:(XM_BLOCK)block;

-(void)play;

-(void)pause;

-(void)stop;
/**
 seeks to a specific time (in seconds)
 
 @param value time in seconds
 */
-(void)seekToTime:(double)value;


@end
