//
//  OldTreeManager.m
//  IntelligentBox
//
//  Created by Ezio on 09/03/2018.
//  Copyright © 2018 Zhuhia Jieli Technology. All rights reserved.
//

#import "OldTreeManager.h"
#include "Analysis.hpp"
#include "MainPageResult.hpp"
#include "MusicResource.hpp"

//typedef void(^loginBlock)(BOOL status);
typedef void(^analysisResult)(OTAnalysisResult *result,BOOL status);
typedef void(^mPageResult)(NSDictionary *result);
typedef void(^mSongInfoResult)(NSArray *result,int recordSum,int pageSum);
typedef void(^mAlbumListResult)(NSArray *result,int recordSum,int pageSum);
typedef void(^mAlbumQueueResult)(OTAlbumInfo *result);
typedef void(^mPlaySongResult)(NSArray *result);


static Analysis *analysis = NULL;
static MusicResource *musicResource = NULL;

#pragma mark - 错误返回
void oldTreeNetErrorReturn(int errCode){
    printf("---> OldTree Err:%d",errCode);
    if (errCode ==  1 ||
        errCode == -1 ||
        errCode == -2) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OLDTREE_ERR"
                                                                object:@(errCode)];
        });
    }
}

@interface OldTreeManager(){
    
    BOOL isLogin;
}
@end

@implementation OldTreeManager


+(instancetype)sharedInstance{
    static OldTreeManager *me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[OldTreeManager alloc] init];
    });
    
    if (analysis == NULL) {
        analysis = new Analysis();
        analysis->registerNetErrorFunc(oldTreeNetErrorReturn);
        analysis->init();
        analysis->setTtsPerson(1);//0:童声 1:女声 2:男声
        musicResource = new MusicResource();
        musicResource->registerNetErrorFunc(oldTreeNetErrorReturn);
    }
    return me;
}

-(BOOL)getLoginState{
    return isLogin;
}

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        analysis = new Analysis();
        analysis->registerNetErrorFunc(oldTreeNetErrorReturn);
        analysis->init();
        analysis->setTtsPerson(1); //0:童声 1:女生 2:男生
        musicResource = new MusicResource();
        musicResource->registerNetErrorFunc(oldTreeNetErrorReturn);
    }
    return self;
}
#pragma mark <- 登录 ->
-(void)oldTreeLogin:(NSString *)loginId Result:(void(^)(BOOL status))block{
    isLogin = YES;

    //loginBlock loginB = block;
    char *login = (char *)[loginId UTF8String];
    bool ret = (analysis->login(login));
    //NSLog(@"---> OldTree Login : %d",ret);
    if (ret) {
        isLogin = YES;
        block(YES);
    }else{
        isLogin = NO;
        block(NO);
    }
}
#pragma mark <- 语音合成 ->
-(void)oldTreeTTS:(NSString *)text Result:(void(^)(NSString* url))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *txt = (char *)[text UTF8String];
        NSString *tts_url = [NSString stringWithCString:analysis->tts(txt).c_str()
                                           encoding:[NSString defaultCStringEncoding]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)block(tts_url);
        });
    });
}


