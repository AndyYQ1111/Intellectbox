//
//  OTSongInfo.m
//  IntelligentBox
//
//  Created by Ezio on 13/03/2018.
//  Copyright © 2018 Zhuhia Jieli Technology. All rights reserved.
//

#import "OTSongInfo.h"

@implementation OTSongInfo
+(OTSongInfo *)apiResponseToObject:(NSDictionary *)dict{
    OTSongInfo *response = [[OTSongInfo alloc] init];
    response.songName        = dict[@"title"];      //歌曲名
    response.songAuthor      = dict[@"singer"];     //歌手名
    response.songUrl         = dict[@"url"];        //歌曲播放URL
    response.songSmallPicUrl = dict[@"img_0"];      //小图
    response.songBigPicUrl   = dict[@"img_1"];      //大图

    return response;
}

+(NSDictionary *)apiResponseToDictionary:(OTSongInfo *)response{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (response.songId) {
        [dict setValue:[NSString stringWithFormat:@"%@",response.songId] forKey:@"id"];
    }
    
    if (response.songName) {
        [dict setValue:response.songName forKey:@"title"];          //歌曲名
    }else{
        [dict setValue:response.title?:@"unknow" forKey:@"title"];  
    }
    
    if (response.songAuthor) {
        [dict setValue:response.songAuthor forKey:@"singer"];       //歌手名
    }

    if (response.songUrl) {
        [dict setValue:response.songUrl forKey:@"url"];             //歌曲播放URL
    }
    
    if (response.songSmallPicUrl) {
        [dict setValue:response.songSmallPicUrl forKey:@"img_0"];   //歌曲播放URL
    }
    if (response.songBigPicUrl) {
        [dict setValue:response.songBigPicUrl forKey:@"img_1"];     //歌曲播放URL
    }
    
    return dict;
}
@end
