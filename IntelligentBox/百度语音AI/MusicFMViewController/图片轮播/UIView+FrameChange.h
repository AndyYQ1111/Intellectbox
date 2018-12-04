//
//  UIView+FrameChange.h
//  pwd
//
//  Created by WEISON on 16/12/3.
//  Copyright © 2016年 siso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameChange)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign, readonly) CGFloat bottomFromSuperView;
@end
