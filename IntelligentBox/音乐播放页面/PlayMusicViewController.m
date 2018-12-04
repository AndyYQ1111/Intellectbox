//
//  PlayMusicViewController.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/18.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "UIImageView+WebCache.h"
#import <DFUnits/DFUnits.h>
#import <MediaPlayer/MediaPlayer.h>
#import "OldTreeManager.h"
#import "AppInfoGeneral.h"
#import "BluetoothVC.h"

#import "MusicMainModel.h"

#import "AppInfoGeneral.h"
//#import "mp"
@interface PlayMusicViewController (){
    
    __weak IBOutlet UIImageView *mainBgImgv;
    __weak IBOutlet UISlider *songProgressSlider;
    __weak IBOutlet UILabel *startTimeLab;
    __weak IBOutlet UILabel *lessTimeLab;
    __weak IBOutlet UILabel *songNameLab;
    __weak IBOutlet UILabel *authorLab;
    
    __weak IBOutlet UIButton *ppBtn;
    __weak IBOutlet UIButton *perviousBtn;
    __weak IBOutlet UIButton *nextBtn;
    __weak IBOutlet UIButton *modelBtn;
    __weak IBOutlet UIButton *heartBtn;
    __weak IBOutlet UIButton *voiceLessBtn;
    __weak IBOutlet UIButton *voiceAddBtn;
    __weak IBOutlet UISlider *voiceSlider;
    
    NSTimer *dataCheck;
    NSInteger   modelType;
    MPVolumeView * _volumeView;
    

    
}
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _volumeView = [[MPVolumeView alloc]init];
    
    _volumeView.showsRouteButton = NO;
    //默认YES，这里为了突出，故意设置一遍
    _volumeView.showsVolumeSlider = YES;
    
    [_volumeView sizeToFit];
    [_volumeView setFrame:CGRectMake(-1000, -1000, 10, 10)];
    [_volumeView userActivity];
    [self.view addSubview:_volumeView];
    
    [self addNote];
    
    voiceSlider.minimumValue = 0;
    voiceSlider.maximumValue = 1;
    voiceSlider.value = 0;
    heartBtn.hidden = YES;
    
    [songProgressSlider setThumbImage:[UIImage imageNamed:@"k24_thumb"] forState:UIControlStateNormal];
    [ppBtn setImage:[UIImage imageNamed:@"k37_pause"] forState:UIControlStateNormal];
    [voiceSlider setThumbImage:[UIImage imageNamed:@"k38_voiceBoll"] forState:UIControlStateNormal];
    
    [self initAudioSession];
    
    voiceSlider.value  = [[AVAudioSession sharedInstance] outputVolume];
    
    dataCheck = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkTheUIData) userInfo:nil repeats:YES];
    [dataCheck fire];
    

}

