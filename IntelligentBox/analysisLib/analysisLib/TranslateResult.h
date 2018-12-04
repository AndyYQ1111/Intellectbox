//
//  TranslateResult.h
//  testTeam
//
//  Created by ShawnHuen on 2018/6/25.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef TranslateResult_h
#define TranslateResult_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TranslateResult : NSObject{
    NSString *sourceString;
    NSString *targetString;
    NSString *targetUrl;
}

@property(nonatomic,copy) NSString *sourceString;
@property(nonatomic,copy) NSString *targetString;
@property(nonatomic,copy) NSString *targetUrl;

@end
#endif /* TranslateResult_h */
