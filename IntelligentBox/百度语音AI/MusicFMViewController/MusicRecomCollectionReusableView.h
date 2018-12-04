//
//  MusicRecomCollectionReusableView.h
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicRecomCollectionReusableView : UICollectionReusableView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^MusicHeaderViewBlock)(void);
@end
