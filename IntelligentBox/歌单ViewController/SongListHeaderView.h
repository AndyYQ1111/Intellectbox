//
//  SongListHeaderView.h
//  IntelligentBox
//
//  Created by KW on 2018/8/13.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongListHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView*)tableView;

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, copy) void (^SongListHeaderViewBlock)(NSInteger index);
@end
