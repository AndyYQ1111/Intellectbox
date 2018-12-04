//
//  JL_Listen.h
//  IntelligentBox
//
//  Created by DFung on 2018/3/21.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLDefine.h"

#define kJL_RECORD_PATH     @"JL_RECORD_PATH"

#define kFIND_PCM           [DFFile findPath:NSLibraryDirectory MiddlePath:@"Speex" File:@"speex.pcm"]
#define kMAKE_PCM           [DFFile createOn:NSLibraryDirectory MiddlePath:@"Speex" File:@"speex.pcm"]
#define kFIND_SPEEX         [DFFile findPath:NSLibraryDirectory MiddlePath:@"Speex" File:@"speex.spx"]
#define kMAKE_SPEEX         [DFFile createOn:NSLibraryDirectory MiddlePath:@"Speex" File:@"speex.spx"]

@interface JL_Listen : NSObject
@property(strong,nonatomic)DFAudio *audioRecoder;
@property(assign,nonatomic)BOOL isMIC;
@property(assign,nonatomic)BOOL isCLOCK;
@property(assign,nonatomic)BOOL isFILE;
@property(assign,nonatomic)BOOL isCONTACT;
@property(assign,nonatomic)BOOL isMAP;
@property(assign,nonatomic)BOOL isIPOD;
@property(assign,nonatomic)BOOL connectBLE; //控制BLE断开

+(id)sharedMe;
-(BOOL)recordStart;
-(void)recordStop;

@end
