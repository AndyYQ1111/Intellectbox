//
//  AppDelegate.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/6.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AppDelegate.h"
#import "JLDefine.h"

@interface AppDelegate ()<UIAlertViewDelegate>
{
    JL_BLEApple     *bleCtrl;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   //UIWindow *win = [DFUITools getWindow];
    /*--- 检测当前语言 ---*/
    if (![kJL_GET hasPrefix:@"zh-Hans"]) {
        kJL_SET("en");
    }else{
        kJL_SET("zh-Hans");
    }
    
    /*--- 锁屏控制 ---*/
    [application beginReceivingRemoteControlEvents];
    
    [self addNote];
    /*--- JL_BLE SDK接入 --*/
    JL_BLEUsage *JL_ug = [JL_BLEUsage sharedMe];
    bleCtrl = JL_ug.JL_ble_apple;
    
    /*--- 监听录音数据 ---*/
    [JL_Listen sharedMe];
    
    /*--- 删除聊天记录 ---*/
    [JL_Talk talkRemove];
    
    /*--- 设置屏幕常亮 ---*/
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [DFAction delay:2.0 Task:^{
        if (JL_ug.bt_status_phone) {
            /*--- 蓝牙4.0 回连 ---*/
            if (!JL_ug.bt_status_connect) {
                BOOL connectFlag = [[JL_Listen sharedMe] connectBLE];
                if(!connectFlag){
                    [self->bleCtrl startScanBLE];
                }
                /*--- 蓝牙4.0 提示 ---*/
                [DFAction delay:2.0 Task:^{
                    if (!JL_ug.bt_status_connect) {
                        [self alertBLE_IsOFF];
                    }
                }];
            }
            /*--- 蓝牙2.0（A2DP）连接检测 ---*/
            [DFAction delay:4.0 Task:^{
                AVAudioSessionRouteDescription *nowRoute = [[AVAudioSession sharedInstance] currentRoute];
                NSArray * outArr = nowRoute.outputs;
                AVAudioSessionPortDescription *outPort = outArr[0];
                NSLog(@"NOW BLE 2.0 --> %@  Type:%@",outPort.portName,outPort.portType);
                if ([outPort.portType isEqual:@"Speaker"]) {
                    [self alertA2DP_IsOFF];
                }
            }];
        }
    }];
     
    return YES;
}


-(void)noteBTDisconnected:(NSNotification*)note{
    [JL_Talk talkRemove];
    
    [DFAction delay:1.0 Task:^{
     BOOL connectFlag = [[JL_Listen sharedMe] connectBLE];
        if(!connectFlag){
            [self->bleCtrl startScanBLE];
        }
    }];
}
 
-(void)alertBLE_IsOFF {
    //[self showAlert:@"请在APP左侧边栏，连接设备蓝牙4.0。" Tag:0];
}

-(void)alertA2DP_IsOFF {
    [self showAlert:@"请连接设备蓝牙2.0" Tag:123];
}


-(void)showAlert:(NSString*)text Tag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机蓝牙设置"
                                                    message:text
                                                   delegate:self cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"好", nil];
    alert.tag = tag;
    [alert show];
}


- (void)applicationWillResignActive:(UIApplication *)application { 
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
//                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
//                                           error:nil];
}

-(void)remoteControlReceivedWithEvent:(UIEvent*)event{
    if (event) [DFAudioPlayer receiveRemoteEvent:event];
}

-(void)disconnectBT{
    [[JL_Listen sharedMe] setConnectBLE:YES];
    [bleCtrl disconnectBLE];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [application endReceivingRemoteControlEvents];
    [DFNotice remove:kUI_DEVICE_DISCONNECT Own:self];
    [DFNotice remove:@"DISCONNECT_BT" Own:self];
    
    [JL_Talk talkRemove];
}


-(void)addNote{
     [DFNotice add:kUI_DEVICE_DISCONNECT Action:@selector(noteBTDisconnected:) Own:self];
    [DFNotice add:@"DISCONNECT_BT" Action:@selector(disconnectBT) Own:self];
}

@end
