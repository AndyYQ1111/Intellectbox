//
//  HistoryViewController.m
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "HistoryViewController.h"
#import "SearchTableViewCell.h"
#import "FMDBHelper.h"
#import "PlayTools.h"
#import "PlayMusicViewController.h"

@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) FMDBHelper *fmdb;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fmdb = [FMDBHelper sharedInstance];
    
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, SNavigationBarHeight, kJL_W, kJL_H - SNavigationBarHeight - TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.separatorColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:245 / 255.0 alpha:1.0];
    self.tableV.tableFooterView = [UIView new];
    self.tableV.rowHeight = 145;
    [self.view addSubview:self.tableV];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.dataArray = [NSMutableArray arrayWithArray:[self.fmdb getHistoryList]];
}

#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [SearchTableViewCell cellWithTableView:tableView];
    
    SearchDataModel *model = self.dataArray[indexPath.row];
    
    [cell assignWithFace:model.jpgUrl title:model.title duration:[ToolManager timeFormatted:[model.duration intValue]] btnTitle:@"删除记录"];
    
    WeakSelf
    cell.SearchTableViewCellBlock = ^{
        if ([[FMDBHelper sharedInstance] deleteHistoryWithTrackid:model.trackId]) {
            [DFUITools showText:@"删除成功" onView:self.view delay:1.0];
            [weakSelf.dataArray removeObject:model];
            [weakSelf.tableV reloadData];
            
        }else {
            [DFUITools showText:@"删除失败" onView:self.view delay:1.0];
        }
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
