//
//  TipsModel.h
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TipsModel : NSObject

@property (nonatomic,strong) NSString *typeString;
@property (nonatomic,strong) NSString *albumIntro;
@property (nonatomic,strong) UIImage  *tipImg;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
