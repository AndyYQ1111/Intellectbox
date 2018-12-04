//
//  GetLocalization.h
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/29.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetLocalizate)(NSString *city);

@interface GetLocalization : NSObject

@property(nonatomic,copy)GetLocalizate localBlock;

+(instancetype)sharedInstance;
-(void)startUpdateLocalization:(GetLocalizate )result;

@end
