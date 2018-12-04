//
//  Translate.h
//  testTeam
//
//  Created by ShawnHuen on 2018/6/25.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef Translate_h
#define Translate_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TranslateResult.h"

@protocol TranslateNetErrorDelegate <NSObject>
@required
- (void)TranslateNetError:(NSError *)error;

@end

@interface Translate : NSObject {
    id <TranslateNetErrorDelegate> translateNetErrorDelegate;
}
@property (nonatomic,strong) id translateNetErrorDelegate;
- (TranslateResult *)translate:(NSData *)localFilePath andSourceLanguage:(NSString *)sourceLanguage andTargetlanguage:(NSString *)targetLanguage;
@end


#endif /* Translate_h */