- (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

-(void)initWithAudioPlayer {
    switch ([DFAudioPlayer currentType]) {
        case DFAudioPlayer_TYPE_IPOD:{
            _audioManager = [DFAudioPlayer sharedMe];
            [self initWithLayoutLocal];
            
        }break;
            
        case DFAudioPlayer_TYPE_PATHS:{
            _audioManager = [DFAudioPlayer sharedMe_1];
        }break;
            
        case DFAudioPlayer_TYPE_NET:{
            _audioManager = [DFAudioPlayer sharedMe_2];
            [self initWithLayoutProgram];
        }break;
            
        case DFAudioPlayer_TYPE_NONE:{
            _audioManager = [DFAudioPlayer sharedMe];
            [self initWithLayoutLocal];
        }break;
            
        default:
            break;
    }
    
    [mainBgImgv setClipsToBounds:YES];
    
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
    
    if (nowModel.isPlaying == YES) {
        [ppBtn setImage:[UIImage imageNamed:@"k37_pause"] forState:UIControlStateNormal];
    }else{
        [ppBtn setImage:[UIImage imageNamed:@"k18_play"] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [DFAction mainTask:^{
         [self initWithAudioPlayer];
    }];
}

/**
 网络资源内容绘制UI
 */
-(void)initWithLayoutProgram {
    modelType = _audioManager.mType;
    [self stepUpModelType];
    
    MusicOfPhoneMode *model = [[DFAudioPlayer sharedMe_2] mNowItem];
    songProgressSlider.minimumValue = 0;
    songProgressSlider.maximumValue = 1;
    songProgressSlider.value = [[AppInfoGeneral getValueForKey:JL_PLAY_PROGRESS] floatValue];
    
    startTimeLab.text=[AppInfoGeneral getValueForKey:JL_PLAY_START_TIME];
    
    lessTimeLab.text =[AppInfoGeneral getValueForKey:JL_PLAY_END_TIME];
    
    songNameLab.text = model.mTitle;
    
    NSString *bgUrl = model.mImgUrl; //tmpOts.songBigPicUrl;
    
    BOOL hasChinese = [self hasChinese:bgUrl];
    if(hasChinese){
        NSString *url = [bgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        [mainBgImgv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"k_I_00"]];
    }else{
        [mainBgImgv sd_setImageWithURL:[NSURL URLWithString:bgUrl]
                      placeholderImage:[UIImage imageNamed:@"k_I_00"]];
    }
}

-(void)initWithLayoutLocal {
    
    MusicOfPhoneMode *model = [[DFAudioPlayer sharedMe] mNowItem];
    if(model.mImage == nil) {
        [mainBgImgv setImage:[UIImage imageNamed:@"default"]];
    }else{
        [mainBgImgv setImage:model.mImage];
    }
    
    songProgressSlider.minimumValue = 0;
    songProgressSlider.maximumValue = 1;
    songProgressSlider.value = [[AppInfoGeneral getValueForKey:JL_PLAY_PROGRESS]floatValue];

    float realTime = [[AppInfoGeneral getValueForKey:JL_PLAY_PROGRESS]floatValue] * _audioManager.mNowItem.mTime;
    startTimeLab.text=[self timeFormatted:realTime];
    lessTimeLab.text = [DFTime stringFromSec:model.mTime];
    songNameLab.text = model.mTitle;
    authorLab.text = model.mArtist;

    [self stepUpModelType];
    
}

-(void)stepUpModelType {
     modelType = _audioManager.mMode;

    switch (modelType) {
        case DFAudioPlayer_ALL_LOOP:{
            [modelBtn setImage:[UIImage imageNamed:@"k45_CycleAll"] forState:UIControlStateNormal];
        }break;
        case DFAudioPlayer_ONE_LOOP:{
            [modelBtn setImage:[UIImage imageNamed:@"k20_singleCycle"] forState:UIControlStateNormal];
        }break;
        case DFAudioPlayer_RANDOM:{
            [modelBtn setImage:[UIImage imageNamed:@"k46_random"] forState:UIControlStateNormal];
        }break;
            
        default:
            break;
    }
}

-(void)loadImgurl:(NSNotification *)note {
    NSString *imgUrl = [note object];
    BOOL hasChinese = [self hasChinese:imgUrl];
    if(hasChinese){
        NSString *url = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        [mainBgImgv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"k_I_00"]];
    }else{
        [mainBgImgv sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"k_I_00"]];
    }
}

-(void)localMusicProgress:(NSNotification *)note {
    [DFAction mainTask:^{
        [self initWithAudioPlayer];
    }];

    NSDictionary *dict = [note object];
    startTimeLab.text = dict[@"TIME_NOW"];
    lessTimeLab.text = dict[@"TIME_END"];
    double pro = [dict[@"PROGRESS"] doubleValue];
    
    [AppInfoGeneral setJLValue:dict[@"TIME_NOW"] ForKey:JL_PLAY_START_TIME];
    [AppInfoGeneral setJLValue:dict[@"TIME_END"] ForKey:JL_PLAY_END_TIME];
    [AppInfoGeneral setJLValue:dict[@"PROGRESS"] ForKey:JL_PLAY_PROGRESS];
    
    songProgressSlider.value = pro;
    
    MusicOfPhoneMode *model = _audioManager.mNowItem;
    
    if(model.mImage == nil){
        [mainBgImgv setImage:[UIImage imageNamed:@"default"]];
    }else{
        [mainBgImgv setImage:model.mImage];
    }
    
    if([DFAudioPlayer currentType] !=0 && [DFAudioPlayer currentType] !=3){
        songNameLab.text = model.mTitle;
        
        MusicOfPhoneMode *model = [[DFAudioPlayer sharedMe_2] mNowItem];
        NSString *bgUrl = model.mImgUrl;
        BOOL hasChinese = [self hasChinese:bgUrl];
        if(hasChinese){
            NSString *url = [bgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
            [mainBgImgv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"k_I_00"]];
        }else{
            [mainBgImgv sd_setImageWithURL:[NSURL URLWithString:bgUrl]
                          placeholderImage:[UIImage imageNamed:@"k_I_00"]];
        }
        
    }else if([DFAudioPlayer currentType] == 0){
        songNameLab.text = model.mTitle;
        authorLab.text = model.mArtist;
    }
}

-(void)localMusicPlayStatus {
    [ppBtn setImage:[UIImage imageNamed:@"k37_pause"] forState:UIControlStateNormal];
    
}

-(void)localMusicPauseStatus {
    [ppBtn setImage:[UIImage imageNamed:@"k18_play"] forState:UIControlStateNormal];
    
}

-(void)localMusicContinue {
    [ppBtn setImage:[UIImage imageNamed:@"k37_pause"] forState:UIControlStateNormal];
    
}

-(void)localMusicFinish {
    [ppBtn setImage:[UIImage imageNamed:@"k18_play"] forState:UIControlStateNormal];
    [self initWithAudioPlayer];

}

-(void)checkTheUIData {
    MusicOfPhoneMode *nowModel;
    switch ([DFAudioPlayer currentType]) {
        case DFAudioPlayer_TYPE_IPOD:{
        }break;
        case DFAudioPlayer_TYPE_PATHS:{
        }break;
        case DFAudioPlayer_TYPE_NET:{
            nowModel = [[DFAudioPlayer sharedMe_2] mNowItem];
            if (_audioManager.mNetPlayer.status==1) {
                [ppBtn setImage:[UIImage imageNamed:@"k37_pause"] forState:UIControlStateNormal];
            }else{
                [ppBtn setImage:[UIImage imageNamed:@"k18_play"] forState:UIControlStateNormal];
            }
        }break;
        case DFAudioPlayer_TYPE_NONE:{
        }break;

        default:
            break;
    }
}


#pragma mark <- UIButtonAction ->
- (IBAction)blackBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self->dataCheck invalidate];
        self->dataCheck = nil;
    }];
}


