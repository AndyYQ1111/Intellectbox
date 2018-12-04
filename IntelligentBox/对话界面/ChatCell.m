//
//  ChatCell.m
//  IntelligentBox
//
//  Created by DFung on 2017/11/17.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "ChatCell.h"
#import "JLDefine.h"
#import "OTSongInfo.h"

#define kFont       14

@interface ChatCell()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *listArray;
}

@property (nonatomic, strong) UITableView *listTable;
@end

static CGFloat max_W;
static NSArray *currentList;

@implementation ChatCell

+ (NSString *)ID {
    return @"CHATCell";
}

+ (CGFloat)cellHeight:(NSDictionary*)info{
    NSString *text = info[@"TEXT"];
    
    CGFloat w = kJL_W - 40.0 - 70.0;
    CGFloat height;
    if (info[@"LIST"]) {
        NSArray *tmpArray = info[@"LIST"];
        if (tmpArray.count>0) {
            NSDictionary * dic = tmpArray[0];
            NSString * title = dic[@"title"];
            title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (title.length<1) {
                height = 10;
                return 0;
            }else{
                height = tmpArray.count * 30 + 10;
            }
        }else{
            height = tmpArray.count * 30 + 10;
        }
    }else{
        height = [DFUITools labelHeightByWidth:w Text:text Font:[UIFont systemFontOfSize:kFont]];
    }
    return height + 40.0;
}

-(void)setInfo:(NSDictionary*)info {
    NSString *type = info[@"TYPE"];
    NSString *text = info[@"TEXT"];
    
    CGFloat w = kJL_W - 40.0 - 70.0;
    CGFloat lb_h = [DFUITools labelHeightByWidth:w Text:text Font:[UIFont systemFontOfSize:kFont]];
    CGFloat lb_w = [DFUITools labelWidthByWidth:w Text:text Font:[UIFont systemFontOfSize:kFont]];
    
    /*--- 机器 ---*/
    if ([type isEqual:@"0"]) {
        UIImage *img_0 = [UIImage imageNamed:@"k7_speek"];
        img_0 = [img_0 resizableImageWithCapInsets:UIEdgeInsetsMake(35.0, 25.0, 15.0, 15.0)
                                       resizingMode:UIImageResizingModeStretch];
        
        UIImageView *imageView_0 = [UIImageView new];
        imageView_0.frame = CGRectMake(5.0, 10.0, lb_w + 35.0, lb_h + 20.0);
        imageView_0.image = img_0;
        [self.contentView addSubview:imageView_0];
        
        UILabel *label_0 = [UILabel new];
        label_0.text = text;
        label_0.textColor = [UIColor darkGrayColor];
        label_0.font = [UIFont systemFontOfSize:kFont];
        label_0.numberOfLines = 0;
        label_0.frame = CGRectMake(25.0, 10, lb_w, lb_h);
        [imageView_0 addSubview:label_0];
    }
    
    /*--- 我 ---*/
    if ([type isEqual:@"1"]) {
        UIImage *img_1 = [UIImage imageNamed:@"k6_speek"];
        img_1 = [img_1 resizableImageWithCapInsets:UIEdgeInsetsMake(35.0, 15.0, 15.0, 25.0)
                                      resizingMode:UIImageResizingModeStretch];
        
        UIImageView *imageView_1 = [UIImageView new];
        imageView_1.frame = CGRectMake(kJL_W-(5.0+lb_w+35.0), 10.0, lb_w+35.0, lb_h+20.0);
        imageView_1.image = img_1;
        [self.contentView addSubview:imageView_1];
        
        UILabel *label_1 = [UILabel new];
        label_1.text = text;
        label_1.textColor = [UIColor whiteColor];
        label_1.font = [UIFont systemFontOfSize:kFont];
        label_1.numberOfLines = 0;
        label_1.frame = CGRectMake(10.0, 10.0, lb_w, lb_h);
        [imageView_1 addSubview:label_1];
    }
    
    /* 机器2 */
    if ([type isEqual:@"2"]) {
        UIImage *img_2 = [UIImage imageNamed:@"k7_speek"];
        img_2 = [img_2 resizableImageWithCapInsets:UIEdgeInsetsMake(35.0, 25.0, 15.0, 15.0)
                                      resizingMode:UIImageResizingModeStretch];
        listArray = [NSMutableArray array];
        
        if (info[@"LIST"]) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:info[@"LIST"]];
            
            for (int i = 0; i < tmpArray.count; i++) {
                NSDictionary *tmpDict = tmpArray[i];
                MusicOfPhoneMode *model = [[MusicOfPhoneMode alloc] init];
                model.mUrl = tmpDict[@"url"];
                model.mTitle = tmpDict[@"title"];
                model.mIndex = i;
                [listArray addObject:model];
                
                //播放列表宽
                CGFloat listW = [DFUITools labelWidthByWidth:w Text:tmpDict[@"title"] Font:[UIFont systemFontOfSize:kFont]];
                
                if (listW > max_W) {
                    max_W = listW;
                }
            }
        }
        currentList = [NSArray arrayWithArray:listArray];
        
        UIImageView *imageView_2 = [UIImageView new];
        imageView_2.frame = CGRectMake(5.0, 10.0, max_W + 50.0, 30.0 * listArray.count);
        imageView_2.image = img_2;
        [self addSubview:imageView_2];
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:info[@"LIST"]];
        if (tmpArray.count>0) {
            NSDictionary *tmpDict = tmpArray[0];
            NSString * str = tmpDict[@"title"];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (str.length<1) {
                imageView_2.frame = CGRectMake(0,0,0,0);
            }
        }
        
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.tableFooterView = UIView.new;
        _listTable.rowHeight = 30;
        _listTable.scrollEnabled = NO;
        _listTable.backgroundColor = [UIColor clearColor];
        _listTable.allowsSelection = YES;
        [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        self.listTable.frame = CGRectMake(10, 10, CGRectGetWidth(imageView_2.frame) - 10, imageView_2.frame.size.height);
        [self addSubview:self.listTable];
        
        [DFNotice add:kDFAudioPlayer_NOTE Action:@selector(musicState:) Own:self];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellList"];
    
    MusicOfPhoneMode *rowModel = listArray[indexPath.row];
    cell.textLabel.text = rowModel.mTitle;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MusicOfPhoneMode *model = [DFAudioPlayer currentPlayer].mNowItem;
    //indexPath.row+1 == model.mIndex && [model.mTitle
    if ([model.mTitle isEqualToString:rowModel.mTitle]) {
        cell.textLabel.textColor = [UIColor redColor];
    }else {
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DFNotice post:@"indexPathRow" Object:@{@"row":@(indexPath.row)}];
    [[DFAudioPlayer sharedMe_2] setNetPaths:listArray];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[DFAudioPlayer sharedMe] didStop];
        [[DFAudioPlayer sharedMe_2] didPlay:indexPath.row];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });
}

- (void)musicState:(NSNotification *)note {
    [DFAction mainTask:^{
        [self.listTable reloadData];
    }];
}

//- (UITableView *)listTable {
//    if (!_listTable) {
//        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
//        _listTable.delegate = self;
//        _listTable.dataSource = self;
//        _listTable.tableFooterView = UIView.new;
//        _listTable.rowHeight = 30;
//        _listTable.scrollEnabled = NO;
//        _listTable.backgroundColor = [UIColor clearColor];
//        _listTable.allowsSelection = YES;
//        [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//
//    }
//    return _listTable;
//}
@end
