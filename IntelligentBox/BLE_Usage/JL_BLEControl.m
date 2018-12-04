//
//  JL_BLEControl.m
//  AiRuiSheng
//
//  Created by DFung on 2017/2/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import "JL_BLEControl.h"
#import "JL_BLEUsage.h"


static NSString *BLE_BOX_SERVICE    = @"AE00";//="AE00"//text service uuid
static NSString *BOX_WRITE_CHARTER  = @"AE01";//="AE01" //text write outof respond and read charter uuid
static NSString *BOX_NOTIFY_CHARTER = @"AE02";//="AE02" //text notify charter uuid
static NSString *PAIR_WRITE_CHARTER = @"AE03";//="AE03" //text notify charter uuid
static NSString *PAIR_NOTIFY_CHARTER = @"AE04";//="AE04" //text notify charter uuid

static NSString *BLE_READ_SPEEX_06  = @"AE06";  //SPEEX“读”通道

static NSString *BLE_WRITE_UPDATE = @"00001532-1212-EFDE-1523-785FEABCD123";    //固件升级“写”
static NSString *BLE_READ_UPDATE  = @"00001531-1212-EFDE-1523-785FEABCD123";    //固件升级“读”


static int DEFINITED_LENGTH_BY_JL   = 45;

static BabyBluetooth    *bleShareInstance;
static NSMutableSet     *peripherallist;
static NSMutableArray   *servicelist;
static NSMutableArray   *characterlist;
static CBCharacteristic *readCharacter;
static CBCharacteristic *writeCharacter;

static CBCharacteristic *pairReadCharacter;
static CBCharacteristic *pairWriteCharacter;

static CBCharacteristic *charSpeexRead_06;

static CBCharacteristic *charUpdateRead;
static CBCharacteristic *charUpdateWrite;



static int recvIndex = 0;



@interface JL_BLEControl (){

@public
    CBPeripheral *currentConnectedPeripheral;
}

@end


@implementation JL_BLEControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        bleShareInstance = [BabyBluetooth shareBabyBluetooth];
        [self bleScanDelegate];
        NSLog(@"-------------> JL_BLEControl");
    }
    return self;
}


-(void)stopScanBLE{
    [bleShareInstance cancelScan];
}

-(void)startScanBLE{
    peripherallist = [NSMutableSet new];
    [bleShareInstance scanForPeripherals];
    [bleShareInstance begin];
}

-(void)connectBLE:(CBPeripheral*)peripheral{
    if (peripherallist.count <= 0) return;

    for (CBPeripheral *item in peripherallist) {
        if (item.identifier == peripheral.identifier)
        {
            currentConnectedPeripheral = peripheral;
            BabyBluetooth *bt = [bleShareInstance having:currentConnectedPeripheral];
            bt = [bt discoverServices];
            bt = [bt discoverCharacteristics];
            [bt begin];
            NSLog(@"Connecting... Device Name ----> %@",peripheral.name);
        }
    }
}

-(void)disconnectBLE{
    [bleShareInstance cancelAllPeripheralsConnection];
}


#pragma mark - 发送【命令】数据
-(BOOL)writeCharacterCBWBytes:(NSData*)bytes{
    if (currentConnectedPeripheral && writeCharacter) {
        [self writeBytes:bytes];
        return YES;
    }
    return NO;
}