- (IBAction)ppBtnAction:(id)sender {
    if (_audioManager.mState == DFAudioPlayer_PLAYING) {
        [_audioManager didPause];
        [self localMusicPauseStatus];
    }else if (_audioManager.mState == DFAudioPlayer_PAUSE || _audioManager.mState == DFAudioPlayer_STOP) {
        [_audioManager didContinue];
        [self localMusicPlayStatus];
    }
}

- (IBAction)perviousBtnAction:(id)sender {
    [_audioManager didBefore];
    [DFAction delay:1.0 Task:^{
        [self initWithAudioPlayer];
        [self localMusicPlayStatus];
    }];
}


- (IBAction)nextBtnAction:(id)sender {
    [_audioManager didNext];
    [DFAction delay:1.0 Task:^{
        [self initWithAudioPlayer];
        [self localMusicPlayStatus];
    }];
}

- (IBAction)modelBtnAction:(id)sender {
    modelType++;
    if (modelType > DFAudioPlayer_RANDOM) {
        modelType = DFAudioPlayer_ALL_LOOP;
    }
    [_audioManager setMMode:modelType];
    [self stepUpModelType];
}

#pragma mark -收藏事件
- (IBAction)heartBtnAction:(id)sender {
    
}

- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

#pragma mark <Slider>
- (IBAction)songProgress:(UISlider *)sender {
    NSString *progress = [NSString stringWithFormat:@"%f",sender.value];
    [AppInfoGeneral setJLValue:progress ForKey:JL_PLAY_PROGRESS];

    switch ([DFAudioPlayer currentType]) {
        case DFAudioPlayer_TYPE_IPOD:{
            DFAudioPlayer *player = [DFAudioPlayer sharedMe];
            float realTime = sender.value * player.mNowItem.mTime;
            player.mPlayer.currentTime = realTime;
            startTimeLab.text=[self timeFormatted:realTime];
            songProgressSlider.value=sender.value;
        }break;
            
        case DFAudioPlayer_TYPE_PATHS:{
            _audioManager = [DFAudioPlayer sharedMe_1];
        }break;
            
        case DFAudioPlayer_TYPE_NET:{
            //获取总长
            CMTime playerDuration = _audioManager.mNetPlayer.mPlayer.currentItem.duration;
            if (CMTIME_IS_INVALID(playerDuration)) {
                return;
            }
            double duration = CMTimeGetSeconds(playerDuration);
            if (isfinite(duration)) {
                float minValue = [sender minimumValue];
                float maxValue = [sender maximumValue];
                float value = [sender value];
                double thetime = duration * (value - minValue) / (maxValue - minValue);
                [AppInfoGeneral setJLValue:[self timeFormatted:thetime] ForKey:JL_PLAY_START_TIME];
                [_audioManager.mNetPlayer.mPlayer seekToTime:CMTimeMakeWithSeconds(thetime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    //[_audioManager.mNetPlayer.mPlayer play];
                }];
                
            }
        }break;
        case DFAudioPlayer_TYPE_NONE:{
        }break;
            
        default:
            break;
    }
}