#pragma mark <- 语义解析 ->
-(void)oldTreeAnalysisText:(NSString *)aText Result:(void(^)(OTAnalysisResult *result,BOOL status)) block {
    
    if (!isLogin) {
        block(nil,NO);
        return;
    }
    
    analysisResult resultBlock = block;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AnalysisResult* result = analysis->ask([aText UTF8String]);
        if (result == nil) {
            resultBlock(nil,NO);
        }else{
            OTAnalysisResult *otar = [[OTAnalysisResult alloc] init];
            otar.talkUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->url1.c_str()]);
            
            if (!result->getTalkUrl().empty()) {
                otar.talkValue = stringByReplaceUnicode([NSString stringWithUTF8String:result->getTalkUrl().c_str()]);
            }
            if (!result->getSongUrl().empty()) {
                otar.songUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongUrl().c_str()]);
            }
            if(!result->getTalkValue().empty()) {
                otar.talkValue = stringByReplaceUnicode([NSString stringWithUTF8String:result->getTalkValue().c_str()]);
            }
            if(!result->getSongName().empty()) {
                otar.songName = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongName().c_str()]);
            }
            if(!result->getSongAuthor().empty()) {
                otar.songAuthor = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongAuthor().c_str()]);
            }
            if(!result->getSongSmallPicUrl().empty()) {
                
                otar.songSmallPicturl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongSmallPicUrl().c_str()]);
                
            }
            if(!result->getSongBigPicUrl().empty()) {
                otar.songBigPicturl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongBigPicUrl().c_str()]);
            }
            if(!result->getSongId().empty()) {
                
                [otar setSongId:[NSString stringWithUTF8String:result->getSongId().c_str()]];
                
            }
            otar.songTimelen = result->getSongTimeLen();
            if(!result->getAlbumId().empty()) {
                otar.albumId = stringByReplaceUnicode([NSString stringWithUTF8String:result->getAlbumId().c_str()]);
            }
            
            otar.field = result->getField();
            otar.intention = result->getIntention();
            if(!result->getIntentionParam1().empty()) {
                otar.intentionParam1 = stringByReplaceUnicode([NSString stringWithUTF8String:result->getIntentionParam1().c_str()]);
            }
            if(!result->getIntentionParam2().empty()) {
                otar.intentionParam2 =  stringByReplaceUnicode([NSString stringWithUTF8String:result->getIntentionParam2().c_str()]);
            }
            
            resultBlock(otar,YES);
        }
    });
}

#pragma mark <- 首页推荐内容 ->
-(void)OldTreeMainFirst:(void(^)(NSDictionary *result)) block{
    
    if (!isLogin) {
        block(nil);
        return;
    }
    
    mPageResult mainBlock = block;
    //dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainPageResult *mainPageResult = musicResource->getMainPage(30, 1);
        
        std::vector<MainPageClassResult*> mainPageClassResult = mainPageResult->getMainPageClassResult();
        std::vector<AlbumInfo*> latestAlbumInfoResult = mainPageResult->getLatestAlbumResult();
        std::vector<AlbumInfo*> baseAlbumInfoResult = mainPageResult->getBestAlbumResult();
        
        NSMutableArray *mainPageArray = [NSMutableArray new];
        for (int i = 0; i< mainPageClassResult.size(); i++) {
            OTTapResult *tap = [[OTTapResult alloc] init];
            if(!mainPageClassResult.at(i)->getCoverUrl().empty()) {
                tap.coverUrl = stringByReplaceUnicode([NSString stringWithUTF8String:mainPageClassResult.at(i)->getCoverUrl().c_str()]);
            }
            if(!mainPageClassResult.at(i)->getId().empty()) {
                tap.getId = stringByReplaceUnicode([NSString stringWithUTF8String:mainPageClassResult.at(i)->getId().c_str()]);
            }
            if(!mainPageClassResult.at(i)->getTitle().empty()) {
                tap.title = stringByReplaceUnicode([NSString stringWithUTF8String:mainPageClassResult.at(i)->getTitle().c_str()]);
            }
            
            [mainPageArray addObject:tap];
        }
        
        NSMutableArray *latestAlbumArray = [NSMutableArray new];
        for (int j = 0; j<latestAlbumInfoResult.size(); j++) {
            OTAlbumInfo *info = [[OTAlbumInfo alloc] init];
            if(!latestAlbumInfoResult.at(j)->getCoverUrl().empty()) {
                info.coverUrl = stringByReplaceUnicode([NSString stringWithUTF8String:latestAlbumInfoResult.at(j)->getCoverUrl().c_str()]);
            }
            if(!latestAlbumInfoResult.at(j)->getId().empty()) {
                info.getId = stringByReplaceUnicode([NSString stringWithUTF8String:latestAlbumInfoResult.at(j)->getId().c_str()]);
            }
            if (!latestAlbumInfoResult.at(j)->getInfo().empty()) {
                info.info = stringByReplaceUnicode([NSString stringWithUTF8String:latestAlbumInfoResult.at(j)->getInfo().c_str()]);
            }
            if(!latestAlbumInfoResult.at(j)->getTitle().empty()) {
                info.title = stringByReplaceUnicode([NSString stringWithUTF8String:latestAlbumInfoResult.at(j)->getTitle().c_str()]);
            }
            if (!latestAlbumInfoResult.at(j)->getAuthor().empty()) {
                info.author = stringByReplaceUnicode([NSString stringWithUTF8String:latestAlbumInfoResult.at(j)->getAuthor().c_str()]);
            }
            
            [latestAlbumArray addObject:info];
            
        }
        
        
        NSMutableArray *baseAlbumArray = [NSMutableArray new];
        
        for (int k = 0; k< baseAlbumInfoResult.size(); k++) {
            
            OTAlbumInfo *info = [[OTAlbumInfo alloc] init];
            if(!baseAlbumInfoResult.at(k)->getCoverUrl().empty()) {
                info.coverUrl = stringByReplaceUnicode([NSString stringWithUTF8String:baseAlbumInfoResult.at(k)->getCoverUrl().c_str()]);
            }
            if(!baseAlbumInfoResult.at(k)->getId().empty()) {
                info.getId = stringByReplaceUnicode([NSString stringWithUTF8String:baseAlbumInfoResult.at(k)->getId().c_str()]);
            }
            if (!baseAlbumInfoResult.at(k)->getInfo().empty()) {
                info.info = stringByReplaceUnicode([NSString stringWithUTF8String:baseAlbumInfoResult.at(k)->getInfo().c_str()]);
            }
            if(!baseAlbumInfoResult.at(k)->getTitle().empty()) {
                info.title = stringByReplaceUnicode([NSString stringWithUTF8String:baseAlbumInfoResult.at(k)->getTitle().c_str()]);
            }
            if (!baseAlbumInfoResult.at(k)->getAuthor().empty()) {
                info.author = stringByReplaceUnicode([NSString stringWithUTF8String:baseAlbumInfoResult.at(k)->getAuthor().c_str()]);
            }
            
            [baseAlbumArray addObject:info];
            
        }
        
        NSDictionary *dict = @{@"tap":mainPageArray,@"latest":latestAlbumArray,@"base":baseAlbumArray};
        mainBlock(dict);
        
    //});
}

