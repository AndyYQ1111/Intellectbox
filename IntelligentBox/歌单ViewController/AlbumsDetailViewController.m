//
//  AlbumsDetailViewController.m
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AlbumsDetailViewController.h"
#import "SearchTableViewCell.h"
#import "SongListTableViewCell.h"
#import "SongListHeaderView.h"
#import "PlayMusicViewController.h"
#import "MusicMainModel.h"
#import "FMDBHelper.h"

@interface AlbumsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) int currentPage;
//0 正序  1 倒序
@property (nonatomic, assign) int orderType;
@property (nonatomic, strong) FMDBHelper *fmdb;
@end

@implementation AlbumsDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fmdb = [FMDBHelper sharedInstance];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, SNavigationBarHeight, kJL_W, kJL_H - SNavigationBarHeight - TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.separatorColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:245 / 255.0 alpha:1.0];
    self.tableV.tableFooterView = [UIView new];
    [self.view addSubview:self.tableV];
    
    self.rightBtn.imageView.animationImages = @[[UIImage imageNamed:@"K11_playing"],
                                          [UIImage imageNamed:@"k12_playing"],
                                          [UIImage imageNamed:@"k13_playing"],
                                          [UIImage imageNamed:@"k14_playing"],
                                          ];
    self.rightBtn.imageView.animationDuration = 1;
    self.rightBtn.imageView.animationRepeatCount = 0;
    [self.rightBtn addTarget:self action:@selector(pushPlayVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentPage = 1;
    self.orderType = 0;
    [self loadResultData];
    [self addHeaderRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableV reloadData];
}

//获取数据
- (void)loadResultData {
    NSString *urlStr = @"mediaInfos.php?act=getTrackList";
    NSDictionary *paraDic = @{
                              @"devId" : [ToolManager getDefaultData:DEVICE_ID],
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @"",
                              @"pageIndex" : @(self.currentPage),
                              @"countPerPage" : @"10",
                              @"catId" : self.catid,
                              @"orderType" : @(self.orderType)
                              };
    
    [[AFManagerClient sharedClient] postRequestWithUrl:urlStr parameters:paraDic success:^(id responseObject) {
        
        SearchResultModel *model = [MTLJSONAdapter modelOfClass:[SearchResultModel class] fromJSONDictionary:responseObject error:NULL];
        if([model.result isEqualToString:@"ok"]) {
            if(self.currentPage < 2) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data];
            if (model.data.count > 0) {
                [self addFooterRefresh];
            }else {
                [self.tableV.mj_footer removeFromSuperview];
            }
            
            [self.tableV.mj_header endRefreshing];
            [self.tableV reloadData];
            [DFUITools removeHUD];
            
        }else {
            [self loadError];
        }
        
    } failure:^(NSError *  error) {
        [self loadError];
    }];
    
    [DFUITools showHUDWithLabel:@"" onView:self.view
                          color:[UIColor blackColor]
                 labelTextColor:[UIColor whiteColor]
         activityIndicatorColor:[UIColor whiteColor]];
}

- (void)loadError {
    [DFUITools removeHUD];
    [self.tableV.mj_header endRefreshing];
    [DFUITools showText:@"加载出错" onView:self.view delay:1.0];
}

- (void)addHeaderRefresh {
    WeakSelf
    [ToolManager addHeaderRefreshWithView:self.tableV complete:^{
        weakSelf.currentPage = 1;
        [weakSelf loadResultData];
    }];
}

- (void)addFooterRefresh {
    WeakSelf
    [ToolManager addFooterRefreshWithView:self.tableV complete:^{
        weakSelf.currentPage ++;
        [weakSelf loadResultData];
    }];
}