#pragma mark - 发送【蓝牙配对】数据
-(void)writePairBytes:(NSData*)bytes{
    NSLog(@"SEND --> %@",bytes);
    [currentConnectedPeripheral writeValue:[bytes subdataWithRange:NSMakeRange(0, bytes.length)]
                         forCharacteristic:pairWriteCharacter
                                      type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark - 发送【固件升级】数据
static int max_len = 45;
-(BOOL)writeUpdateData:(NSData*)data MaxLen:(int)mtu
{
    /*--- 设置固件升级每包数据大小 ---*/
    if (mtu <= 0) {
        max_len = 45;
    }else{
        max_len = mtu;
    }
    
    if (currentConnectedPeripheral && charUpdateWrite && data.length > 0) {
        NSInteger len = data.length;
        while (len>0) {
            if (len == 0) break;
            
            if (len <= max_len) {
                [currentConnectedPeripheral writeValue:[data subdataWithRange:NSMakeRange(0, data.length)]
                               forCharacteristic:charUpdateWrite
                                            type:CBCharacteristicWriteWithoutResponse];
                len -= data.length;
            }else{
                
                
                [currentConnectedPeripheral writeValue:[data subdataWithRange:NSMakeRange(0, max_len)]
                               forCharacteristic:charUpdateWrite
                                            type:CBCharacteristicWriteWithoutResponse];
                len -= max_len;
                data = [data subdataWithRange:NSMakeRange(max_len, len)];
            }
        }
        return YES;
    }
    return NO;
}


#pragma mark 蓝牙发送数据！
-(void)writeBytes:(NSData*)bytes{
    NSInteger len = bytes.length;
    NSData *data = bytes;
    while (len>0) {
        if (len == 0) break;
        
        if (len <= 45) {
            [currentConnectedPeripheral writeValue:[data subdataWithRange:NSMakeRange(0, data.length)]
                                 forCharacteristic:writeCharacter
                                              type:CBCharacteristicWriteWithoutResponse];
            len -= data.length;
        }else{
            [currentConnectedPeripheral writeValue:[data subdataWithRange:NSMakeRange(0, DEFINITED_LENGTH_BY_JL)]
                                 forCharacteristic:writeCharacter
                                              type:CBCharacteristicWriteWithoutResponse];
            len -= DEFINITED_LENGTH_BY_JL;
            data = [data subdataWithRange:NSMakeRange(DEFINITED_LENGTH_BY_JL, len)];
        }
    }
}


#pragma mark 蓝牙收到数据！
-(void)setCharacterNotify{
    [bleShareInstance notify:currentConnectedPeripheral
              characteristic:readCharacter
                       block:^(CBPeripheral *peripheral,
                               CBCharacteristic *characteristics,
                               NSError *error)
     {
         if (characteristics.value == nil) return;
         [DFNotice post:kBT_RECIVE_DATA Object:characteristics.value];
         
         recvIndex++;
     }];
}




#pragma mark 蓝牙接受配对数据！
-(void)setPairCharacterNotify{
    [bleShareInstance notify:currentConnectedPeripheral
              characteristic:pairReadCharacter
                       block:^(CBPeripheral *peripheral,
                               CBCharacteristic *characteristics,
                               NSError *error)
     {
         if (characteristics.value == nil) return;
         NSLog(@"GET --> %@",characteristics.value);
         [DFNotice post:kBT_REC_PAIR_DATA Object:characteristics.value];
     }];
}


#pragma mark 蓝牙接受SPEEX数据！
-(void)setSpeexCharacterNotify{
    [bleShareInstance notify:currentConnectedPeripheral
              characteristic:charSpeexRead_06
                       block:^(CBPeripheral *peripheral,
                               CBCharacteristic *characteristics,
                               NSError *error)
     {
         if (characteristics.value == nil) return;
         NSLog(@"GET --> %@",characteristics.value);
         [DFNotice post:kBT_REC_SPEEX_DATA Object:characteristics.value];
     }];
}


#pragma mark 蓝牙接受固件升级数据！
-(void)setUpdateCharacterNotify{
    [bleShareInstance notify:currentConnectedPeripheral
              characteristic:charUpdateRead
                       block:^(CBPeripheral *peripheral,
                               CBCharacteristic *characteristics,
                               NSError *error)
     {
         if (characteristics.value == nil) return;
         NSLog(@"Update --> %@",characteristics.value);
         [DFNotice post:kBT_REC_UPDATE_DATA Object:characteristics.value];
     }];
}



#pragma mark 设置扫描代理
-(void)bleScanDelegate{
    __weak typeof(self) w_self = self;

#pragma mark -CBCentralManagerState
    [bleShareInstance setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [DFNotice post:kBT_CONNECTED Object:@"null"];
            
        }
        if (central.state == CBCentralManagerStatePoweredOff) {
            [DFNotice post:kBT_DISCONNECTED Object:@"null"]; 
        }
    }];
    
#pragma mark -DiscoverToPeripheral 发现外设
    [bleShareInstance setBlockOnDiscoverToPeripherals:^(CBCentralManager *central,
                                                        CBPeripheral *peripheral,
                                                        NSDictionary *advertisementData,
                                                        NSNumber *RSSI)
    {
        if (peripheral.name) {
            NSString *ble_name = peripheral.name;
            NSString *ble_uuid = peripheral.identifier.UUIDString;
            NSData   *ble_AD   = (NSData*)advertisementData[@"kCBAdvDataManufacturerData"];
            NSLog(@"Discovered --> BLE name:%@  UUID:%@  Ad:%@",ble_name,ble_uuid,ble_AD);
        
#if kBLE_FILTER_ENABLE
            /*--- 过滤蓝牙设备 ---*/
            BOOL isOk = [JL_BLE_Filter bluetoothKey:self->_filterKey Filter:advertisementData];
            if (isOk) {
                [peripherallist addObject:peripheral];
                [DFNotice post:kBT_DEVICES_DISCOVERED Object:peripherallist];
            }
#else
            [peripherallist addObject:peripheral];
            [DFNotice post:kBT_DEVICES_DISCOVERED Object:peripherallist];
#endif
        }
    }];
    
#pragma mark -DiscoverServices 发现服务
    [bleShareInstance setBlockOnDiscoverServices:^(CBPeripheral *peripheral,
                                                   NSError *error)
    {
        for (CBService *service in peripheral.services) {
            NSLog(@"Discovered ----> Service :%@",service.UUID.UUIDString);
            [servicelist addObject:service];
        }
    }];
    
#pragma mark -DiscoverCharacteristics 发现属性／特征
    [bleShareInstance setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral,
                                                          CBService *service,
                                                          NSError *error)
    {
        for (CBCharacteristic *character in service.characteristics) {
            NSLog(@"Discovered ----> Character : %@",character.UUID.UUIDString);
            [characterlist addObject:character];
            
            if ([character.UUID.UUIDString containsString:BOX_WRITE_CHARTER]) {
                NSLog(@"BLE Get Write Channel ----> %@",character);
                writeCharacter = character;
            }
            
            if ([character.UUID.UUIDString containsString:BOX_NOTIFY_CHARTER]) {
                NSLog(@"BLE Get Read Channel ----> %@ %d",character,character.isNotifying);
                readCharacter = character;
                [w_self setCharacterNotify];
            }
            
            if ([character.UUID.UUIDString containsString:PAIR_WRITE_CHARTER]) {
                NSLog(@"BLE Get Pair(Write) Channel ----> %@",character);
                pairWriteCharacter = character;
            }
            
            if ([character.UUID.UUIDString containsString:PAIR_NOTIFY_CHARTER]) {
                NSLog(@"BLE Get Pair(Read) Channel ----> %@ %d",character,character.isNotifying);
                pairReadCharacter = character;
                [w_self setPairCharacterNotify];
            }
            
            if ([character.UUID.UUIDString containsString:BLE_READ_SPEEX_06]) {
                NSLog(@"BLE Get Speex(Read) Channel ----> %@ %d",character,character.isNotifying);
                charSpeexRead_06 = character;
                [w_self setSpeexCharacterNotify];
            }
            
            if ([character.UUID.UUIDString containsString:BLE_WRITE_UPDATE]) {
                NSLog(@"BLE Get Write Channel ----> %@",character);
                charUpdateWrite = character;
            }
            
            if ([character.UUID.UUIDString containsString:BLE_READ_UPDATE]) {
                NSLog(@"BLE Get Read Channel ----> %@ %d",character,character.isNotifying);
                charUpdateRead = character;
                //[w_self setUpdateCharacterNotify];
            }
        }
    }];
    
