//
//  SetCycleView.m
//  CMD_APP
//
//  Created by Ezio on 2018/2/8.
//  Copyright © 2018年 DFung. All rights reserved.
//

#import "SetCycleView.h"
#import "DownloadCell.h"


@interface SetCycleView()<UITableViewDelegate,UITableViewDataSource>{

    __weak IBOutlet UIImageView *bgView;
    __weak IBOutlet UIView *centerView;
    
    
}

@end
@implementation SetCycleView
@synthesize selectedArray;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"SetCycleView" owner:self options:nil][0];
    if (self) {
        self.frame = frame;
        centerView.layer.cornerRadius = 8;
        centerView.layer.masksToBounds = YES;
                
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.tableFooterView = [UIView new];
        _listTable.rowHeight = 40;
        _listTable.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction:)];
        [bgView addGestureRecognizer:tapges];
        _cancelBtn.tag = 0;
        _finishBtn.tag = 1;
    }
    
    return self;
}


-(void)setRepeatMode:(uint8_t)repeatMode{
    _repeatMode = repeatMode;
    [self stringMode:_repeatMode];
    [_listTable reloadData];
}

-(void)stringMode:(uint8_t)mode{
    
    selectedArray = [NSMutableArray new];
    uint8_t bt_0 = mode    &0x01;
    uint8_t bt_1 = mode>>1 &0x01;
    uint8_t bt_2 = mode>>2 &0x01;
    uint8_t bt_3 = mode>>3 &0x01;
    uint8_t bt_4 = mode>>4 &0x01;
    uint8_t bt_5 = mode>>5 &0x01;
    uint8_t bt_6 = mode>>6 &0x01;
    uint8_t bt_7 = mode>>7 &0x01;
    
    if (bt_0) {[selectedArray addObject:@"0"];}
    if (bt_1) {[selectedArray addObject:@"1"];}
    if (bt_2) {[selectedArray addObject:@"2"];}
    if (bt_3) {[selectedArray addObject:@"3"];}
    if (bt_4) {[selectedArray addObject:@"4"];}
    if (bt_5) {[selectedArray addObject:@"5"];}
    if (bt_6) {[selectedArray addObject:@"6"];}
    if (bt_7) {[selectedArray addObject:@"7"];}
    
}


- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSelectBtnAction:WithArray:)]) {
        [_delegate didSelectBtnAction:_cancelBtn WithArray:selectedArray];
    }
}

- (IBAction)finishBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSelectBtnAction:WithArray:)]) {
        [_delegate didSelectBtnAction:_finishBtn WithArray:selectedArray];
    }
}

#pragma mark <- listTableDelegate ->
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cycleArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell"];
    if (!cell) {
        cell = [[DownloadCell alloc] init];
    }
    //NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    if (indexPath.row == 0) {
        if ([selectedArray containsObject:@"0"]) {
            cell.itemImgv.image = [UIImage imageNamed:@"k9_select_yes"];
        }else{
            cell.itemImgv.image = [UIImage imageNamed:@"k8_select_no"];
        }
    }
    if (indexPath.row == 1) {
        if ([selectedArray containsObject:@"1"] &&
            [selectedArray containsObject:@"2"] &&
            [selectedArray containsObject:@"3"] &&
            [selectedArray containsObject:@"4"] &&
            [selectedArray containsObject:@"5"] &&
            [selectedArray containsObject:@"6"] &&
            [selectedArray containsObject:@"7"] &&
            ![selectedArray containsObject:@"0"])
        {
            cell.itemImgv.image = [UIImage imageNamed:@"k9_select_yes"];
        }else{
            cell.itemImgv.image = [UIImage imageNamed:@"k8_select_no"];
        }
    }
    
//    if ([selectedArray containsObject:str]) {
//        cell.itemImgv.image = [UIImage imageNamed:@"k9_select_yes"];
//    }else{
//        cell.itemImgv.image = [UIImage imageNamed:@"k8_select_no"];
//    }
    cell.itemLab.text = _cycleArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if ([selectedArray containsObject:@"0"]) {
            [selectedArray removeObject:@"0"];
        }else{
            [selectedArray removeAllObjects];
            [selectedArray addObject:@"0"];
        }
    }else{
        if ([selectedArray containsObject:@"0"]) {
            [selectedArray removeAllObjects];
            
            [selectedArray addObject:@"1"];
            [selectedArray addObject:@"2"];
            [selectedArray addObject:@"3"];
            [selectedArray addObject:@"4"];
            [selectedArray addObject:@"5"];
            [selectedArray addObject:@"6"];
            [selectedArray addObject:@"7"];
        }else{
            [selectedArray removeAllObjects];
            //[selectedArray addObject:@"0"];
        }

    }
    [_listTable reloadData];
//    if ([_delegate respondsToSelector:@selector(didComfintBtnAction:)]) {
//        [_delegate didComfintBtnAction:indexPath.row];
//    }
    
}




@end
