//
//  AlbumsViewController.m
//  IntelligentBox
//
//  Created by KW on 2018/8/9.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AlbumsViewController.h"
#import "MusicCollectionCell.h" 
#import "MusicMainModel.h"
#import "AlbumsDetailViewController.h"
#define w (kJL_W - 45) / 2

@interface AlbumsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *dataArray;
//0：正序 1：倒叙
@property (nonatomic, assign) int orderType;
@property (nonatomic, assign) int currentPage;
@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectView];
    
    self.orderType = 0;
    self.currentPage = 1;
    [self loadAlbumsListData];
    [self addHeaderRefresh];
}

//首页数据
- (void)loadAlbumsListData {
    NSString *urlStr = @"mediaInfos.php?act=getSonCategories";
    NSDictionary *paraDic = @{
                              @"devId" : [ToolManager getDefaultData:DEVICE_ID],
                              @"BTAddress" : @"",
                              @"token" : [ToolManager getDefaultData:@"token"],
                              @"catId" : self.catid,
                              @"orderType" : @(self.orderType),
                              @"pageIndex" : @(self.currentPage),
                              @"countPerPage" : @"10"
                              };
    
    [[AFManagerClient sharedClient] postRequestWithUrl:urlStr parameters:paraDic success:^(id responseObject) {
        
        AlbumsListModel *model = [MTLJSONAdapter modelOfClass:[AlbumsListModel class] fromJSONDictionary:responseObject error:NULL];
        if([model.result isEqualToString:@"ok"]) {
            if(self.currentPage < 2) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data];
            if (model.data.count > 0) {
                [self addFooterRefresh];
            }else {
                [self.collectView.mj_footer removeFromSuperview];
            }
            
            [self.collectView.mj_header endRefreshing];
            [self.collectView reloadData];
        }
    } failure:^(NSError *  error) {
        [self.collectView.mj_header endRefreshing];
    }];
}

- (void)addHeaderRefresh {
    WeakSelf
    [ToolManager addHeaderRefreshWithView:self.collectView complete:^{
        weakSelf.currentPage = 1;
        [weakSelf loadAlbumsListData];
    }];
}

- (void)addFooterRefresh {
    WeakSelf
    [ToolManager addFooterRefreshWithView:self.collectView complete:^{
        weakSelf.currentPage ++;
        [weakSelf loadAlbumsListData];
    }];
}

#pragma mark -collectionview delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MusicCollectionCell" forIndexPath:indexPath];
    
    MainColumnsModel *model = self.dataArray[indexPath.row];

    [cell.faceImgView sd_setImageWithURL:[NSURL URLWithString:model.jpgUrl] placeholderImage:PLACE_IMAGE];
    cell.titleLabel.text = model.title;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MainColumnsModel *model = self.dataArray[indexPath.row];
    [self pushAlumsDetailVCWithCatid:model.catId title:model.title faceUrl:model.jpgUrl];
}
- (void)pushAlumsDetailVCWithCatid:(NSString *)catid title:(NSString *)aTitle faceUrl:(NSString *)face {
    AlbumsDetailViewController *vc = [[AlbumsDetailViewController alloc] init];
    vc.catid = catid;
    vc.faceUrl = face;
    vc.vcTitle = aTitle;
    vc.rightImage = [UIImage imageNamed:@"k48_playing"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectView {
    if (!_collectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(w, 93.0 / 165.0 * w + 38);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 20;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 15;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 0, 15);
        
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SNavigationBarHeight, kJL_W, kJL_H - SNavigationBarHeight - TabbarSafeBottomMargin) collectionViewLayout:flowLayout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.backgroundColor = [UIColor whiteColor];
        [_collectView registerClass:[MusicCollectionCell class] forCellWithReuseIdentifier:@"MusicCollectionCell"];
    }
    return _collectView;
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
