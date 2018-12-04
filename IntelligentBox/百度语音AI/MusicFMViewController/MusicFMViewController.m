//
//  MusicFMViewController.m
//  IntelligentBox
//
//  Created by DFung on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MusicFMViewController.h"
#import "MusicCollectionView.h"
#import "SearchViewController.h"
#import "ClockShowVC.h"
#import "HistoryViewController.h"
#import "CollectionViewController.h" 

#import "MindListView.h" 
#import "PlayMusicViewController.h"
#import "UIViewController+LMSideBarController.h"

#import "OldTreeManager.h"
#import "AppInfoGeneral.h"
#import "BluetoothVC.h"
#import "MusicMainModel.h"

#define w (kJL_W - 45) / 2

@interface MusicFMViewController ()
{
    JL_BDSpeechAI *speechAI;
    __weak IBOutlet UIButton *menuBtn;
    __weak IBOutlet UIButton *musicLibBtn;
    __weak IBOutlet UIImageView *centerBtn;
    __weak IBOutlet UIButton *mindBtn;
    __weak IBOutlet UIImageView *libSelectImg;
    __weak IBOutlet UIImageView *mindSelectImg;
    
    MindListView         *mindView;
    UIView               *launchView;
    DFTips               *loadingView;
    
    JL_BLEUsage       *JL_ug;
    
    NSString         *lisence;
    NSTimer          *dataCheck;
}
@property (nonatomic, strong) UIButton *navSelectedBtn;

@property (nonatomic, strong) MusicCollectionView *collectView;
//资源服务器的URL
@property (nonatomic, copy) NSString *mediaServerUrl;
//交互服务器的URL
@property (nonatomic, copy) NSString *interServerUrl;

@end

@implementation MusicFMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navSelectedBtn = musicLibBtn;
    self.navSelectedBtn.selected = YES;
    
    JL_ug = [JL_BLEUsage sharedMe];
    speechAI = [JL_BDSpeechAI sharedMe];
    
    [self initWithLayout];
    [self addNoti];
    
    dataCheck = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkTheUIData) userInfo:nil repeats:YES];
    [dataCheck fire];
    

}

- (void)viewWillAppear:(BOOL)animated {
    MusicOfPhoneMode *nowModel;
    switch ([DFAudioPlayer currentType]) {
        case DFAudioPlayer_TYPE_IPOD:{
            nowModel = [[DFAudioPlayer sharedMe] mNowItem];
        }break;
        case DFAudioPlayer_TYPE_PATHS:{
            nowModel = [[DFAudioPlayer sharedMe_1] mNowItem];
        }break;
        case DFAudioPlayer_TYPE_NET:{
            nowModel = [[DFAudioPlayer sharedMe_2] mNowItem];
        }break;
        case DFAudioPlayer_TYPE_NONE:{
            nowModel = [[DFAudioPlayer sharedMe] mNowItem];
        }break;
        default:
            break;
    }
    if (nowModel.isPlaying == YES && nowModel.mUrl.length > 0) {
        [centerBtn startAnimating];
    }else{
        [centerBtn stopAnimating];
    }
    
    //    NSString *deviceid = [DFTools getUserByKey:DEVICE_ID];
    if (!JL_ug.bt_status_connect) { //deviceid.length == 0
        [self pushBluetoothVC];
    }
}

#pragma mark -登录获取token
- (void)login {
    NSString *urlStr = @"user.php?act=login";
    NSDictionary *paraDic = @{
                              @"devId" : lisence ? lisence : @"",
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @""
                              };
    WeakSelf
    [[AFManagerClient sharedClient] postRequestWithUrl:urlStr parameters:paraDic success:^(id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        if([result isEqualToString:@"ok"]) {
            
            if ([[responseObject allKeys] containsObject:@"token"]) {
                [ToolManager saveDefauleData:responseObject[@"token"] key:@"token"];
            }
            self.mediaServerUrl = responseObject[@"mediaServerUrl"];
            self.interServerUrl = responseObject[@"interServerUrl"];
            
            //语音记录界面URL
            [DFNotice post:JL_INTER_SERVER_URL Object:self.interServerUrl];
            
            [weakSelf loadMainListData];
            
        }else {
            NSLog(@"后台登录失败");
        }
    }failure:^(NSError *  error) {
        NSLog(@"发送登录请求失败");
    }];
}

