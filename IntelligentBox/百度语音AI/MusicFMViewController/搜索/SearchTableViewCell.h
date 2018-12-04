//
//  SearchTableViewCell.h
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SearchTableViewCell : BaseTableViewCell
+ (instancetype)cellWithTableView:(UITableView*)tableView;

//除了搜索界面; 播放历史有删除按钮; 收藏记录有播放按钮
- (void)assignWithFace:(NSString *)face title:(NSString *)title duration:(NSString *)duration btnTitle:(NSString *)btnTitle;

@property (nonatomic, copy) void(^SearchTableViewCellBlock)(void);
@end