- (void)pushPlayVC {
    PlayMusicViewController *vc = [[PlayMusicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
//    [DFNotice post:@"img_url" Object:_albumDic.coverUrl];
}

#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }else {
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SearchTableViewCell *cell = [SearchTableViewCell cellWithTableView:tableView];
        [cell assignWithFace:self.faceUrl title:self.vcTitle duration:nil btnTitle:nil];
        return cell;
        
    }else {
        SongListTableViewCell *cell = [SongListTableViewCell cellWithTableView:tableView];
        SearchDataModel *model = self.dataArray[indexPath.row];
        
        MusicOfPhoneMode *playModel = [[DFAudioPlayer sharedMe_2] mNowItem];
        BOOL status = 0;
        if ([model.trackId isEqualToString:playModel.mMediaItem]) {
            status = 1;
        }
        [cell assginWithTitle:model.title
                     duration:[NSString stringWithFormat:@"%@  %@", self.vcTitle, [ToolManager timeFormatted:[model.duration intValue]]]
                 isCollection:[model.isCherish boolValue]
                    isplaying:status];
        
        WeakSelf
        cell.SongListCellBlock = ^{
            [weakSelf collectionActionWithTrackid:model.trackId isCollect:![model.isCherish boolValue] index:indexPath.row];
        };
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    }else {
        SongListHeaderView *headerView = [SongListHeaderView headerViewWithTableView:tableView];
        headerView.selectedIndex = self.orderType;
        
        WeakSelf
        headerView.SongListHeaderViewBlock = ^(NSInteger index) {
            if (index == 12) { //回放  
                [[DFAudioPlayer sharedMe_2] didBefore];
                [self.tableV reloadData];
                
            }else {
                weakSelf.currentPage = 1;
                weakSelf.orderType = (int)index - 10;
                [weakSelf loadResultData];
            }
        };
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self stopOtherPlayer];
        
        NSMutableArray *tmpArray = [NSMutableArray new];
        for (int i = 0;i < self.dataArray.count; i++ ) {
            MusicOfPhoneMode *model = [MusicOfPhoneMode new];
            SearchDataModel *songitem = self.dataArray[i];
            model.mIndex = i;
            model.mUrl = songitem.playUrl;
            model.mTime = [songitem.duration intValue];
            //作为唯一标识符
            model.mMediaItem = songitem.trackId;
            model.mImgUrl = songitem.jpgUrl;
            [tmpArray addObject:model];
        }
        
        [[DFAudioPlayer sharedMe_2] setNetPaths:tmpArray];
        [[DFAudioPlayer sharedMe_2] didPlay:indexPath.row];
        
        NSArray *array = @[self.selectedIndexPath, indexPath];
        self.selectedIndexPath = indexPath;
        
        [self.tableV reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        
        //添加到历史记录
        SearchDataModel *songitem = self.dataArray[indexPath.row];
        [self.fmdb updateWithSong:songitem];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.rightBtn.imageView startAnimating];
        });
    }
}



-(void)stopOtherPlayer{
    [DFAudioPlayer didPauseLast];
}

#pragma mark -收藏事件
- (void)collectionActionWithTrackid:(NSString *)trackid isCollect:(BOOL)collect index:(NSInteger)row {
    NSString *urlStr = @"mediaInfos.php?act=cherishOneTrack";
    NSDictionary *paraDic = @{
                              @"devId" : [ToolManager getDefaultData:DEVICE_ID],
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @"",
                              @"type" : @(collect),
                              @"trackId" : trackid //音频id
                              };
    
    [[AFManagerClient sharedClient] postRequestWithUrl:urlStr parameters:paraDic success:^(id responseObject) {
        if([responseObject[@"result"] isEqualToString:@"ok"]) {
            if (collect) {
                [DFUITools showText:@"收藏成功" onView:self.view delay:1.0];
            }else {
                [DFUITools showText:@"取消收藏成功" onView:self.view delay:1.0];
            }
            SearchDataModel *model = self.dataArray[row];
            model.isCherish = [NSString stringWithFormat:@"%d", collect];
            [self.dataArray replaceObjectAtIndex:row withObject:model];
            [self.tableV reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }failure:^(NSError *  error) {
        
    }];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
