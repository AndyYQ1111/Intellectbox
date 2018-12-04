//
//  JL_BLE_Core.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/28.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLE_SDK.h"
#import "JL_Cbw.h"
#import "JL_Csw.h"
#import "JL_Data.h"
#import "JL_BLE_Cache.h"
#import "JL_BLE_Handle.h"
#import "JL_BLE_Cmd.h"



@interface JL_BLE_Core : NSObject


+(id)sharedMe;
-(void)keepCMD_90:(BOOL)is;
-(void)KeepGetMode:(BOOL)is;


@end
