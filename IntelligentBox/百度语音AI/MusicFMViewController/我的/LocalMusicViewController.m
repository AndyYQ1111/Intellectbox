//
//  LocalMusicViewController.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/26.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "LocalMusicViewController.h"
#import "JLDefine.h"
#import "songListTbCell.h"
#import "PlayMusicViewController.h"
#import "AppInfoGeneral.h"
#import <DFUnits/DFUnits.h>

@interface LocalMusicViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *ListTable;
    __weak IBOutlet UIButton *intoBtn;
      NSTimer *checkData;
}

@end

@implementation LocalMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ListTable.dataSource = self;
    ListTable.delegate = self;
    ListTable.rowHeight = 60;
    ListTable.tableFooterView = [UIView new];
    
    /*--- 实例化iPod播放器 ---*/
    _mAudioPlayer = [DFAudioPlayer sharedMe];
    _mItemArray  = _mAudioPlayer.mList;
    
    [DFNotice add:kDFAudioPlayer_PROGRESS Action:@selector(notePlayDetails:) Own:self];
}

-(void)notePlayDetails:(NSNotification*)note{
    //NSLog(@"LocalMusicViewController---notePlayDetails");
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
    
    [intoBtn.imageView startAnimating];
}

-(void)viewWillAppear:(BOOL)animated{
    
    /*--- 再次读取ipod歌曲 ---*/
    if (_mItemArray.count == 0) {
        [DFAction delay:2.0 Task:^{
            self->_mAudioPlayer = [DFAudioPlayer sharedMe];
            self->_mItemArray   = self->_mAudioPlayer.mList;
            [self->ListTable reloadData];
        }];
    }else {
        [_mItemArray removeAllObjects];
        [_mAudioPlayer reloadPhoneMusic];
        
        if(_mAudioPlayer.mState==1){
            [_mAudioPlayer didContinue];
        }else if(_mAudioPlayer.mState==2){
            [_mAudioPlayer didPause];
        }
        [ListTable reloadData];
    }
    
    intoBtn.imageView.animationImages = @[[UIImage imageNamed:@"K11_playing"],
                                          [UIImage imageNamed:@"k12_playing"],
                                          [UIImage imageNamed:@"k13_playing"],
                                          [UIImage imageNamed:@"k14_playing"],
                                          ];
    intoBtn.imageView.animationDuration = 1;
    intoBtn.imageView.animationRepeatCount = 0;
    

    [checkData invalidate];
    checkData = nil;
    checkData = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(toReloadData)
                                               userInfo:nil repeats:YES];
    [checkData fire];
    
    [ListTable reloadData];
    
}

-(void)toReloadData{
//    [_mItemArray removeAllObjects];
//    [[DFAudioPlayer sharedMe] reloadPhoneMusic];
//    [ListTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [checkData invalidate];
    checkData = nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)moreMusicBtnAction:(id)sender {
    PlayMusicViewController *vc = [[PlayMusicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)leftBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark <- uitabeviewdelegat ->
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mItemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    songListTbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songListTbCell"];
    if (cell == nil) {
        cell = [[songListTbCell alloc] init];
        
    }
    //NSArray *itemArray = [[DFAudioPlayer sharedMe] mList];
    MusicOfPhoneMode *model = _mItemArray[indexPath.row];
    
    //if (indexPath.row == [[AppInfoGeneral getValueForKey:JL_PLAY_INDEX] intValue]) {
    if (model.isPlaying) {
        if ([[DFAudioPlayer sharedMe] mState] == DFAudioPlayer_PLAYING ||
            [[DFAudioPlayer sharedMe] mState] == DFAudioPlayer_PAUSE) {
            cell.titleLab.textColor = [UIColor colorWithRed:251/255.0 green:44/255.0 blue:130.0/255.0 alpha:1];
        }
        cell.animaImgv.hidden = NO;
        cell.animaImgv.animationImages = @[[UIImage imageNamed:@"k48_playing"],
                                           [UIImage imageNamed:@"k49_playing"],
                                           [UIImage imageNamed:@"k50_playing"],
                                           [UIImage imageNamed:@"k51_playing"]];
        cell.animaImgv.animationDuration = 0.6;
        cell.animaImgv.animationRepeatCount = 0;
        if ([[DFAudioPlayer sharedMe] mState] == DFAudioPlayer_PLAYING) {
            [intoBtn.imageView startAnimating];
            [cell.animaImgv startAnimating];
            cell.numLab.hidden = YES;
        }else{
            [intoBtn.imageView stopAnimating];
            [cell.animaImgv stopAnimating];
            [cell.animaImgv setImage:[UIImage imageNamed:@"k48_playing"]];
            cell.numLab.hidden = YES;
        }
        
    }else{
        cell.titleLab.textColor = [UIColor darkTextColor];
        cell.animaImgv.hidden = YES;
        cell.numLab.hidden = NO;
    }
    
    cell.numLab.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
    cell.titleLab.text = model.mTitle;
    cell.IntroLab.text = model.mArtist;
    [cell.selectBtn setImage:[UIImage imageNamed:@"k_C_01"] forState:UIControlStateNormal];
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self stopOtherPlayer];
    [[DFAudioPlayer sharedMe] didPlay:indexPath.row];
    //[AppInfoGeneral setJLValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] ForKey:JL_PLAY_INDEX];
    [intoBtn.imageView startAnimating];
    
    [ListTable reloadData];
}

-(void)stopOtherPlayer{
    [DFAudioPlayer didPauseLast];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
