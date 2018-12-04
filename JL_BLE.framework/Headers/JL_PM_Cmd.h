//
//  JL_PM_Cmd.h
//  JL_BLE
//
//  Created by DFung on 2017/6/29.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_PM_SDK.h"
#import "JL_PM_Handle.h"
#import "JL_PM_PKG.h"

@interface JL_PM_Cmd : NSObject

+(void)cmdPmGetGap;
+(void)cmdPmUpdateFilePrepare:(uint32_t)fileSize;
+(void)cmdPmUpdateFile:(NSString*)path;


@end
