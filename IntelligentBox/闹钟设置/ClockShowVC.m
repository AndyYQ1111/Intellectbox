//
//  ClockShowVC.m
//  IntelligentBox
//
//  Created by DFung on 2018/5/22.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ClockShowVC.h"
#import "ClockCell.h"
#import "AlarmObject.h"
#import "ClockSettingVC.h"

@interface ClockShowVC ()<UITableViewDelegate,
                          UITableViewDataSource>
{
    __weak IBOutlet UITableView *subTableView;
    NSMutableArray *alarmArray;
    NSMutableArray *indexArray;
    int clockNum;
    NSTimer    *stateCheck;
}

@end

@implementation ClockShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addNote];
    
    
    NSLog(@"获取闹钟数据...");
    [JL_BLE_Cmd cmdGetAlarmClock];
    
    stateCheck = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self
                                                selector:@selector(getAlarmClockState)
                                                userInfo:nil repeats:YES];
    [stateCheck fire];
}

-(void)getAlarmClockState{
     [JL_BLE_Cmd cmdGetAlarmClock];
}

-(void)setupUI{
    alarmArray = [NSMutableArray new];
    indexArray = [NSMutableArray new];
    
    subTableView.delegate = self;
    subTableView.dataSource = self;
    subTableView.rowHeight = 100.0;
    subTableView.tableFooterView = [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return alarmArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:[ClockCell ID]];
    if (cell == nil) {
        cell = [[ClockCell alloc] init];
    }
    AlarmObject *item = alarmArray[indexPath.row];
    cell.alarmObjcet = item;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlarmObject *item = alarmArray[indexPath.row];
    AlarmObject *item_1 = [AlarmObject new];
    item_1.hour  = item.hour;
    item_1.min   = item.min;
    item_1.state = item.state;
    item_1.mode  = item.mode;
    item_1.name  = item.name;
    item_1.index = item.index;
    
    ClockSettingVC *vc = [[ClockSettingVC alloc] init];
    vc.alarmObject = item_1;
    vc.type=2;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)btn_close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self->stateCheck invalidate];
        self->stateCheck = nil;
    }];
}

- (IBAction)btn_add:(id)sender {
    
    
    if (APP_SUOAI) {
        
    }else{
        if(alarmArray.count==clockNum){
            [DFUITools showText:@"闹钟数量已经满了" onView:self.view delay:1.0];
        }else{
            ClockSettingVC *vc = [[ClockSettingVC alloc] init];
            vc.alarmObject = [self getAvailableAddAlarm];
            vc.type = 1;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

-(AlarmObject *) getAvailableAddAlarm{
    NSDate *date = [NSDate new];
    NSDateFormatter *formate = [NSDateFormatter new];
    formate.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString *tmpStr = [formate stringFromDate:date];
    NSArray *tagtArray = [tmpStr componentsSeparatedByString:@"-"];
    
    AlarmObject *alarmBean = [AlarmObject new];
    alarmBean.hour  = [tagtArray[3] intValue];
    alarmBean.min   = [tagtArray[4] intValue];
    alarmBean.state = 1;
    alarmBean.mode  = 1;
    alarmBean.name  = @"新建闹钟";
    if([indexArray count]==0){
        alarmBean.index = 0;
    }else{
        int index = -1;
        for (int i=0; i<indexArray.count; i++) {
            if(![indexArray containsObject:@(i)]){
                 index= i;
                 break;
            }
        }
        
        if(index==-1){
            index =(int)indexArray.count;
        }
        alarmBean.index = index;
    }

    
    return alarmBean;
}


#pragma mark - 更新 闹钟数据
-(void)getClockNote:(NSNotification *)note{
    [alarmArray removeAllObjects];
    [indexArray removeAllObjects];

    NSArray *clockArr = note.object;
    
    if(clockArr){
        for (NSData *clockData in clockArr) {
            AlarmObject *alarmObject = [AlarmObject alarmClockDataToObject:clockData];
            [indexArray addObject:@(alarmObject.index)];
            [alarmArray addObject:alarmObject];
        }
        
        [DFAction delay:0.3 Task:^{
            [self->subTableView reloadData];
        }];
    }
}

-(void)noteClockMax:(NSNotification*)note{
    clockNum = [[note object] intValue];
}

-(void)addNote{
    [DFNotice add:kCMD_CLOCK Action:@selector(getClockNote:) Own:self];
    [DFNotice add:kCMD_CLOCK_NUM Action:@selector(noteClockMax:) Own:self];
}

-(void)dealloc{
    [DFNotice remove:kCMD_CLOCK Own:self];
    [DFNotice remove:kCMD_CLOCK_NUM Own:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
