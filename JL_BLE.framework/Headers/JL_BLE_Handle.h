//
//  JL_BLE_Handle.h
//  AiRuiSheng
//
//  Created by DFung on 2017/3/1.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLE_SDK.h"
#import "JL_BLE_Core.h"

@interface JL_BLE_Handle : NSObject
@property(nonatomic,assign)uint16_t cmdPending;     //设备的待处理指令数
@property(nonatomic,assign)NSTimeInterval askTime;  //询问设备的间隔

+(id)sharedMe;

#pragma mark 让蓝牙库发数据
-(void)sendBLEData:(NSData*)data Tag:(uint32_t)tag;

#pragma mark  重置一下发送90间隔
-(void)setAskTime:(NSTimeInterval)askTime;

-(void)enableCMD_90:(BOOL)en;

-(void)enableGetMode:(BOOL)en;

@end
