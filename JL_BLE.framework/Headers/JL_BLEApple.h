//
//  JL_BLEApple.h
//  BTMate2
//
//  Created by DFung on 2017/11/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <DFUnits/DFUnits.h>

extern NSString *JL_BLE_SERVICE;       //服务【命令】
extern NSString *JL_BLE_WRITE_CMD;     //命令“写”通道
extern NSString *JL_BLE_READ_CMD;      //命令“读”通道
extern NSString *JL_BLE_WRITE_PAIR;    //配对“写”通道
extern NSString *JL_BLE_READ_PAIR;     //配对“读”通道
extern NSString *JL_BLE_READ_SPEEX;    //SPEEX“读”通道
extern NSString *JL_BLE_USER_WRITE;    //自定义通道 “写”
extern NSString *JL_BLE_USER_READ;     //自定义通道 “读”
extern NSString *JL_BLE_UPDATE_SERVICE;//服务【固件升级】
extern NSString *JL_BLE_WRITE_UPDATE;  //固件升级“写”
extern NSString *JL_BLE_READ_UPDATE;   //固件升级“读”

/**
 *  记录上次BLE设备的UUID，准备重连！
 */
#define kDF_BLE_UUID    @"DF_BLE_UUID"

@interface JL_BLEApple : NSObject
@property(nonatomic,strong)NSData *filterKey;
@property(nonatomic,strong)NSData *pairKey;
@property(nonatomic,assign)BOOL BLE_FILTER_ENABLE;
@property(nonatomic,assign)BOOL BLE_PAIR_ENABLE;
@property(nonatomic,assign)BOOL BLE_RELINK;

-(void)stopScanBLE;
-(void)startScanBLE;
-(void)newScanBLE;
-(void)connectBLE:(CBPeripheral*)peripheral;
-(void)disconnectBLE;
-(BOOL)writeCmdData:(NSData*)data;
-(BOOL)writePairData:(NSData*)data;
-(BOOL)writeUserData:(NSData*)data;
-(BOOL)writeUpdateData:(NSData*)data MaxLen:(int)mtu;

-(void)cleanBLE;

@end
