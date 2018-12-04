//
//  BaseNavigationView.h
//  IntelligentBox
//
//  Created by KW on 2018/8/9.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationView : UIView

@property (nonatomic, copy) void(^KWBaseBackBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)aTitle;
@end
