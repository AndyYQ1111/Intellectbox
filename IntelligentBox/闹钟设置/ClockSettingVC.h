//
//  ClockSettingVC.h
//  IntelligentBox
//
//  Created by DFung on 2018/5/22.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLDefine.h"
#import "AlarmObject.h"

@interface ClockSettingVC : UIViewController
@property(strong,nonatomic)AlarmObject *alarmObject;
@property(nonatomic,assign)int type;
@end
