//
//  JL_BDMusic.h
//  Test
//
//  Created by DFung on 2017/11/24.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @"MS_NAME"
 *  @"MS_AUTHOR"
 *  @"MS_PIC"
 *  @"MS_URL"
 */
#define kJL_BDMUSIC_RET @"JL_BDMUSIC_RET"

@interface JL_BDMusic : NSObject

-(void)searchMusic:(NSString*)info;
+(void)searchMusic:(NSString*)info Result:(void(^)(NSDictionary*dic))block;
+(void)searchMusic_1:(NSString*)info Result:(void(^)(NSArray*arr,NSString*more))block;
+(void)searchMusic_2:(NSString*)info Result:(void(^)(NSArray*arr,NSString*more))block;


@end
