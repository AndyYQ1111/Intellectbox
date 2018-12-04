//
//  BluetoothVC.m
//  Test
//
//  Created by DFung on 2017/11/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import "BluetoothVC.h"
#import "SearchView.h"
#import "JL_Listen.h"
#import "JL_BLEUsage.h"

@interface BluetoothVC (){
    __weak IBOutlet UIImageView *subImage;
    __weak IBOutlet UIButton *subBtn;
    __weak IBOutlet UILabel *subLabel;
    SearchView      *searchView;
    DFTips          *loadingTp;
    
    JL_BLEUsage     *JL_ug;
    JL_BLEApple     *bleCtrl;
}
@end

@implementation BluetoothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JL_ug = [JL_BLEUsage sharedMe];
    bleCtrl = JL_ug.JL_ble_apple;
    
    [self addNote];
    [self setupUI];
    [self scanBle];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [JL_ug.JL_ble_apple disconnectBLE];
}

-(void)viewDidAppear:(BOOL)animated {
    [DFNotice add:kUI_DEVICES_DISCOVERED Action:@selector(noteDiscovered:) Own:self];
    [DFNotice add:kUI_DEVICE_DISCONNECT Action:@selector(noteDisconnect:) Own:self];
      
    NSString *bleUUID = [DFTools getUserByKey:DEVICE_ID];
    
    if (bleUUID.length <= 0 && JL_ug.bt_status_phone) {
        [searchView removeMe];
        [self btnAction:subBtn];
    }
    BOOL connectFlag = [[JL_Listen sharedMe]connectBLE];
    
    /*--- 正在重连 ---*/
    if(!connectFlag){
        if (bleUUID.length >0 && JL_ug.bt_status_phone) {
            [self startLoadingView:@"正在重连..."];
            [self setUIStep_2];
        }
    }
}

 
-(void)setupUI{
    subBtn.layer.cornerRadius = 25.0;
    if (!JL_ug.bt_status_connect) {
        [self setUIStep_1];
    }else{
        [self setUIStep_4];
    }
}

- (void)setUIStep_1 {
    subImage.image = [UIImage imageNamed:@"k1_connect"];
    [DFUITools setButton:subBtn Text:@"搜索"];
    [subBtn setUserInteractionEnabled:YES];
    subLabel.text = @"确保设备处于配对模式";
}

- (void)setUIStep_2 {
    subImage.image = [UIImage imageNamed:@"k2_search"];
    [DFUITools setButton:subBtn Text:@"搜索中..."];
    [subBtn setUserInteractionEnabled:NO];
    subLabel.text = @"正在搜索设备...";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DFUITools showText:@"请断开蓝牙重新连接" onView:self.view delay:3.0];
        [self setUIStep_1];
    });
}

- (void)setUIStep_3 {
    subImage.image = [UIImage imageNamed:@"k3_connect"];
    [DFUITools setButton:subBtn Text:@"连接成功"];
    [subBtn setUserInteractionEnabled:NO];
    subLabel.text = @"索爱智能音箱";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUIStep_4 {
    subImage.image = [UIImage imageNamed:@"k1_connect"];
    [DFUITools setButton:subBtn Text:@"断开"];
    [subBtn setUserInteractionEnabled:YES];
    subLabel.text = [NSString stringWithFormat:@"已连接:%@",JL_ug.bt_name];
}

- (IBAction)btnAction:(id)sender {
    
    [bleCtrl cleanBLE];//清除连接记录
    [bleCtrl disconnectBLE];
    JL_ug.bt_status_connect = NO;
    
    [[JL_Listen sharedMe] setConnectBLE:NO];
    [DFTools removeUserByKey:DEVICE_ID];
    [ToolManager removeDefaultData:@"token"];
    
    if (!JL_ug.bt_status_connect) {
        if (!JL_ug.bt_status_phone) {
            [self showAlertView];
        }else {
            [self setUIStep_2];
            [self scanBle];
        }
    }else{
        
    }
}

- (IBAction)closeThisVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertView {
    NSString *txt = @"请确保两点：\n1.设置->蓝牙->打开！\n2.拖出iPhone屏幕下方的控制版，点亮蓝牙图标。";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机蓝牙未打开"
                                                    message:txt
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"好", nil];
    [alert show];
}

