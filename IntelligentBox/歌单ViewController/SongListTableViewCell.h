//
//  SongListTableViewCell.h
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SongListTableViewCell : BaseTableViewCell
@property (nonatomic, copy) void(^SongListCellBlock)(void);

+ (instancetype)cellWithTableView:(UITableView*)tableView;
- (void)assginWithTitle:(NSString *)title duration:(NSString *)duration isCollection:(BOOL)collection isplaying:(BOOL)playing;
@end
