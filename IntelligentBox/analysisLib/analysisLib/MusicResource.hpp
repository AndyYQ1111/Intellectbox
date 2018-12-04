//
//  MusicResource.hpp
//  AnalysisDemo
//
//  Created by ShawnHuen on 2018/3/8.
//  Copyright © 2018年 oldtree. All rights reserved.
//

#ifndef MusicResource_hpp
#define MusicResource_hpp

#include <stdio.h>
#include <string>
#include "MainPageResult.hpp"
#include "AlbumListResult.hpp"
#include "SongListResult.hpp"

// net error call back.
typedef void (*NetErrorFunc)(int errorCode);

class MusicResource
{
private :
    NetErrorFunc NetErrorCallback;
public :
    MainPageResult* getMainPage(int timeoutOnce, int timeoutCnt);
    AlbumListResult* getAlbumList(std::string classId, int timeoutOnce, int timeoutCnt, int page, int count, std::string sort);
    SongListResult* getSongList(std::string albumId, int timeoutOnce, int timeoutCnt, int page, int count, std::string sort);
    
    // register net error function.
    void registerNetErrorFunc(NetErrorFunc func);
};

#endif /* MusicResource_hpp */