#pragma mark <- 分类歌曲获取 ->
-(void)oldTreeSongListRequest:(NSString *)albumId
                     withPage:(int)page
                        Count:(int)count
                       Result:(void(^)(NSArray *result,
                                       int recordSum,
                                       int pageSum))block
{
    if (!isLogin) {
        block(nil,0,0);
        return;
    }
    
    
    mSongInfoResult mBlock = block;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SongListResult *songListResult = musicResource->getSongList([albumId UTF8String], 30, 1, page, count, "asc");
        
        if (songListResult) {
            
            NSMutableArray *tmpArray = [NSMutableArray new];
            for (int i = 0; i<songListResult->songInfo.size(); i++) {
                OTSongInfo *songInfo = [[OTSongInfo alloc] init];
                if(!songListResult->songInfo.at(i)->getId().empty()) {
                    songInfo.getId = stringByReplaceUnicode([NSString stringWithUTF8String:songListResult->songInfo.at(i)->getId().c_str()]);
                }
                if(!songListResult->songInfo.at(i)->getTitle().empty()) {
                    songInfo.title = stringByReplaceUnicode([NSString stringWithUTF8String:songListResult->songInfo.at(i)->getTitle().c_str()]);
                }
                if(!songListResult->songInfo.at(i)->getUrl().empty()) {
                    songInfo.url = stringByReplaceUnicode([NSString stringWithUTF8String:songListResult->songInfo.at(i)->getUrl().c_str()]);
                }
                songInfo.size = songListResult->songInfo.at(i)->getSize();
                songInfo.timelen = songListResult->songInfo.at(i)->getTimeLen();
                [tmpArray addObject:songInfo];
            }
            
            mBlock(tmpArray,songListResult->recordSum,songListResult->pageSum);
        }else{
            
            mBlock(nil,0,0);
            
        }
    });
}

