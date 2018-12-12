//
//  MainTabControllerView.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/10.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MainTabControllerView.h"
#import "MusicFMViewController.h"
#import "LivesServiceViewController.h"
#import "JLDefine.h"
#import "SpeechHandle.h"
#import "ChatVC.h"
#import "SpeekingView.h"
#import "GetLocalization.h"


@interface MainTabControllerView ()<UITabBarDelegate>{
    
    __weak IBOutlet UITabBar *mainTabBar;
    
    UIButton         *mainBtn;
    JL_Listen        *mListen;
    SpeekingView     *spView;
}
@end

@implementation MainTabControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mListen = [JL_Listen sharedMe];
   
    [self addNote];
    
    //设置MainBtn
    CGRect rect;
    float sH = [DFUITools screen_1_H];
    if(sH == 812.0f){
        //iphoneX尺寸
        rect = CGRectMake(kJL_W/2 - 35, kJL_H - 100, 70, 70);
    }else {
        //一般iphone尺寸
        rect = CGRectMake(kJL_W/2 - 35, kJL_H - 70, 70, 70);
    }
    
    mainBtn = [[UIButton alloc] initWithFrame:rect];
    [mainBtn setImage:[UIImage imageNamed:@"k_ intercom"] forState:UIControlStateNormal];
    [self.view addSubview:mainBtn];
    
    [mainBtn addTarget:self action:@selector(mainBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mainLongBtnAction:)];
    longPress.minimumPressDuration = 0.15;
    [mainBtn addGestureRecognizer:longPress];
    
    
    UIView *launchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kJL_W, kJL_H)];
    UIImageView *learchView = [[UIImageView alloc] initWithFrame:launchView.frame];
    learchView.image = [UIImage imageNamed:@"k36_bg"];
    [launchView addSubview:learchView];
    
    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [self.view addSubview:launchView];
    [UIView animateWithDuration:1.2 animations:^{
        
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
        
        [self stepUpViewControllers];
        self.view.backgroundColor = [UIColor whiteColor];
        
        [[DFAudioPlayer sharedMe] reloadPhoneMusic];
        ///////*******接收通知*****//////////
        [SpeechHandle sharedInstance];
        
        [self setSelectedIndex:0];
        //获取
        [[GetLocalization sharedInstance] startUpdateLocalization:^(NSString *city) {
            [SpeechHandle sharedInstance].currentCity = city;
        }];
    }];    
}


/**
 设置TabBar ViewControllers
 */
