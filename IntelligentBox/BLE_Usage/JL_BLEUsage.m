//
//  JL_BLEUsage.m
//  AiRuiSheng
//
//  Created by DFung on 2017/2/20.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import "JL_BLEUsage.h"

@implementation JL_BLEUsage

static JL_BLEUsage *ME = nil;
+(id)sharedMe{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ME = [[self alloc] init];
    });
    return ME;
}

- (instancetype)init {
    self = [super init];
    if (self) { 
        _bt_name = @"";
        _btEnityList = [NSMutableArray new];

        /*--- 蓝牙搜索过滤秘钥 ---*/
        //Byte fKey[16] = {'J','L','S','M','A','R','T'};
        //NSData *filterKey = [NSData dataWithBytes:fKey length:7];
        
        
        /*--- LinkKey配对密码设置 ---*/
        //Byte pKey[16] = {0x06,0x77,0x5f,0x87,0x91,0x8d,0xd4,0x23,0x00,0x5d,0xf1,0xd8,0xcf,0x0c,0x14,0x2b};
        //NSData *pairKey = [NSData dataWithBytes:pKey length:16];
        
        
#if kBLE_3rd_ENABLE
        _JL_ble_control = [JL_BLEControl new];
        _JL_ble_control.filterKey = nil;        //蓝牙过滤密码（nil = 默认以上设置）
        _JL_ble_control.pairKey   = nil;        //蓝牙配对密码（nil = 默认以上设置）
#else
        _JL_ble_apple = [JL_BLEApple new];
        _JL_ble_apple.filterKey = nil;          //蓝牙过滤密码（nil = 默认以上设置）
        _JL_ble_apple.pairKey   = nil;          //蓝牙配对密码（nil = 默认以上设置）
        _JL_ble_apple.BLE_RELINK= YES;          //开启自动回连
        _JL_ble_apple.BLE_FILTER_ENABLE = kBLE_FILTER_ENABLE;
        _JL_ble_apple.BLE_PAIR_ENABLE   = kBLE_PAIR_ENABLE;
#endif
        
        /*--- 开启SDK打印 ---*/
        [JL_BLE_SDK openLog:YES];
        
        /*--- 实例蓝牙模块 ---*/
        _JL_ble_core = [JL_BLE_Core sharedMe];
        [_JL_ble_core KeepGetMode:NO];//禁止模式信息【自动获取】。
        
        [self addNote];
        NSLog(@"Created【 JL_BLEUsage 】.");
    }
    return self;
}
 
#pragma mark 监听所有事件
-(void)allNoteListen:(NSNotification*)note {
    NSString *name = note.name; 
    
    /*--- JL_BLE_SDK 发送配对数据！---*/
    if ([name isEqual:kBT_SEND_PAIR_DATA]) {
        NSData *bleData = [note object];
        
        if (_bt_status_phone && _bt_status_connect) {
#if kBLE_3rd_ENABLE
            [_JL_ble_control writePairBytes:bleData];
#else
            [_JL_ble_apple writePairData:bleData];
#endif
        }
    }
    
    /*--- JL_BLE_SDK 发送固件升级数据！---*/
    if ([name isEqual:kBT_SEND_UPDATE_DATA]) {
        NSDictionary *dic = [note object];
        NSData *bleData = dic[@"DATA"];
        int len = [dic[@"MTU"] intValue];
        
        if (_bt_status_phone && _bt_status_connect) {
#if kBLE_3rd_ENABLE
            [_JL_ble_control writeUpdateData:bleData MaxLen:len];
#else 
            [_JL_ble_apple writeUpdateData:bleData MaxLen:len];
#endif
        }
    }
    
    /*--- JL_BLE_SDK 请求发送数据！---*/
    if ([name isEqual:kBT_SEND_DATA]) {
        NSData *bleData = [note object];
        
        if (_bt_status_phone && _bt_status_connect) {
#if kBLE_3rd_ENABLE
            [_JL_ble_control writeCharacterCBWBytes:bleData];
#else
            [_JL_ble_apple writeCmdData:bleData];
#endif
        }
    }
    
    if ([name isEqual:kBT_DEVICES_DISCOVERED])
    {
        [_btEnityList removeAllObjects];
        NSMutableSet *peripherals = [note object];
        
        for (CBPeripheral *item in peripherals)
        {
            JL_CommonEntiy *entity = [JL_CommonEntiy new];
            entity.mItem = item.name;
            entity.mPeripheral = item;
            [_btEnityList addObject:entity];
            [DFNotice post:kUI_DEVICES_DISCOVERED Object:nil];
        }
    }
    
    if ([name isEqual:kBT_DEVICE_CONNECTED])
    {
        _bt_status_connect = YES;
        CBPeripheral *currrentPeripheral = [note object];
        
        for (JL_CommonEntiy *item in _btEnityList)
        {
            item.isSelectedStatus = NO;
            if (item.mItem == currrentPeripheral.name &&
                item.mPeripheral.identifier == currrentPeripheral.identifier)
            {
                item.isSelectedStatus = YES;
                _bt_name = item.mItem;
            }
        }
        [DFNotice post:kUI_DEVICE_CONNECTED Object:_bt_name];
    }
    
    if ([name isEqual:kBT_DEVICE_DISCONNECT]) {
        _bt_status_connect = NO;
        for (JL_CommonEntiy *item in _btEnityList) {
            item.isSelectedStatus = NO;
        }
        _bt_name = @"";
        NSString *out_dev_name = [note object];
        [DFNotice post:kUI_DEVICE_DISCONNECT Object:out_dev_name];
    }
    
    if ([name isEqual:kBT_CONNECTED]) {
        _bt_status_phone = YES;
        [DFNotice post:kUI_CONNECTED Object:nil];
    }
    
    if ([name isEqual:kBT_DISCONNECTED]) {
        _bt_status_connect = NO;
        _bt_status_phone = NO;
//        [self showAlertView];
        
        for (JL_CommonEntiy *item in _btEnityList){
            item.isSelectedStatus = NO;
        }
        _bt_name = @"";
        [DFNotice post:kUI_DISCONNECTED Object:nil];
    }
}

- (void)showAlertView {
    NSString *txt = @"请确保两点：\n1.设置->蓝牙->打开！\n2.拖出iPhone屏幕下方的控制版，点亮蓝牙图标。";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机蓝牙未打开"
                                                    message:txt
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"好", nil];
    [alert show];
}

-(void)addNote{
    //[DFNotice add:kBT_SEND_DATA Action:@selector(noteBluetoothSend:) Own:self];
    [DFNotice add:nil Action:@selector(allNoteListen:) Own:self];
}


-(void)dealloc{
    //[DFNotice remove:kBT_SEND_DATA Own:self];
    [DFNotice remove:nil Own:self];
}


@end
