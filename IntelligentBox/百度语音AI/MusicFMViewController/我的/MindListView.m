//
//  MindListView.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/16.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MindListView.h"
#import "JLDefine.h"

@interface MindListView()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *listTable;
    NSArray *textArray;
}

@end

@implementation MindListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initWithLayout];
    }
    return self;
}

-(void)initWithLayout {
    //initData
    if (APP_SUOAI) {
        textArray = @[@"本地音乐", @"我的闹钟", @"播放历史", @"收藏记录"];//索爱定制
    }else{
        textArray = @[@"本地音乐"];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    listTable.tableFooterView = [UIView new];
    listTable.rowHeight = 60;
    listTable.backgroundColor = [UIColor clearColor];
    listTable.dataSource = self;
    listTable.delegate = self;
    [self addSubview:listTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return textArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listViewCell"];
    cell.textLabel.text = textArray[indexPath.row];

    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"k_AM%ld", indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell的分割线从0坐标开始
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [DFNotice post:MINDLIST_NOTI Object:@(indexPath.row)];
}

@end