#pragma mark -DidUpdateNotificationState 更新通知特征的状态
    [bleShareInstance setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic,
                                                                              NSError *error)
    {
        if (characteristic.isNotifying) {
            [[bleShareInstance readValueForCharacteristic] begin];
            
            if ([characteristic.UUID.UUIDString containsString:BOX_NOTIFY_CHARTER]) {
                NSLog(@"更新特征：%@",BOX_NOTIFY_CHARTER);
                
#if kBLE_PAIR_ENABLE
                [[JL_BLE_Filter sharedMe] bluetoothPairingKey:self->_pairKey Result:^(BOOL ret) {
                    if (ret) {
                        [DFNotice post:kBT_DEVICE_NOTIFY_SUCCEED  Object:@"success"];
                    }else{
                        NSLog(@"Err: bluetooth pairing fail.");
                        [bleShareInstance cancelAllPeripheralsConnection];
                    }
                }];
#else
                [DFNotice post:kBT_DEVICE_NOTIFY_SUCCEED  Object:@"success"];
#endif
            }
        }
    }];
    
#pragma mark -OnConnected 已连接
    [bleShareInstance setBlockOnConnected:^(CBCentralManager *central,
                                            CBPeripheral *peripheral)
    {
        NSLog(@"Connected ----> Device %@",peripheral.name);
        [DFNotice post:kBT_DEVICE_CONNECTED Object:peripheral];
    }];
    
    
#pragma mark -OnFailToConnect 尝试连接失败
    [bleShareInstance setBlockOnFailToConnect:^(CBCentralManager *central,
                                                CBPeripheral *peripheral,
                                                NSError *error)
    {
        NSLog(@"Fail connect ----> Device %@",peripheral.name);
        [DFNotice post:kBT_DEVICE_FAIL_CONNECT Object:peripheral.name];
    }];
    
    
#pragma mark -OnDisconnect 已断开连接
    [bleShareInstance setBlockOnDisconnect:^(CBCentralManager *central,
                                             CBPeripheral *peripheral,
                                             NSError *error)
    {
        NSLog(@"Disconnect ----> Device %@",peripheral.name);
        [DFNotice post:kBT_DEVICE_DISCONNECT Object:peripheral.name];
//        NSLog(@"=============================> 4");
    }];
    
    
#pragma mark -ReadValueForCharacteristic 读值的回调
    [bleShareInstance setBlockOnDidWriteValueForDescriptor:^(CBDescriptor *descriptor,
                                                             NSError *error)
    {
        
    }];
    
#pragma mark -setBlockOnCancelAllPeripheralsConnectionBlock 取消所有外设
    [bleShareInstance setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager)
    {
        NSLog(@"CancelAllPeripherals Connection");
    }];
    
    
#pragma mark -setBlockOnCancelScanBlock 取消扫描
    [bleShareInstance setBlockOnCancelScanBlock:^(CBCentralManager *centralManager)
    {
        NSLog(@"Cancel Scan");
    }];

    
}

#pragma mark -Reconnect or Cancle
-(void)autoReconnect{
    [[BabyBluetooth shareBabyBluetooth] AutoReconnect:currentConnectedPeripheral];
    [[BabyBluetooth shareBabyBluetooth] AutoReconnectCancel:currentConnectedPeripheral];
}






@end
