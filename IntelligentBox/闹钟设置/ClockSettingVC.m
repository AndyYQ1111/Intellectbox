//
//  ClockSettingVC.m
//  IntelligentBox
//
//  Created by DFung on 2018/5/22.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ClockSettingVC.h"
#import "ReNameView.h"
#import "SetCycleView.h"

@interface ClockSettingVC ()<UIPickerViewDelegate,
                             UIPickerViewDataSource,
                             ReNameViewDelegate,
                             CycleViewDelegate>
{
    __weak IBOutlet UIPickerView *pickView;
    __weak IBOutlet UIButton *btnDelete;
    __weak IBOutlet UIButton *btnNote;
    __weak IBOutlet UIButton *btnRepeat;
    __weak IBOutlet UISwitch *swOn;
    __weak IBOutlet UILabel *titleName;
    ReNameView  *rnameView;
    SetCycleView *cycleView;
    
}

@end

@implementation ClockSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self updateUI];
}

-(void)setupUI{
    pickView.delegate = self;
    pickView.dataSource = self;
    [pickView reloadAllComponents];
    
    btnDelete.layer.masksToBounds = YES;
    btnDelete.layer.cornerRadius = 25.0;
}

-(void)updateUI{
    uint8_t hour = _alarmObject.hour;
    uint8_t min  = _alarmObject.min;
    NSString *note = _alarmObject.name;
    NSString *rp = [AlarmObject stringMode:_alarmObject.mode];
    
    if(_type==1){
        [titleName setText:@"新建闹钟"];
        btnDelete.hidden=YES;
    }else if(_type==2){
        [titleName setText:@"闹钟编辑"];
        btnDelete.hidden=YES;
    }

    [swOn setOn:_alarmObject.state animated:YES];
    [pickView selectRow:hour inComponent:0 animated:YES];
    [pickView selectRow:min inComponent:1 animated:YES];
    [DFUITools setButton:btnNote Text:note];
    [DFUITools setButton:btnRepeat Text:rp];
}

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0) return 24;
    if(component == 1) return 60;
    return 0;
}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}

//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kJL_W/4.0;
}

//显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)row];
        return str;
    }
    if (component == 1) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)row];
        return str;
    }
    return nil;
}


//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"-->%ld %ld",(long)component,row);
    if (component == 0) {
        _alarmObject.hour = (uint8_t)row;
    }
    if (component == 1) {
        _alarmObject.min = (uint8_t)row;
    }
}

- (IBAction)sw_on_off:(UISwitch *)sender {
    _alarmObject.state = sender.isOn;
}

- (IBAction)btn_note:(id)sender {
    NSString *note = _alarmObject.name;

    rnameView = [[ReNameView alloc] initWithFrame:CGRectMake(0, 0, kJL_W, kJL_H)];
    rnameView.delegate = self;
    rnameView.nameTxfd.text = note;
    [self.view addSubview:rnameView];
}

#pragma mark <- renameDelegate ->
-(void)didSelectBtnAction:(UIButton *)btn WithText:(NSString *)text{
    [rnameView removeFromSuperview];
    _alarmObject.name = text;
    [DFUITools setButton:btnNote Text:text];
}

- (IBAction)btn_repeat:(id)sender {
    cycleView = [[SetCycleView alloc] initWithFrame:CGRectMake(0, 0, kJL_W, kJL_H)];
    cycleView.cycleArray = @[@"单次",@"每天"];
    cycleView.delegate = self;
    cycleView.repeatMode = _alarmObject.mode;
    [self.view addSubview:cycleView];
}

#pragma mark <- cycleDelegate ->
-(void)didSelectBtnAction:(UIButton *)btn WithArray:(NSArray *)cycArray{
    
    [cycleView removeFromSuperview];
    
    uint8_t mode = 0x00;
    NSArray *arr = cycArray;
    if (arr.count > 0) {
        for (NSString *num in cycArray) {
            uint8_t tmp = 0x01;
            int n = [num intValue];
            uint8_t tmp_n = tmp<<n;
            mode = mode|tmp_n;
        }
    }else{
        mode = 0x01;
    }
    
    NSLog(@"--> %d",mode);
    if (btn.tag == 1) {
        _alarmObject.mode = mode;
        NSString *rp = [AlarmObject stringMode:mode];
        [DFUITools setButton:btnRepeat Text:rp];
        
    }
}


- (IBAction)btn_save:(id)sender {
    /*--- 保存 ---*/
    [JL_BLE_Cmd cmdAddAlarmClockWithIndex:_alarmObject.index
                                     Hour:_alarmObject.hour
                                      Min:_alarmObject.min
                               repeatMode:_alarmObject.mode
                                    CName:_alarmObject.name
                                    State:_alarmObject.state];
    [DFAction delay:0.5 Task:^{
        [JL_BLE_Cmd cmdGetAlarmClock];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)btn_delete:(id)sender {
    /*--- 删除闹钟 ---*/
    [JL_BLE_Cmd cmdAlarmClockDeleteWithIndex:_alarmObject.index];
    [DFAction delay:0.5 Task:^{
        [JL_BLE_Cmd cmdGetAlarmClock];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)btn_out:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
