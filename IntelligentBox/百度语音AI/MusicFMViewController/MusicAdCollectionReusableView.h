//
//  MusicAdCollectionReusableView.h
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicAdCollectionReusableView : UICollectionReusableView
- (void)assignWithAd:(NSArray *)adArr sortArray:(NSArray *)sortArr;

@property (nonatomic, copy) void (^MusicAdCellBlock)(NSInteger index);
@end
