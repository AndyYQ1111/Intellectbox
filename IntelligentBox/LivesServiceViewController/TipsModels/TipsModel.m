//
//  TipsModel.m
//  IntelligentBox
//
//  Created by jieliapp on 2017/11/13.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "TipsModel.h"

@implementation TipsModel


-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    if (self) {
        self.typeString = dictionary[@"type"];
        self.albumIntro = dictionary[@"albumIntro"];
        self.tipImg = dictionary[@"image"];
    }
    
    return self;
}


-(NSDictionary *)toDictionary{
    NSDictionary *dict = @{@"image":self.tipImg,@"type":self.typeString,@"albumIntro":self.albumIntro};
    return dict;
}

@end