- (void)scanBle {
    /*--- 搜索蓝牙设备 ---*/
    [bleCtrl stopScanBLE];
    
    if (!JL_ug.bt_status_phone) {
        [self setBTDisconnectedUI];
        
    }else{
        BOOL connectFlag = [[JL_Listen sharedMe] connectBLE];
        if(!connectFlag){
            [bleCtrl startScanBLE];
        }
    }
}

-(void)setBTDisconnectedUI {
    searchView = nil;
    [self setUIStep_1];
    [self endLoadingView];
    
}

-(void)noteLink_No:(NSNotification*)note {
    searchView = nil;
}


-(void)noteLink_Yes:(NSNotification*)note {
    JL_CommonEntiy *selectedItem = [note object];
    if(selectedItem == nil) {
        return;
    }
    NSLog(@"蓝牙正在连接... ==> %@",selectedItem.mItem);
    NSString *text = [NSString stringWithFormat:@"正在连接:%@",selectedItem.mItem];
    [self startLoadingView:text];
    [bleCtrl connectBLE:selectedItem.mPeripheral];
}

-(void)noteDiscovered:(NSNotification*)note {
    [self setUIStep_1];
    
    NSString *bleUUID = [DFTools getUserByKey:DEVICE_ID];
    if (bleUUID.length == 0) {
        if (searchView == nil) {
            searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, [DFUITools screen_1_W], [DFUITools screen_1_H])];
            [self.view addSubview:searchView];
        }
        [bleCtrl stopScanBLE];
        [searchView reloadCellData];
    }
}

#pragma mark - 蓝牙已连接 且 配对成功
-(void)notePairSucceed:(NSNotification *)note {
    [self endLoadingView];
    
    /*--- 告诉设备，是iOS平台 ---*/
    [JL_BLE_Cmd cmdPhoneiOS];
    /*--- 获取设备Lisence ---*/
    [JL_BLE_Cmd cmdDeviceLisence];
    
    [DFUITools showText:@"蓝牙连接成功" onView:self.view delay:1.0];
    [searchView removeMe];
    [self setUIStep_3];
}

-(void)noteConnectFail:(NSNotification*)note{
    [DFUITools showText:@"连接失败" onView:self.view delay:1.5];
    [self setUIStep_1];
}

-(void)noteDisconnect:(NSNotification*)note {
    [self setBTDisconnectedUI];
    //[self removeNote];
}


-(void)addNote {
    [DFNotice add:@"UI_Link_YES" Action:@selector(noteLink_Yes:) Own:self];
    [DFNotice add:@"UI_Link_NO" Action:@selector(noteLink_No:) Own:self];
    
    [DFNotice add:kBT_DEVICE_NOTIFY_SUCCEED Action:@selector(notePairSucceed:) Own:self];
    [DFNotice add:kBT_DEVICE_FAIL_CONNECT Action:@selector(noteConnectFail:) Own:self];
  
}

-(void)removeNote{
    [DFNotice remove:@"UI_Link_YES" Own:self];
    [DFNotice remove:@"UI_Link_NO" Own:self];
    
    [DFNotice remove:kUI_DEVICES_DISCOVERED Own:self];
    [DFNotice remove:kBT_DEVICE_NOTIFY_SUCCEED Own:self];
    [DFNotice remove:kBT_DEVICE_FAIL_CONNECT Own:self];
    [DFNotice remove:kUI_DEVICE_DISCONNECT Own:self];
} 


-(void)startLoadingView:(NSString*)text{
    loadingTp = [DFUITools showHUDWithLabel:text
                                     onView:self.view color:[UIColor blackColor]
                             labelTextColor:[UIColor whiteColor]
                     activityIndicatorColor:[UIColor whiteColor]];
    [loadingTp hide:YES afterDelay:9.0];
}

-(void)endLoadingView{
    [loadingTp hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
