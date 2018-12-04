//
//  OTSongInfo.h
//  IntelligentBox
//
//  Created by Ezio on 13/03/2018.
//  Copyright © 2018 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSongInfo : NSObject

@property(nonatomic,strong)NSString *getId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,assign)int      size;
@property(nonatomic,assign)int      timelen;

#pragma mark<- 基于语义获取歌曲接口才会有的 ->
@property(nonatomic,strong)NSString *talkUrl;
@property(nonatomic,strong)NSString *songUrl;
@property(nonatomic,strong)NSString *talkValue;
@property(nonatomic,strong)NSString *songName;
@property(nonatomic,strong)NSString *songAuthor;
@property(nonatomic,strong)NSString *songSmallPicUrl;
@property(nonatomic,strong)NSString *songBigPicUrl;
@property(nonatomic,strong)NSString *songId;
@property(nonatomic,strong)NSString *songTimeLen;
@property(nonatomic,strong)NSString *albumId;
@property(nonatomic,assign)int      field;
@property(nonatomic,strong)NSString *intentionParam_1;
@property(nonatomic,strong)NSString *intentionParam_2;

+(OTSongInfo *)apiResponseToObject:(NSDictionary *)dict;

+(NSDictionary *)apiResponseToDictionary:(OTSongInfo *)response;
@end
