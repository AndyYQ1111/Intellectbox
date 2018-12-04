//
//  MusicCollectionView.m
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MusicCollectionView.h"
#import "MusicCollectionCell.h"
#import "MusicAdCollectionReusableView.h"
#import "MusicRecomCollectionReusableView.h"
#import "AlbumsViewController.h"
#import "AlbumsDetailViewController.h"

@interface MusicCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
//轮播广告
@property (nonatomic, strong) NSArray *adArray;
//分类
@property (nonatomic, strong) NSArray *sortImgArray;
//推荐歌单
@property (nonatomic, strong) NSArray *recommenArray;
@end

@implementation MusicCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        [self registerClass:[MusicCollectionCell class] forCellWithReuseIdentifier:@"MusicCollectionCell"];
        [self registerClass:[MusicAdCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MusicAdCollectionReusableView"];
        [self registerClass:[MusicRecomCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MusicRecomCollectionReusableView"];
    }
    return self;
}

- (void)setModel:(MusicMainModel *)model {
    _model = model;
    
    //轮播
    NSMutableArray *rollTempArr = [NSMutableArray new];
    for (MainColumnsModel *columModel in model.rollingColumns) {
        [rollTempArr addObject:columModel.jpgUrl];
    }
    self.adArray = [NSArray arrayWithArray:rollTempArr]; 
    //分类
    NSMutableArray *tempArr = [NSMutableArray array];
    for (MainColumnsModel *columModel in model.classicColumns) {
        [tempArr addObject:columModel.jpgUrl];
    }
    self.sortImgArray = [NSArray arrayWithArray:tempArr];
    //模块
    self.recommenArray = [NSArray arrayWithArray:model.regionColumns];
    [self reloadData];
}

#pragma mark -collectionview delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        RegionColumnsModel *reModel = (RegionColumnsModel *)self.recommenArray[section - 1];
        return reModel.sonColumns.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 + self.recommenArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return nil;
    }else {
        MusicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MusicCollectionCell" forIndexPath:indexPath];
        
        RegionColumnsModel *reModel = (RegionColumnsModel *)self.recommenArray[indexPath.section - 1];
        MainColumnsModel *sonModel = (MainColumnsModel *)reModel.sonColumns[indexPath.row];
        [cell.faceImgView sd_setImageWithURL:[NSURL URLWithString:sonModel.jpgUrl] placeholderImage:PLACE_IMAGE];
        cell.titleLabel.text = sonModel.title;
        
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WeakSelf
        if (indexPath.section == 0) {
            MusicAdCollectionReusableView *adHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MusicAdCollectionReusableView" forIndexPath:indexPath];
            
            [adHeader assignWithAd:self.adArray sortArray:self.sortImgArray];
            adHeader.MusicAdCellBlock = ^(NSInteger index) {
                if (index / 100 == 1) { //菜单
                    MainColumnsModel *cmodel = self.model.classicColumns[index - 100];
                    if ([cmodel.catType isEqualToString:@"1"]) { //列表
                        [self pushAlbumsVCWithCatid:cmodel.catId title:cmodel.title];
                        
                    }else { //详情
                        [self pushAlumsDetailVCWithCatid:cmodel.catId title:cmodel.title faceUrl:cmodel.jpgUrl];
                    }
                    
                }else { //轮播
                    MainColumnsModel *model = weakSelf.model.rollingColumns[index - 200];
                    if ([model.catType isEqualToString:@"1"]) { //列表
                        [self pushAlbumsVCWithCatid:model.catId title:model.title];
                        
                    }else { //详情
                        [self pushAlumsDetailVCWithCatid:model.catId title:model.title faceUrl:model.jpgUrl];
                    }
                }
            };
            return adHeader;
            
        }else {
            MusicRecomCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MusicRecomCollectionReusableView" forIndexPath:indexPath];
            
            RegionColumnsModel *reModel = (RegionColumnsModel *)weakSelf.recommenArray[indexPath.section - 1];
            header.title = reModel.title;
            header.MusicHeaderViewBlock = ^ (void) {
                //更多
                [weakSelf pushAlbumsVCWithCatid:reModel.catId title:reModel.title];
            };
            return header;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        //160.0 / 375.0 * kJL_W
         return CGSizeMake(self.frame.size.width, 200 + 60);
    }else {
         return CGSizeMake(self.frame.size.width, 48);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RegionColumnsModel *reModel = (RegionColumnsModel *)self.recommenArray[indexPath.section - 1];
    MainColumnsModel *sonModel = (MainColumnsModel *)reModel.sonColumns[indexPath.row];
    
    if ([sonModel.catType isEqualToString:@"1"]) { //列表
        [self pushAlbumsVCWithCatid:sonModel.catId title:sonModel.title];
        
    }else { //详情
        [self pushAlumsDetailVCWithCatid:sonModel.catId title:sonModel.title faceUrl:sonModel.jpgUrl];
    }
}


#pragma mark -查看专辑列表
- (void)pushAlbumsVCWithCatid:(NSString *)catid title:(NSString *)aTitle {
    AlbumsViewController *vc = [[AlbumsViewController alloc] init];
    vc.catid = catid;
    vc.vcTitle = aTitle;
    vc.rightImage = [UIImage imageNamed:@"k48_playing"];
    [[ToolManager viewController:self] presentViewController:vc animated:YES completion:nil];
}

- (void)pushAlumsDetailVCWithCatid:(NSString *)catid title:(NSString *)aTitle faceUrl:(NSString *)face {
    AlbumsDetailViewController *vc = [[AlbumsDetailViewController alloc] init];
    vc.catid = catid;
    vc.faceUrl = face;
    vc.vcTitle = aTitle;
    vc.rightImage = [UIImage imageNamed:@"k48_playing"];
    [[ToolManager viewController:self] presentViewController:vc animated:YES completion:nil];
}
@end
