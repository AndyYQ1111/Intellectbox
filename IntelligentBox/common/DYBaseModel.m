//
//  DYBaseModel.m
//  DanYaForMerchant
//
//  Created by WEISON on 17/9/8.
//  Copyright © 2017年 siso. All rights reserved.
//

#import "DYBaseModel.h"

@implementation DYBaseModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    
    if ([keyedValues isKindOfClass:[NSDictionary class]] && keyedValues != nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:keyedValues];
        NSMutableArray *array = [NSMutableArray arrayWithArray:keyedValues.allKeys];
        for (NSString *key in array) {
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [self setValue:@"" forKey:key];
            }else {
                [self setValue:[NSString stringWithFormat:@"%@",[dic objectForKey:key]] forKey:key];
            }
        }
    }
}
@end
