//
//  MusicCollectionView.h
//  IntelligentBox
//
//  Created by KW on 2018/8/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicMainModel.h"

@interface MusicCollectionView : UICollectionView
@property (nonatomic, strong) MusicMainModel *model;
@end