-(void)stepUpViewControllers {
    
    UIColor *selectColor = [UIColor colorWithRed:252.0/255.0 green:51.0/255.0 blue:81.0/255.0 alpha:1];
    
    //音乐FMViewController
    MusicFMViewController *musicFmVC = [[MusicFMViewController alloc] init];
    musicFmVC.tabBarItem.title = @"音乐电台";
    musicFmVC.tabBarItem.image = [[UIImage imageNamed:@"k_A_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imageMusic = [UIImage imageNamed:@"k_A_11"];
    imageMusic = [imageMusic imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [musicFmVC.tabBarItem setSelectedImage:imageMusic];
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:selectColor forKey:NSForegroundColorAttributeName];
    [musicFmVC.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    
    mainTabBar.delegate = self;

    ChatVC *chatVC = [[ChatVC alloc] init];
    chatVC.tabBarItem.title = @"";
    chatVC.tabBarItem.image = nil;
    
    LivesServiceViewController *livesVC = [[LivesServiceViewController alloc] init];
    livesVC.tabBarItem.title = @"技能中心";
    livesVC.tabBarItem.image = [[UIImage imageNamed:@"k_A_00"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *imageLives = [UIImage imageNamed:@"k_A_12"];
    imageLives = [imageLives imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [livesVC.tabBarItem setSelectedImage:imageLives];
    NSDictionary *dictLive = [NSDictionary dictionaryWithObject:selectColor forKey:NSForegroundColorAttributeName];
    [livesVC.tabBarItem setTitleTextAttributes:dictLive forState:UIControlStateSelected];
    
    
    self.viewControllers = [NSArray arrayWithObjects:musicFmVC,chatVC,livesVC,nil];
    
    mainTabBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:70.0/255.0 blue:140.0/255.0 alpha:1];
    mainTabBar.barTintColor = [UIColor whiteColor];
    
    
    spView = [[SpeekingView alloc] initWithFrame:CGRectMake(0, 0, kJL_W, kJL_H)];
    [self.view addSubview:spView];
    spView.hidden = YES;
    
    [self setSelectedIndex:1];    
}

#pragma mark <- Btn ->
-(void)mainBtnAction:(UIButton *)sender{
    [self setSelectedIndex:1];
}

#pragma mark -center长按事件
-(void )mainLongBtnAction:(UILongPressGestureRecognizer *)sender {
    [DFNotice post:kDFAudioPlayer_NOTE Object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[DFAudioPlayer currentPlayer] didPause];
    });
    
    if (sender.state == UIGestureRecognizerStateEnded) { //停止录音
        [mListen recordStop];
        [mainBtn setImage:[UIImage imageNamed:@"k_ intercom"] forState:UIControlStateNormal];
        spView.hidden = YES;
        [spView stopAnimation];
        //转场音乐
        [[SpeechHandle sharedInstance] playCutToMusic];
    }
    else if (sender.state == UIGestureRecognizerStateBegan) { //开启录音
        //开始之前停止tts播放
        [[SpeechHandle sharedInstance] stopCutTopMusic];
        BOOL isOk = [mListen recordStart];
        if (isOk) {
            [self setSelectedIndex:1];
            [mainBtn setImage:[UIImage imageNamed:@"k39_record"] forState:UIControlStateNormal];
            spView.hidden = NO;
            [spView startAnimation];
        }
    }
}
//设备点击开启录音
-(void)noteSpeechStart:(NSNotification*)note {
    if (spView.hidden == NO) return;
    [self setSelectedIndex:1];
    NSLog(@"---noteSpeechStart");
    [DFAction mainTask:^{
        [self->mainBtn setImage:[UIImage imageNamed:@"k39_record"] forState:UIControlStateNormal];
        [self->spView startAnimation];
        self->spView.hidden = NO;
        
        [DFAction delay:10.0 Task:^{
            [self noteSpeechEnd:nil];
        }];
    }];
}

-(void)noteSpeechEnd:(NSNotification*)note {
    NSLog(@"---noteSpeechEnd");
    [DFAction mainTask:^{
        [self->spView stopAnimation];
        self->spView.hidden = YES;
        [self->mainBtn setImage:[UIImage imageNamed:@"k_ intercom"] forState:UIControlStateNormal];
    }];
}

-(void)noteAppBackground:(NSNotification*)note {
    //停止录音(UI)
    NSLog(@"UIGestureRecognizerStateEnded");
    [mainBtn setImage:[UIImage imageNamed:@"k_ intercom"] forState:UIControlStateNormal];
    spView.hidden = YES;
    [spView stopAnimation];
}

//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//
//    if ([item.title isEqualToString:@""]) {
//        [mainBtn setImage:[UIImage imageNamed:@"k54_selected"] forState:UIControlStateNormal];
//    }else{
//        [mainBtn setImage:[UIImage imageNamed:@"k53_unchoose"] forState:UIControlStateNormal];
//    }
//}


-(void)addNote{
    [DFNotice add:UIApplicationDidEnterBackgroundNotification
           Action:@selector(noteAppBackground:) Own:self];
    [DFNotice add:@"speech_start" Action:@selector(noteSpeechStart:) Own:self];
    [DFNotice add:@"speech_end" Action:@selector(noteSpeechEnd:) Own:self];
}


-(void)dealloc {
    [DFNotice remove:UIApplicationDidEnterBackgroundNotification Own:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
