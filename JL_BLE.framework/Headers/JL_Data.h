//
//  JL_Data.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/28.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLE_SDK.h"
#import "JL_BLE_Cache.h"


@interface JL_Data : NSObject

@property(nonatomic,assign)uint16_t       DATA_package_flag;
@property(nonatomic,assign)uint16_t       DATA_all_data_crc;
@property(nonatomic,assign)uint16_t       DATA_lenght_6_N;
@property(nonatomic,strong)NSMutableArray *DATA_JFrames;
@property(nonatomic,strong)NSMutableArray *DATA_JFF_Names;

+(NSData*)makeMe:(uint16_t)pkg_flag
             Crc:(uint16_t)crc
            Data:(NSData*)data;

+(JL_Data*)didResolve:(NSData*)data;

//专门解析设备目录数据，工程会单独用DATA结构发目录数据
//+(JL_Data*)didResolve_1:(NSData*)data;


@end





/*
 *  温馨提示：
 *      0 -> UNICODE    NSUTF16LittleEndianStringEncoding
 *      1 -> ANSI       NSUTF8StringEncoding
 *      2 -> GBK        kCFStringEncodingGB_18030_2000
 */
@interface JL_Frame : NSObject

@property(nonatomic,strong)NSString *FRAME_ID;
@property(nonatomic,assign)uint32_t FRAME_lenght;
@property(nonatomic,assign)uint8_t  FRAME_encode;
@property(nonatomic,strong)NSData   *FRAME_data;

#pragma mark 特别帧数据【FITP】 文件类型 (暂时没用)
@property(nonatomic,assign)uint8_t  FRAME_File_type;
@property(nonatomic,assign)uint8_t  FRAME_File_type_code;
@property(nonatomic,assign)uint32_t FRAME_File_type_lenght;
@property(nonatomic,strong)NSString *FRAME_File_type_buf;

#pragma mark 特别帧数据【PATH】 路径信息
@property(nonatomic,assign)uint8_t  FRAME_Path_type;
@property(nonatomic,assign)uint8_t  FRAME_Path_data_code;
@property(nonatomic,assign)uint16_t FRAME_Path_data_lenght;
@property(nonatomic,assign)uint32_t FRAME_Path_start_num;
@property(nonatomic,strong)NSData   *FRAME_Path_data;

//pragma mark ---> FRAME结构
+(NSData*)makeMeID:(NSString*)f_ID
            Encode:(uint32_t)f_ec
              Data:(NSData*)f_data;

//pragma mark ---> PATH_DATA_S结构 + FRAME结构
+(NSData*)makeMePATH_Type:(uint8_t)pt
                     Code:(uint8_t)cd
                 StartNum:(uint32_t)sn
                 PathData:(NSData*)pdata;

+(NSMutableArray*)didResolve:(NSData*)data;
+(JL_Frame*)didFilterFrames:(NSArray*)frames FrameID:(NSString*)text;

@end

#pragma mark FILE_FLODER_NAME 结构类
@interface JL_FF_Name : NSObject

@property(nonatomic,assign)uint8_t      FF_name_type;
@property(nonatomic,assign)uint8_t      FF_name_code;
@property(nonatomic,strong)NSString     *FF_name_data;
@property(nonatomic,assign)uint32_t     FF_name_cluster;
@property(nonatomic,assign)uint8_t      FF_level;   //目录层级
@property(nonatomic,strong)NSMutableData*FF_clus;   //目录clus

+(JL_FF_Name*)didResolve:(NSData*)data;


@end






