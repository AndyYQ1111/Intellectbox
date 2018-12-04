//
//  JL_Csw.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/28.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLE_SDK.h"

#define kCSW_signature      @"42545354"


@interface JL_Csw : NSObject
@property(nonatomic,assign)uint32_t CSW_tag;    //Tag
@property(nonatomic,assign)uint16_t CSW_FW_ACK; //设备正在处理命令数
@property(nonatomic,assign)uint16_t CSW_reason; //错误原因
@property(nonatomic,assign)uint8_t  CSW_status; //0:正常 1:异常
@property(nonatomic,assign)uint8_t  CSW_power;  //电池电量


/**
 *  JL_CBW 指令执行的状态
 *  status: 00: 执行成功
 *          01：执行失败
 *          03：CRC 校验失败
 *          04：模式错误
 *          05：忙状态
 *  flag: 默认为0. (回复多DATA包时，DATA包的序号标识 DATA_PACKAGE_FLAG。)
 */
+(NSData*)makeMe_CSW_Tag:(uint32_t)tag
              CSW_status:(NSString*)status
            CSW_pkg_flag:(uint16_t)flag;

+(JL_Csw*)didResolve:(NSData*)data;



@end

