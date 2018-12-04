//
//  JL_PM_Handle.h
//  JL_BLE
//
//  Created by DFung on 2017/6/29.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_PM_SDK.h"
#import "JL_PM_Core.h"

@interface JL_PM_Handle : NSObject

+(id)sharedMe;

#pragma mark 让蓝牙库发数据
-(void)sendBLEData:(NSData*)data;


@end