//首页数据
- (void)loadMainListData {
    NSString *urlStr = @"mediaInfos.php?act=getFirstPageInfos";
    NSDictionary *paraDic = @{
                              @"devId" : lisence ? lisence : @"",
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @""
                              };
    
    [[AFManagerClient sharedClient] postRequestWithUrl:urlStr parameters:paraDic success:^(id responseObject) {
        
        MusicMainModel *model = [MTLJSONAdapter modelOfClass:[MusicMainModel class] fromJSONDictionary:responseObject error:NULL];
        
        if([model.result isEqualToString:@"ok"]) {
            self.collectView.model = model;

        }else {
            NSLog(@"获取首页数据失败 == %@", paraDic);
        }
    } failure:^(NSError *  error) {
        
    }];
}


-(void)checkTheUIData {
    [self noteForeground:nil];
}

-(void)localPlayerStatusChange {
    if ([[DFAudioPlayer sharedMe] mState] == DFAudioPlayer_PLAYING) {
        [centerBtn startAnimating];
        
    }else if ([[DFAudioPlayer sharedMe] mState] == DFAudioPlayer_PAUSE ||
              [[DFAudioPlayer sharedMe] mState] == DFAudioPlayer_STOP){
        [centerBtn stopAnimating];
    }
}

-(void)mindListNoti:(NSNotification *)note {
    int index = [note.object intValue];
    if(index == 0) { //本地音乐
        LocalMusicViewController *vc = [[LocalMusicViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (index == 1) { //闹钟管理
        ClockShowVC *vc = [[ClockShowVC alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (index == 2) { //播放历史
        HistoryViewController *vc = [[HistoryViewController alloc] init];
        vc.vcTitle = @"播放历史";
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (index == 3) { //收藏记录
        CollectionViewController *vc = [[CollectionViewController alloc] init];
        vc.vcTitle = @"我的收藏";
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - 蓝牙已连接 且 配对成功
-(void)noteBTConnectedPaired:(NSNotification *)note {
    [self startLoadingView:@"获取资源..."];
    
    [DFAction delay:1 Task:^{
        /*--- 告诉设备，是iOS平台 ---*/
        [JL_BLE_Cmd cmdPhoneiOS];
        /*--- 获取设备Lisence ---*/
        [JL_BLE_Cmd cmdDeviceLisence];
    }];
}

#pragma mark - 被动蓝牙 断开
-(void)noteBTDisconnectedPaired:(NSNotification*)note { 
    [[OldTreeManager sharedInstance] oldTreeExitLicense];
    [DFTools removeUserByKey:DEVICE_ID];
    NSLog(@"---> 被动 蓝牙断开。");
    [self pushBluetoothVC];
}

#pragma mark - 主动蓝牙 断开
-(void)noteBTDisconnect:(NSNotification*)note {
    NSString *device_id = [DFTools getUserByKey:DEVICE_ID];
    if (device_id.length <= 0) {
        return;
    }
    
    [DFAction delay:0.2 Task:^{
        [[OldTreeManager sharedInstance] oldTreeExitLicense];
        [DFTools removeUserByKey:DEVICE_ID];
        NSLog(@"---> 主动 蓝牙断开。");
        [self pushBluetoothVC];
    }];
}

#pragma mark - 获取设备Lisence
-(void)noteDeviceLisence:(NSNotification *)note {
    NSLog(@"同步系统时间...");
    [JL_BLE_Cmd cmdSyncAlarmClock:[NSDate new]];
    
    [DFAction delay:0.5 Task:^{
        NSLog(@"适配设备功能...");
        [JL_BLE_Cmd cmdConfigInfo];
    }];
    /*--- 获取模式 ---*/
    [JL_BLE_Cmd cmdModeInfo];
    
    WeakSelf
    [DFAction delay:1.2 Task:^{
        NSData *ls = [note object];
        if (ls) {
            self->lisence = [[NSString alloc] initWithData:ls
                                            encoding:NSUTF8StringEncoding];
            [ToolManager saveDefauleData:self->lisence key:DEVICE_ID];
            [weakSelf login];
        }
    }];
}

-(void)noteForeground:(NSNotification *)note {
    if(self.interServerUrl.length == 0) {
        if(do_net_ping() == 1){
            //老树登录
        }else if(do_net_ping() == 0){
            [[OldTreeManager sharedInstance] oldTreeExitLicense];
        }
    }
}

-(void)notePlayDetails:(NSNotification*)note {
    [centerBtn startAnimating];
}

- (void)pushBluetoothVC {
    BluetoothVC *vc = [[BluetoothVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mrak<- UIButton ->
- (IBAction)centerBtnAction:(id)sender {
    PlayMusicViewController *vc = [[PlayMusicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)menuBtnAction:(id)sender { 
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

- (IBAction)musiclibBtnAction:(id)sender {
    [UIView animateWithDuration:0.6 animations:^ {
        self->mindView.frame = CGRectMake(kJL_W, 64, kJL_W, kJL_H-64-50);
        self->libSelectImg.hidden = NO;
        self->mindSelectImg.hidden = YES;
        
        self.navSelectedBtn.selected = NO;
        self.navSelectedBtn = sender;
        self.navSelectedBtn.selected = YES;
    }];
}

- (IBAction)mindBtnAction:(id)sender {
    [UIView animateWithDuration:0.6 animations:^ {
        self->mindView.frame = CGRectMake(0, 64, kJL_W, kJL_H-64-50);
        self->libSelectImg.hidden = YES;
        self->mindSelectImg.hidden = NO;
        
        self.navSelectedBtn.selected = NO;
        self.navSelectedBtn = sender;
        self.navSelectedBtn.selected = YES;

    }];
}

- (IBAction)searchBtn:(id)sender {
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark Show等待UI
-(void)startLoadingView:(NSString*)text{
    loadingView = [DFUITools showHUDWithLabel:text onView:self.view
                                        color:[UIColor blackColor]
                               labelTextColor:[UIColor whiteColor]
                       activityIndicatorColor:[UIColor whiteColor]];
    [DFAction delay:3.0 Task:^{
        [self->loadingView hide:YES];
    }];
}

#pragma mark Close等待UI
-(void)endLoadingView{
    [loadingView hide:YES];
}

#pragma mark <- notification -> 
-(void)addNoti {
    
    [DFNotice add:kBT_DEVICE_NOTIFY_SUCCEED Action:@selector(noteBTConnectedPaired:) Own:self];
    [DFNotice add:kUI_DEVICE_DISCONNECT Action:@selector(noteBTDisconnectedPaired:) Own:self];
    [DFNotice add:kUI_DISCONNECTED Action:@selector(noteBTDisconnect:) Own:self];
    [DFNotice add:kCMD_LISENCE   Action:@selector(noteDeviceLisence:) Own:self];
    [DFNotice add:MINDLIST_NOTI  Action:@selector(mindListNoti:) Own:self];
    
    [DFNotice add:UIApplicationWillEnterForegroundNotification Action:@selector(noteForeground:) Own:self];
    [DFNotice add:kDFAudioPlayer_PROGRESS Action:@selector(notePlayDetails:) Own:self];
    
    [DFNotice add:kDFAudioPlayer_NOTE Action:@selector(localPlayerStatusChange) Own:self];

}

/**
 初始化UI
 */
-(void)initWithLayout {
    [self.view addSubview:self.collectView];    
    
    mindView = [[MindListView alloc] initWithFrame:CGRectMake(kJL_W, 64, kJL_W, kJL_H-64-52)];
    [self.view addSubview:mindView];
    
    centerBtn.animationImages = @[[UIImage imageNamed:@"K11_playing"],
                                  [UIImage imageNamed:@"k12_playing"],
                                  [UIImage imageNamed:@"k13_playing"],
                                  [UIImage imageNamed:@"k14_playing"],
                                  ];
    centerBtn.animationDuration = 1;
    centerBtn.animationRepeatCount = 0;
    libSelectImg.hidden = NO;
    mindSelectImg.hidden = YES;
}


- (MusicCollectionView *)collectView {
    if (!_collectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(w, 93.0 / 165.0 * w + 38);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 15;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectView = [[MusicCollectionView alloc]initWithFrame:CGRectMake(0, SNavigationBarHeight, kJL_W, kJL_H - SNavigationBarHeight - TabbarHeight) collectionViewLayout:flowLayout];
    }
    return _collectView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [dataCheck invalidate];
    dataCheck = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
