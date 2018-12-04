//
//  PersonProcessor.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "PersonProcessor.h"


@implementation PersonProcessor

+(void)handleWithDictionary:(NSDictionary *)resultDic{


    NSDictionary *mainObjc = resultDic[@"object"];
    NSString *nameStr = mainObjc[@"person"];
    NSString *titleStr = mainObjc[@"title"];
    NSMutableString *tmpStr = [[NSMutableString alloc] init];
    if (!nameStr) {
        if (titleStr) {
            
            [tmpStr appendString:titleStr];
        }
        
    }else{
        
        [tmpStr appendString:nameStr];
        
    }
    
    


}

@end