- (IBAction)voiceSlider:(UISlider *)sender {
//    [[MPMusicPlayerController applicationMusicPlayer] setVolume: newVolume];
    NSLog(@"%0.2f",sender.value);
    [[DFAudioPlayer sharedMe] setPhoneVolume:sender.value];
    self.volumeSlider = nil;
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    for (UIView* newView in volumeView.subviews) {
        if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeSlider = (UISlider*)newView;
            break;
        }
    }
    /// 修改音量大小
    /// UISlider 里面的value属性可以设置和获取系统音量
    self.volumeSlider.value = sender.value;
}
-(void)controlVolume{
}
-(void)initAudioSession {
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

-(void)addNote{
    [DFNotice add:kDFAudioPlayer_PROGRESS Action:@selector(localMusicProgress:) Own:self];
    [DFNotice add:kDFAudioPlayer_PLAY Action:@selector(localMusicPlayStatus) Own:self];
    [DFNotice add:kDFAudioPlayer_PAUSE Action:@selector(localMusicPauseStatus) Own:self];
    [DFNotice add:kDFAudioPlayer_CONTINUE Action:@selector(localMusicContinue) Own:self];
    [DFNotice add:kDFAudioPlayer_FINISH Action:@selector(localMusicFinish) Own:self];
    [DFNotice add:@"img_url" Action:@selector(loadImgurl:) Own:self];
    
    [DFNotice add:kBT_DEVICE_DISCONNECT Action:@selector(noteBTDisconnectedPaired:) Own:self];
    [DFNotice add:kUI_DISCONNECTED Action:@selector(noteBTDisconnect:) Own:self];
}

-(void)dealloc{
    [DFNotice remove:kDFAudioPlayer_PROGRESS Own:self];
    [DFNotice remove:kDFAudioPlayer_PLAY Own:self];
    [DFNotice remove:kDFAudioPlayer_PAUSE Own:self];
    [DFNotice remove:kDFAudioPlayer_CONTINUE Own:self];
    [DFNotice remove:kDFAudioPlayer_FINISH Own:self];
    [DFNotice remove:@"img_url" Own:self];
    [DFNotice remove:kBT_DEVICE_DISCONNECT Own:self];
    [DFNotice remove:kUI_DISCONNECTED Own:self];
}

#pragma mark - 被动蓝牙 断开
-(void)noteBTDisconnectedPaired:(NSNotification*)note{
    [DFTools removeUserByKey:DEVICE_ID];
    NSLog(@"---> 被动 蓝牙断开。");
    BluetoothVC *vc =[[BluetoothVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 主动蓝牙 断开
-(void)noteBTDisconnect:(NSNotification*)note {
    [DFAction delay:0.2 Task:^{
        [DFTools removeUserByKey:DEVICE_ID];
        NSLog(@"---> 主动 蓝牙断开。"); 
        BluetoothVC *vc =[[BluetoothVC alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
}


-(void)volumeChanged:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"] isEqualToString:@"Audio/Video"]) {
        if ([[notification.userInfo objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"]) {
            CGFloat volume = [[notification.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
            voiceSlider.value = volume;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