#pragma mark <- 获取分类 ->
-(void)oldTreeGetAlbumList:(NSString *)classId
                   TimeOut:(int)timeOut
                   TimeCnt:(int)cnt
                      Page:(int)page
                     Count:(int)count
                    Result:(void(^)(NSArray *result,
                                    int recordSum,
                                    int pageSum)) block
{
    if (!isLogin) {
        block(nil,0,0);
        return;
    }
    mAlbumListResult albumBlock = block;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AlbumListResult *albumListResult = musicResource->getAlbumList([classId UTF8String], timeOut, cnt, page, count, "asc");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (albumListResult) {
                NSMutableArray *tmpArray = [NSMutableArray new];
                for (int i = 0; i<albumListResult->albumInfo.size(); i++) {
                    
                    OTAlbumInfo *info = [[OTAlbumInfo alloc] init];
                    
                    if(!albumListResult->albumInfo.at(i)->getId().empty()) {
                        info.getId = stringByReplaceUnicode([NSString stringWithUTF8String:albumListResult->albumInfo.at(i)->getId().c_str()]);
                    }
                    if(!albumListResult->albumInfo.at(i)->getTitle().empty()) {
                        info.title = stringByReplaceUnicode([NSString stringWithUTF8String:albumListResult->albumInfo.at(i)->getTitle().c_str()]);
                    }
                    if(!albumListResult->albumInfo.at(i)->getCoverUrl().empty()) {
                        info.coverUrl = stringByReplaceUnicode([NSString stringWithUTF8String:albumListResult->albumInfo.at(i)->getCoverUrl().c_str()]);
                    }
                    if(!albumListResult->albumInfo.at(i)->getInfo().empty()) {
                        info.info = stringByReplaceUnicode([NSString stringWithUTF8String:albumListResult->albumInfo.at(i)->getInfo().c_str()]);
                    }
                    if(!albumListResult->albumInfo.at(i)->getAuthor().empty()) {
                        info.author =  stringByReplaceUnicode([NSString stringWithUTF8String:albumListResult->albumInfo.at(i)->getAuthor().c_str()]);
                    }
                    [tmpArray addObject:info];
                }
                
                albumBlock(tmpArray,albumListResult->recordSum,albumListResult->pageSum);
                
            }else{
                
                albumBlock(nil,0,0);
                
            }
        });
        
    });
    
    
}

#pragma mark <- 获取专辑（语义之后的操作） ->
-(void)oldTreequeryAlbum:(NSString *)albumId
                 TimeOut:(int)timeout
                 TimeCnt:(int)cnt
                  Result:(void(^)(OTAlbumInfo *result))block
{
    if (!isLogin) {
        block(nil);
        return;
    }
    mAlbumQueueResult albumBlock = block;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AlbumResult *result = analysis->queryAlbum([albumId UTF8String], timeout, cnt);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(result == NULL) {
                NSLog(@"获取失败");
                albumBlock(nil);
            } else {
                OTAlbumInfo *albumInfo = [[OTAlbumInfo alloc] init];
                if (!result->getAuthor().empty()) {
                    albumInfo.author_1 = stringByReplaceUnicode([NSString stringWithUTF8String:result->getAuthor().c_str()]);
                }
                if (!result->getBigPicUrl().empty()) {
                    albumInfo.bigPicUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getBigPicUrl().c_str()]);
                }
                if (!result->getSmallPicUrl().empty()) {
                    albumInfo.smallPicUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSmallPicUrl().c_str()]);
                }
                if (!result->getSongId().empty()) {
                    albumInfo.songCount = (int)result->getSongId().size();
                    NSMutableArray *songArray = [NSMutableArray new];
                    for(int i = 0; i<albumInfo.songCount; i++) {
                        NSString *str = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongId().at(i).c_str()]);
                        [songArray addObject:str];
                    }
                    albumInfo.songArray = songArray;
                }
                if (!result->getSongName().empty()) {
                    int ex = (int)result->getSongName().size();
                    NSMutableArray *songArray = [NSMutableArray new];
                    for(int i = 0; i<ex; i++) {
                        NSString *str = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongName().at(i).c_str()]);
                        [songArray addObject:str];
                    }
                    albumInfo.songNameArray = songArray;
                    
                }
                if (!result->getSongAuthor().empty()) {
                    int ex = (int)result->getSongAuthor().size();
                    NSMutableArray *songArray = [NSMutableArray new];
                    for(int i = 0; i<ex; i++) {
                        NSString *str = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongAuthor().at(i).c_str()]);
                        [songArray addObject:str];
                    }
                    albumInfo.authorArray = songArray;
                }
                if (!result->getSongPicUrl().empty()) {
                    int ex = (int)result->getSongPicUrl().size();
                    NSMutableArray *songArray = [NSMutableArray new];
                    for(int i = 0; i<ex; i++) {
                        NSString *str = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongPicUrl().at(i).c_str()]);
                        [songArray addObject:str];
                    }
                    albumInfo.songPicArray = songArray;
                }
                if (!result->getName().empty()) {
                    albumInfo.sName = stringByReplaceUnicode([NSString stringWithUTF8String:result->getName().c_str()]);
                }
                if (!result->getInfo().empty()) {
                    albumInfo.sInfo = stringByReplaceUnicode([NSString stringWithUTF8String:result->getInfo().c_str()]);
                }
                albumBlock(albumInfo);
            }
        });
        
    });
    
    
    
}

