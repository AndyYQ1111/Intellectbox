//
//  OldTreeManager.h
//  IntelligentBox
//
//  Created by Ezio on 09/03/2018.
//  Copyright © 2018 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAnalysisResult.h"
#import "OTTapResult.h"
#import "OTAlbumInfo.h"
#import "OTSongInfo.h"



@interface OldTreeManager : NSObject

+(instancetype)sharedInstance;

/**
   获取登录状态
 */
-(BOOL)getLoginState;

/**
 登录

 @param loginId 登录ID
 @param block 回调
 */
-(void)oldTreeLogin:(NSString *)loginId Result:(void(^)(BOOL status))block;

/**
 语音合成
 */
-(void)oldTreeTTS:(NSString *)text Result:(void(^)(NSString* url))block;

/**
 语义解析

 @param aText 语义内容
 @param block 返回OTAnalysisResult
 */
-(void)oldTreeAnalysisText:(NSString *)aText Result:(void(^)(OTAnalysisResult *result,BOOL status)) block;


/**
 首页推荐接口

 @param block NSDictionary @{@"tap":mainPageArray,@"latest":latestAlbumArray,@"base":baseAlbumArray}
 */
-(void)OldTreeMainFirst:(void(^)(NSDictionary *result)) block;

/**
 分类歌曲获取

 @param albumId 分类ID
 @param page 页数
 @param count 每页个数
 @param block 歌曲列表+recordSum+pageSum
 */
-(void)oldTreeSongListRequest:(NSString *)albumId withPage:(int)page Count:(int)count Result:(void(^)(NSArray *result,int recordSum,int pageSum))block;


/**
 获取分类专辑

 @param classId classid
 @param timeOut 超时
 @param cnt 重发次数
 @param page 请求页数
 @param count 请求数量
 @param block 专辑列表+recordSum+pageSum
 */
-(void)oldTreeGetAlbumList:(NSString *)classId TimeOut:(int)timeOut TimeCnt:(int)cnt Page:(int)page Count:(int)count Result:(void(^)(NSArray *result,int recordSum,int pageSum)) block;



/**
 获取专辑详细信息

 @param albumId 专辑ID
 @param timeout 超时
 @param cnt 重连次数
 @param block OTAlbumInfo
 */
-(void)oldTreequeryAlbum:(NSString *)albumId TimeOut:(int)timeout TimeCnt:(int)cnt Result:(void(^)(OTAlbumInfo *result))block;



/**
 获取详细歌曲列表（语义）

 @param songIdArray 歌曲列表
 @param timeout 超时
 @param cnt 重连次数
 @param block NSArray 
 */
-(void)oldTreePlaySongInfo:(NSArray *)songIdArray TimeOut:(int)timeout TimeCnt:(int)cnt Result:(void(^)(NSArray *result))block;



/**
 退出License占用
 需要在退出APP的时候，或者关闭APP的时候使用，作用是关闭License占用
 */
-(void)oldTreeExitLicense;


@end
