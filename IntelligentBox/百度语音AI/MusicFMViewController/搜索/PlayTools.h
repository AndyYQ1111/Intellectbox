//
//  PlayTools.h
//  IntelligentBox
//
//  Created by KW on 2018/8/15.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicMainModel.h"

@interface PlayTools : NSObject
+ (instancetype)shareManage;
- (void)playWithModel:(SearchDataModel *)songitem;
@end
