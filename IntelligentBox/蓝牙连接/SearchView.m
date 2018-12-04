//
//  SearchView.m
//  BTMate2
//
//  Created by DFung on 2017/11/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import "SearchView.h"
#import "SearchCell.h"

@interface SearchView()<UITableViewDelegate,
                        UITableViewDataSource>
{
    __weak IBOutlet UIView *subView;
    __weak IBOutlet UITableView *subTableView;
    DFTips          *loadingTp;
    
    NSMutableArray  *btEnityList;
    JL_BLEUsage     *JL_ug;
    JL_BLEApple     *bleCtrl;
    JL_CommonEntiy *selectedItem;
}
@end


@implementation SearchView

- (instancetype)init
{
    self = [DFUITools loadNib:@"SearchView"];
    if (self) {
        
        float sW = [DFUITools screen_1_W];
        float sH = [DFUITools screen_1_H];
        /*--- 由于只兼容iPhone尺寸 ---*/
        if (sW > 414.0) sW = 320.0;
        if (sH > 812.0) sH = 480.0;
        
        self.frame = CGRectMake(0, 0, sW, sH);
        subView.layer.cornerRadius = 10.0;
        
        subTableView.tableFooterView = [UIView new];
        subTableView.rowHeight = 50.0;
        subTableView.delegate = self;
        subTableView.dataSource = self;
        
        [DFAction delay:0.1 Task:^{
            [DFUIAnimation showView:self->subView Type:DFUIAnimation_TYPE_SPRING Completed:nil];
        }];

        JL_ug = [JL_BLEUsage sharedMe];
        bleCtrl = JL_ug.JL_ble_apple;
        btEnityList = JL_ug.btEnityList;
        
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self = [DFUITools loadNib:@"SearchView"];
    if (self) {
        
        float sW = [DFUITools screen_1_W];
        float sH = [DFUITools screen_1_H];
        /*--- 由于只兼容iPhone尺寸 ---*/
        if (sW > 414.0) sW = 320.0;
        if (sH > 812.0) sH = 480.0;
        
        self.frame = CGRectMake(0, 0, sW, sH);
        subView.layer.cornerRadius = 10.0;
        subView.alpha = 0;
        
        subTableView.tableFooterView = [UIView new];
        subTableView.rowHeight = 50.0;
        subTableView.delegate = self;
        subTableView.dataSource = self;
        
        [DFAction delay:0.1 Task:^{
            [DFUIAnimation showView:self->subView Type:DFUIAnimation_TYPE_SPRING Completed:nil];
        }];
        
        JL_ug = [JL_BLEUsage sharedMe];
        bleCtrl = JL_ug.JL_ble_apple;
        
    }
    
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return btEnityList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchCell ID]];
    if (cell == nil) {
        cell = [[SearchCell alloc] init];
    }
    
    JL_CommonEntiy *entity = btEnityList[indexPath.row];
    cell.cellLabel.text = entity.mItem;
    
    if (entity.isSelectedStatus) {
        cell.cellImg.image = [UIImage imageNamed:@"k9_select_yes"];
    }else{
        cell.cellImg.image = [UIImage imageNamed:@"k8_select_no"];
    }
    
    return cell;
}
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (btEnityList.count == 0) return;
    
    selectedItem = btEnityList[indexPath.row];
    
    if (selectedItem.isSelectedStatus) {
        NSLog(@"蓝牙设备不能重复连接！");
        return;
    } 
    
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.cellImg.image = [UIImage imageNamed:@"k9_select_yes"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)btnConnect:(id)sender {
    [DFNotice post:@"UI_Link_YES" Object:selectedItem];
}

- (IBAction)btnCancel:(id)sender {
    [self removeMe];
    [DFNotice post:@"UI_Link_NO" Object:nil];
}

-(void)removeMe {
    [DFUIAnimation hideView:subView
                       Type:DFUIAnimation_TYPE_SPRING
                  Completed:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

-(void)reloadCellData {
    btEnityList = JL_ug.btEnityList;
    [subTableView reloadData];
}


@end
