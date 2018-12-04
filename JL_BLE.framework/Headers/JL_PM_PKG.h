//
//  JL_PM_PKG.h
//  JL_BLE
//
//  Created by DFung on 2017/6/29.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_PM_SDK.h"

@interface JL_PM_PKG : NSObject
@property(nonatomic,assign)uint16_t PM_PKG_crc16;
@property(nonatomic,assign)uint16_t PM_PKG_cmd;
@property(nonatomic,assign)uint32_t PM_PKG_id;
@property(nonatomic,assign)uint32_t PM_PKG_len;
@property(nonatomic,strong)NSData  *PM_PKG_raw;

+(NSData*)makePM_PKG_Cmd:(uint16_t)cmd
              PM_PKG_Pid:(uint32_t)pid
              PM_PKG_raw:(NSData*)raw;

+(JL_PM_PKG*)didResolve:(NSData*)data;

@end
