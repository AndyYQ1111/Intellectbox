//
//  LeftSideViewController.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "LeftSideViewController.h"
#import "BluetoothVC.h"
#import "ChatVC.h"
#import "AboutViewController.h"

#import "ClockShowVC.h"
#import "ClockSettingVC.h"
#import "JLDefine.h"
#import "UIViewController+LMSideBarController.h"

@interface LeftSideViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITableView *SelectTable;

@property (strong, nonatomic) NSMutableArray *itemArray;

@end



@implementation LeftSideViewController

JL_BLEUsage     *JL_ug;
JL_BLEApple     *bleCtrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JL_ug = [JL_BLEUsage sharedMe];
    bleCtrl = JL_ug.JL_ble_apple;
    
    [self updateItemUI];
    
    _SelectTable.dataSource = self;
    _SelectTable.delegate = self;
    _SelectTable.tableFooterView = [UIView new];
    _SelectTable.scrollEnabled = NO;
    
    NSArray *tmpArray = @[@"蓝牙连接",@"关于"];
    if (JL_ug.bt_status_connect) {
        tmpArray = @[@"断开连接",@"关于"];
    }else{
        tmpArray = @[@"蓝牙连接",@"关于"];
    }
    [_itemArray removeAllObjects];
    _itemArray = nil;
    
    _itemArray = [NSMutableArray arrayWithArray:tmpArray];
    [_SelectTable reloadData];
    
    [self addNote];
}

-(void)addNote{
    [DFNotice add:kBT_DEVICE_CONNECTED Action:@selector(BLEstatusConnect:) Own:self];
    [DFNotice add:kBT_DEVICE_DISCONNECT Action:@selector(BLEstatusDisConnect:) Own:self];
    //[DFNotice add:@"kUI_IS_CLOCK" Action:@selector(noteIsClock:) Own:self];
}


-(void)BLEstatusDisConnect:(NSNotification *)note{
    [self updateItemUI];
}

-(void)BLEstatusConnect:(NSNotification *)note{
    [self updateItemUI];
}

//更新item选项
-(void)noteIsClock:(NSNotification*)note{
    [self updateItemUI];
}
-(void)updateItemUI{
    NSArray *tmpArray = nil;
    NSString *txt_0 = nil;
    if (!JL_ug.bt_status_connect || !JL_ug.bt_status_phone) {
        txt_0 = @"蓝牙连接";
    }else{
        txt_0 = @"断开连接";
    }
    
    
    BOOL isOK = [[JL_Listen sharedMe] isCLOCK];
    if (isOK) {
        tmpArray = @[txt_0,@"关于"];
    }else{
        tmpArray = @[txt_0,@"关于"];
    }
    
    [_itemArray removeAllObjects];
    [_itemArray setArray:tmpArray];
    [_SelectTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* IDCell = @"lcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
    }
    cell.textLabel.text = _itemArray[indexPath.row];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.sideBarController hideMenuViewController:YES];
    
    /*--- 蓝牙连接 ---*/
    if (indexPath.row == 0) {
        if(JL_ug.bt_status_connect){
            [bleCtrl stopScanBLE];
            [bleCtrl cleanBLE];//清除连接记录
            [bleCtrl disconnectBLE];
        }else{
            BluetoothVC *vc =[[BluetoothVC alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
    }else if (indexPath.row == 1) {
        AboutViewController *vc = [[AboutViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}


-(void)dealloc{
    [DFNotice remove:kBT_DEVICE_CONNECTED Own:self];
    [DFNotice remove:kBT_DEVICE_DISCONNECT Own:self];
    [DFNotice remove:@"kUI_IS_CLOCK" Own:self];
}


@end