#pragma mark <- 获取歌曲(语义分析) ->
-(void)oldTreePlaySongInfo:(NSArray *)songIdArray
                   TimeOut:(int)timeout
                   TimeCnt:(int)cnt
                    Result:(void(^)(NSArray *result))block
{
    if (!isLogin) {
        block(nil);
        return;
    }
    mPlaySongResult playSongBlock = block;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *otsongInfoArray = [NSMutableArray new];
        if(songIdArray.count>0){
            std::vector<std::string> songIds;
            for(NSString *songId in songIdArray) {
                songIds.push_back([songId UTF8String]);
            }
            std::vector<AnalysisResult *> resultList  = analysis->playSong(songIds, 30, 1);
            for (int i = 0; i<resultList.size(); i++) {
                AnalysisResult * result = resultList.at(i);
                if(result == NULL) {
                    NSLog(@"获取失败");
                    // playSongBlock(nil);
                } else {
                    OTSongInfo *songInfo = [OTSongInfo new];
                    
                    if (!result->getTalkUrl().empty()) {
                        songInfo.talkUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getTalkUrl().c_str()]);
                    }
                    if (!result->getSongUrl().empty()) {
                        songInfo.songUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongUrl().c_str()]);
                    }
                    if(!result->getTalkValue().empty()) {
                        songInfo.talkValue = stringByReplaceUnicode([NSString stringWithUTF8String:result->getTalkValue().c_str()]);
                    }
                    if(!result->getSongName().empty()) {
                        songInfo.songName = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongName().c_str()]);
                    }
                    if(!result->getSongAuthor().empty()) {
                        songInfo.songAuthor = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongAuthor().c_str()]);
                    }
                    if(!result->getSongSmallPicUrl().empty()) {
                        songInfo.songSmallPicUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongSmallPicUrl().c_str()]);
                    }
                    if(!result->getSongBigPicUrl().empty()) {
                        songInfo.songBigPicUrl = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongBigPicUrl().c_str()]);
                    }
                    if(!result->getSongId().empty()) {
                        songInfo.songId = stringByReplaceUnicode([NSString stringWithUTF8String:result->getSongId().c_str()]);
                    }
                    songInfo.timelen = result->getSongTimeLen();
                    if(!result->getAlbumId().empty()) {
                        songInfo.albumId = stringByReplaceUnicode([NSString stringWithUTF8String:result->getAlbumId().c_str()]);
                    }
                    
                    
                    songInfo.field = result->getField();
                    
                    if(!result->getIntentionParam1().empty()) {
                        songInfo.intentionParam_1 = stringByReplaceUnicode([NSString stringWithUTF8String:result->getIntentionParam1().c_str()]);
                    }
                    if(!result->getIntentionParam2().empty()) {
                        songInfo.intentionParam_2 = stringByReplaceUnicode([NSString stringWithUTF8String:result->getIntentionParam2().c_str()]);
                    }
                    
                    [otsongInfoArray addObject:songInfo];
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                playSongBlock(otsongInfoArray);
            });
        }
    });
}


-(void)oldTreeExitLicense{
    analysis->exitAnalysis();
    analysis = NULL;
    isLogin = NO;
}

NSString* stringByReplaceUnicode(NSString* unicodeString)
{
    if(unicodeString==nil){
        return nil;
    }
    NSMutableString *convertedString = [unicodeString mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}

@end
