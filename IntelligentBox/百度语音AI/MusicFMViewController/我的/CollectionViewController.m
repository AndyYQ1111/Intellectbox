//
//  CollectionViewController.m
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "CollectionViewController.h"
#import "SearchTableViewCell.h"
#import "MusicMainModel.h"
#import "PlayTools.h"
#import "PlayMusicViewController.h"

@interface CollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, assign) int currentPage;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, SNavigationBarHeight, kJL_W, kJL_H - SNavigationBarHeight - TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.separatorColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:245 / 255.0 alpha:1.0];
    self.tableV.tableFooterView = [UIView new];
    self.tableV.rowHeight = 145;
    [self.view addSubview:self.tableV];
    
    self.currentPage = 1;
    [self loadResultData];
    [self addHeaderRefresh];
    
}

//获取数据
- (void)loadResultData {
    NSString *urlStr = @"mediaInfos.php?act=getCherishList";
    NSDictionary *paraDic = @{
                              @"devId" : [ToolManager getDefaultData:DEVICE_ID],
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @"",
                              @"pageIndex" : @(self.currentPage),
                              @"countPerPage" : @"10"
                              };
    
    [[AFManagerClient sharedClient] postRequestWithUrl:urlStr parameters:paraDic success:^(id responseObject) {
        
        SearchResultModel *model = [MTLJSONAdapter modelOfClass:[SearchResultModel class] fromJSONDictionary:responseObject error:NULL];
        if([model.result isEqualToString:@"ok"]) {
            if(self.currentPage < 2) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data];
            if (model.data.count >= 10) {
                [self addFooterRefresh];
            }else {
                [self.tableV.mj_footer removeFromSuperview];
            }
            
            [self.tableV.mj_header endRefreshing];
            [self.tableV reloadData];
        }
        
    } failure:^(NSError *  error) {
        [self.tableV.mj_header endRefreshing];
    }];
}

- (void)cancleTheCollection:(NSInteger)index {
    SearchDataModel *model = self.dataArray[index];
    
    NSString *urlStr = @"mediaInfos.php?act=cherishOneTrack";
    NSDictionary *paraDic = @{
                              @"devId" : [ToolManager getDefaultData:DEVICE_ID],
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"] ? [ToolManager getDefaultData:@"token"] : @"",
                              @"trackId" : model.trackId,
                              @"type" : @"0"
                              };
    
    [[AFManagerClient sharedClient] postRequestWithUrl:urlStr parameters:paraDic success:^(id responseObject) {
        
        if([responseObject[@"result"] isEqualToString:@"ok"]) {
            [DFUITools showText:@"取消收藏成功" onView:self.view delay:1.0];
            [self.dataArray removeObject:model];
            [self.tableV reloadData];
        }
    }failure:^(NSError *error) {
        
    }];
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

#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [SearchTableViewCell cellWithTableView:tableView];
    SearchDataModel *model = self.dataArray[indexPath.row];
    
    [cell assignWithFace:model.jpgUrl title:model.title duration:[ToolManager timeFormatted:[model.duration intValue]] btnTitle:@"取消收藏"];
    
    WeakSelf
    cell.SearchTableViewCellBlock = ^{ //取消收藏
        [weakSelf cancleTheCollection:indexPath.row];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchDataModel *model = self.dataArray[indexPath.row];
    [[PlayTools shareManage] playWithModel:model];
    
    PlayMusicViewController *vc = [[PlayMusicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
