//
//  JL_Cbw.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/28.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLE_SDK.h"
#import "JL_Data.h"

#define kCBW_signature      @"4a4c4254"

@class JL_Cbw_CB;
@class JL_Data;
@interface JL_Cbw : NSObject

@property(nonatomic,assign)uint32_t CBW_tag;
@property(nonatomic,assign)uint32_t CBW_DataTransferLength;
@property(nonatomic,assign)uint8_t  CBW_requset;
@property(nonatomic,assign)uint8_t  CBW_op;
@property(nonatomic,assign)uint8_t  CBW_mode_num;
@property(nonatomic,assign)uint8_t  CBW_mode_command;
@property(nonatomic,strong)NSData   *CBW_mode_value;
@property(nonatomic,strong)NSData   *CBW_15_16;
@property(nonatomic,strong)NSData   *CBW_Data_raw;
@property(nonatomic,strong)JL_Data  *CBW_Data;

/**
 *   默认 request : 1
 */
+(NSData*)makeMeCBW_Request:(uint8_t)request
                     CBW_CB:(NSData*)mCBW_CB;

+(NSData*)makeMeCBW_Tag:(uint32_t)tag
            CBW_Request:(uint8_t)request
                 CBW_CB:(NSData*)mCBW_CB;

+(JL_Cbw*)didResolve:(NSData*)data;


@end


@interface JL_Cbw_CB : NSObject

+(NSData*)makeMe_OP:(uint8_t)op
           Mode_num:(uint8_t)mNum
       Mode_Command:(uint8_t)mCommand
         Mode_value:(NSData*)mValue;

@end
