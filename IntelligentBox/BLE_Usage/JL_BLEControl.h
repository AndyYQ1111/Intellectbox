//
//  JL_BLEControl.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"

/**
 *  是否开启【蓝牙设备过滤】
 */
#define kBLE_FILTER_ENABLE  1

/**
 *  是否开启【蓝牙特殊配对】
 */
#define kBLE_PAIR_ENABLE    1

/**
 *  是否启用【第三方蓝牙API】
 */
#define kBLE_3rd_ENABLE     0

@interface JL_BLEControl : NSObject
@property(nonatomic,strong)NSData *filterKey;
@property(nonatomic,strong)NSData *pairKey;

-(void)stopScanBLE;
-(void)startScanBLE;
-(void)connectBLE:(CBPeripheral*)peripheral;
-(void)disconnectBLE;

-(BOOL)writeCharacterCBWBytes:(NSData*)bytes;
-(void)writePairBytes:(NSData*)bytes;
-(BOOL)writeUpdateData:(NSData*)data MaxLen:(int)mtu;

@end
