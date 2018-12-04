//
//  JL_BLE_Filter.h
//  JL_BLE
//
//  Created by DFung on 2017/11/15.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DFUnits/DFUnits.h>


typedef void(^BLE_Block)(BOOL ret);
typedef void(^BLE_Update)(int ret);


@interface JL_BLE_Filter : NSObject

+(id)sharedMe;

/**
 *  过滤其余蓝牙设备
 */
//+(BOOL)bluetoothFilter:(NSDictionary*)advertData;
+(BOOL)bluetoothKey:(NSData*)key Filter:(NSDictionary*)advertData;

/**
 *  蓝牙设备配对
 */
-(void)bluetoothPairingKey:(NSData*)pKey Result:(BLE_Block)bk;

/**
 *  固件升级
 */
-(void)bluetoothUpdateFirmwarePath:(NSString*)path Result:(BLE_Update)bk;

@end
