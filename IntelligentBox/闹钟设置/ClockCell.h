//
//  ClockCell.h
//  IntelligentBox
//
//  Created by DFung on 2018/5/22.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLDefine.h"
#import "AlarmObject.h"

@interface ClockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbWeek;
@property (weak, nonatomic) IBOutlet UISwitch *swON;
@property (strong,nonatomic)AlarmObject *alarmObjcet;

+(NSString*)ID;

@end
