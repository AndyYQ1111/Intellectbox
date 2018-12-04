//
//  ClockCell.m
//  IntelligentBox
//
//  Created by DFung on 2018/5/22.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ClockCell.h"

@interface ClockCell(){
    
    __weak IBOutlet UIView *bgView;
    
    
}
@end

@implementation ClockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [DFUITools loadNib:@"ClockCell"];
    if (self) {
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 10.0;
        
    }
    return self;
}


+(NSString*)ID{
    return @"CLOCKCELL";
}


-(void)setAlarmObjcet:(AlarmObject *)alarmObjcet{
    _alarmObjcet = alarmObjcet;
    
    if(_alarmObjcet.min<10){
        self.lbTime.text = [NSString stringWithFormat:@"%d:0%d",_alarmObjcet.hour,_alarmObjcet.min];
    }else{
        self.lbTime.text = [NSString stringWithFormat:@"%d:%d",_alarmObjcet.hour,_alarmObjcet.min];
    }
    
    self.lbWeek.text = [AlarmObject stringMode:_alarmObjcet.mode];
    self.lbName.text = _alarmObjcet.name;
    [self.swON setOn:_alarmObjcet.state animated:YES];
}

- (IBAction)swON_Off:(UISwitch *)sender {
    uint8_t st = 0;
    if (sender.isOn) {
        st = 1;
    }else{
        st = 0;
    }
    
    _alarmObjcet.state = st;
    
    /*--- 设置闹钟（开关） ---*/
    [JL_BLE_Cmd cmdAddAlarmClockWithIndex:_alarmObjcet.index
                                     Hour:_alarmObjcet.hour
                                      Min:_alarmObjcet.min
                               repeatMode:_alarmObjcet.mode
                                    CName:_alarmObjcet.name
                                    State:st];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
