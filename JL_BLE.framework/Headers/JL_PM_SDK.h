//
//  JL_PM_SDK.h
//  JL_BLE
//
//  Created by DFung on 2017/6/29.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLE_SDK.h"

#define kPM_JL                  @"4a4c4d50"
#define kPM_PKG                 @"PM_PKG"

/*--- 通知回调 ---*/
#define kPM_GET_CAP             @"PM_GET_CAP"
#define kPM_UPDATE_FILE_PREPARE @"PM_UPDATE_FILE_PREPARE"
#define kPM_UPDATE_FILE_PKG     @"PM_UPDATE_FILE_PKG"
#define kPM_UPDATE_OK           @"PM_UPDATE_OK"

@interface JL_PM_SDK : NSObject

@end
