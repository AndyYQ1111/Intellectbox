//
//  SearchNavView.h
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchNavView : UIView
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, copy) void(^SearchBlock)(NSString *key);
@property (nonatomic, copy) void(^DismissBlock)(void);
@end
